#!/bin/bash

icon=$HOME/dotfiles/assets/icons/brightness.png
icon_show=false

getCurrentBrightness() {
  current=$(cat /sys/class/backlight/*/brightness)
  max=$(cat /sys/class/backlight/*/max_brightness)
  percentage=$(((current * 100) / max))
  echo "$percentage%"
}

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [--up | --down]"
  echo ""
  echo "  --up   : Increase brightness by 5%"
  echo "  --down : Decrease brightness by 5%"
  exit 1
fi

notify_args=()
if [[ "$icon_show" == "true" ]]; then
  notify_args+=("-i" "$icon" "Brightness Control")
else
  notify_args+=("Brightness Control")
fi

case $1 in
"--up")
  dunstctl close-all
  brightnessctl s +5%
  notify-send "${notify_args[@]}" "Brightness increased to $(getCurrentBrightness)"
  ;;
"--down")
  dunstctl close-all
  brightnessctl s 5%-
  notify-send "${notify_args[@]}" "Brightness decreased to $(getCurrentBrightness)"
  ;;
esac
