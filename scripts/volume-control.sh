#!/bin/bash

currentVolume="$(pactl list sinks | grep 'Volume:' | head -n 1 | awk '{print $5}')"
isMuted="$(pactl list sinks | grep 'Mute:' | head -n 1 | awk '{print $2 == "yes" ? "Muted" : "Unmuted"}')"

if [ $1 = "--up" ]; then
	pactl set-sink-volume @DEFAULT_SINK@ +5%
	notify-send "Volume increased to $currentVolume"
elif [ $1 = "--down" ]; then
	pactl set-sink-volume @DEFAULT_SINK@ -5%
	notify-send "Volume decreased to $currentVolume"
elif [ $1 = "--toggle" ]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
	notify-send "Volume $isMuted"
fi
