#!/usr/bin/env bash

output_dir="$HOME/Pictures/Screenshots"
file_name="Screenshot_$(date +%Y-%m-%d_%H%M%S).png"

mode="fullscreen"
output_path="${output_dir}/${file_name}"
copy_to_clipboard=true

function help() {
  cat <<EOF
Usage: $0 [options]
Options:
  -m, --mode <mode>        Specify the screenshot mode: fullscreen, region, window (default: ${mode})
  -o, --output <dir>       Specify the output file path (default: ${output_dir}/Screenshot_YYYY-MM-DD_HHMMSS.png)
  -c, --copy               Copy the screenshot to clipboard (default: ${copy_to_clipboard})
  -h, --help               Show this help message and exit

Modes:
  fullscreen   Capture the entire screen
  region       Capture a user-selected region
  window       Capture a user-selected window
EOF
}

function send_notify() {
  notify-send "Screenshow saved" \
    "Image saved in <i>${1}</i> and copied to clipboard." \
    -i "${1}"
}

function grab_region() {
  slurp -d
}

function grab_window() {
  local monitors=$(hyprctl -j monitors)
  local clients=$(hyprctl -j clients | jq -r '[.[] | select(.workspace.id | contains('$(echo $monitors | jq -r 'map(.activeWorkspace.id) | join(",")')'))]')
  local boxes="$(echo $clients | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' | cut -f1,2 -d' ')"
  slurp -r <<<"$boxes"
}

if [[ $# -eq 0 ]]; then
  help
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
  -m | --mode)
    mode="$2"
    shift 2
    ;;
  -o | --output)
    output_path="$2"
    shift 2
    ;;
  -h | --help)
    help
    exit
    ;;
  *)
    help
    exit 1
    ;;
  esac

done

mkdir -p "$(dirname "$output_path")"

case "$mode" in
fullscreen)
  grim "$output_path"
  ;;
region)
  region_box="$(grab_region)"
  if [[ -z "$region_box" ]]; then exit 1; fi
  grim -g "$region_box" "$output_path"
  ;;
window)
  window_box="$(grab_window)"
  if [[ -z "$window_box" ]]; then exit 1; fi
  grim -g "$window_box" "$output_path"
  ;;
*)
  help
  exit 1
  ;;
esac

if [[ "$copy_to_clipboard" == true ]]; then
  wl-copy --type image/png <"$output_path"
fi
send_notify "$output_path"
