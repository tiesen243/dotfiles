#!/usr/bin/env bash

file_name="Screenshot_$(date +%Y-%m-%d_%H%M%S).png"
output_dir="$HOME/Pictures/Screenshots"
mode="fullscreen"

function help() {
  cat <<EOF
Usage: $0 [options]
Options:
  -m, --mode <mode>        Specify the screenshot mode: fullscreen, region (default: fullscreen)
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

function grab_region() {
  slurp -d
}

function take_screenshot() {
  mkdir -p "$output_dir"

  case "$mode" in
  fullscreen)
    grim "${output_dir}/${file_name}"
    ;;
  region)
    region_box="$(grab_region)"
    if [[ -z "$region_box" ]]; then exit 1; fi
    grim -g "$region_box" "${output_dir}/${file_name}"
    ;;
  window)
    window_box="$(grab_window)"
    if [[ -z "$window_box" ]]; then exit 1; fi
    grim -g "$window_box" "${output_dir}/${file_name}"
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
