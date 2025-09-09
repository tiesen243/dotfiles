#!/usr/bin/env bash

file_name="Screenshot_$(date +%Y-%m-%d_%H%M%S).png"
output_dir="$HOME/Pictures/Screenshot"
mode="fullscreen"

function help() {
  cat <<EOF
Usage: $0 [options]
Options:
  -m, --mode <mode>        Specify the screenshot mode: fullscreen, region, window (default: fullscreen)
  -o, --output-dir <dir>   Specify the output directory (default: ~/Pictures/Screenshot)
  -n, --file-name <name>   Specify the file name (default: Screenshot_YYYY-MM-DD_HHMMSS.png)
  -h, --help               Show this help message and exit
EOF
}

function send_notify() {
  notify-send "Screenshow saved" \
    "Image saved in <i>${1}</i> and copied to clipboard." \
    -i "${1}"
}

function grab_window() {
  local monitors=$(hyprctl -j monitors)
  local clients=$(hyprctl -j clients | jq -r '[.[] | select(.workspace.id | contains('$(echo $monitors | jq -r 'map(.activeWorkspace.id) | join(",")')'))]')
  local boxes="$(echo $clients | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' | cut -f1,2 -d' ')"
  slurp -r <<<"$boxes"
}

function take_screenshot() {
  mkdir -p "$output_dir"

  case "$mode" in
  fullscreen)
    grim "${output_dir}/${file_name}"
    ;;
  region)
    grim -g "$(slurp -d)" "${output_dir}/${file_name}"
    ;;
  window)
    grim -g "$(grab_window)" "${output_dir}/${file_name}"
    ;;
  *)
    echo "Invalid mode: $mode"
    exit 1
    ;;
  esac

  wl-copy --type image/png <"${output_dir}/${file_name}"
  send_notify "${output_dir}/${file_name}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -m | --mode)
    mode="$2"
    shift 2
    ;;
  -o | --output-dir)
    output_dir="$2"
    shift 2
    ;;
  -n | --file-name)
    file_name="$2"
    shift 2
    ;;
  -h | --help)
    help
    exit
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac

done

take_screenshot "$mode" "$output_dir" "$file_name"
