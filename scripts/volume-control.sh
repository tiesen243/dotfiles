#!/bin/bash

icon=$HOME/dotfiles/assets/icons/volume.png
up_icon=$HOME/dotfiles/assets/icons/volume-up.png
down_icon=$HOME/dotfiles/assets/icons/volume-down.png
muted_icon=$HOME/dotfiles/assets/icons/volume-mute.png

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
  if [ "$(getCurrentVolume)" = "100%" ]; then
    notify-send -i "$up_icon" "Volume is already at 100%"
    exit 1
  fi

  pactl set-sink-volume @DEFAULT_SINK@ +5%
  notify-send -i "$up_icon" "Volume increased to $(getCurrentVolume)"
  ;;
"--down")
  if [ "$(getCurrentVolume)" = "0%" ]; then
    notify-send -i "$muted_icon" "Volume is already at 0%"
    exit 1
  fi

  pactl set-sink-volume @DEFAULT_SINK@ -5%
  notify-send -i "$down_icon" "Volume decreased to $(getCurrentVolume)"
  ;;
"--toggle-volume")
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  if [ "$(getVolumeStatus)" = "muted" ]; then
    notify-send -i "$muted_icon" "Volume muted"
  else
    notify-send -i "$icon" "Volume unmuted"
  fi
  ;;
"--show")
  notify-send -i "$icon" "Volume: $(getCurrentVolume)"
  ;;
esac
