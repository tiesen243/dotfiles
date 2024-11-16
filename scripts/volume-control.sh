#!/bin/bash

title="Volume"
currentVolume="$(pactl list sinks | grep 'Volume:' | head -n 1 | awk '{print $5}')"
isMuted="$(pactl list sinks | grep 'Mute:' | head -n 1 | awk '{print $2 == "yes" ? "Muted" : "Unmuted"}')"

if [ $1 = "up" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ +5% 
  notify-send $title "Increased to $currentVolume"
elif [ $1 = "down" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  notify-send $title "Decreased to $currentVolume"
elif [ $1 = "toggle" ]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  notify-send "$title" "$isMuted"
fi
