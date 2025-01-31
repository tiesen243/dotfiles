#!/usr/bin/env bash

getCurrentBrightness() {
	current=$(cat /sys/class/backlight/*/brightness)
	max=$(cat /sys/class/backlight/*/max_brightness)
	percentage=$(((current * 100) / max))
	echo "$percentage%"
}

if [ $1 = "--up" ]; then
	brightnessctl s +5%
	notify-send "Brightness increased to $(getCurrentBrightness)"
elif [ $1 = "--down" ]; then
	brightnessctl s 5%-
	notify-send "Brightness decreased to $(getCurrentBrightness)"
fi
