#!/bin/bash

getCurrentVolume() {
  volume=$(pactl list sinks | grep 'Volume:' | head -n 1 | awk '{print $5}')
  echo "$volume"
}

getVolumeStatus() {
  status=$(pactl list sinks | grep 'Mute:' | head -n 1 | awk '{print $2}')
  if [ "$status" = "yes" ]; then
    echo "muted"
  else
    echo "unmuted"
  fi
}

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [--up | --down | --toggle-volume | --show]"
  echo ""
  echo "  --up             : Increase volume by 5%"
  echo "  --down           : Decrease volume by 5%"
  echo "  --toggle-volume  : Toggle volume mute/unmute"
  echo "  --show           : Show current volume"
  exit 1
fi

case $1 in
"--up")
  dunstctl close-all
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  notify-send "Volume increased to $(getCurrentVolume)"
  ;;
"--down")
  dunstctl close-all
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  notify-send "Volume decreased to $(getCurrentVolume)"
  ;;
"--toggle-volume")
  dunstctl close-all
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  notify-send "Volume $(getVolumeStatus)"
  ;;
"--show")
  notify-send "Volume: $(getCurrentVolume)"
  ;;
esac
