#!/bin/bash

screenBrightness="$(brightnessctl g | awk '{print int($1 / 19200 * 100)}')%"

if [ $1 = "up" ]; then
  brightnessctl s +5%
  notify-send "Increased to $screenBrightness"
elif [ $1 = "down" ]; then
  brightnessctl s 5%-
  notify-send "Decreased to $screenBrightness"
fi


