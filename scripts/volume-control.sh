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

if [ $1 = "--up" ]; then
	dunstctl close-all
	pactl set-sink-volume @DEFAULT_SINK@ +5%
	notify-send "Volume increased to $(getCurrentVolume)"
elif [ $1 = "--down" ]; then
	dunstctl close-all
	pactl set-sink-volume @DEFAULT_SINK@ -5%
	notify-send "Volume decreased to $(getCurrentVolume)"
elif [ $1 = "--toggle" ]; then
	dunstctl close-all
	pactl set-sink-mute @DEFAULT_SINK@ toggle
	notify-send "Volume $(getVolumeStatus)"
fi
