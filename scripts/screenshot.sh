#!/bin/bash

if [ -d ~/OneDrive ]; then
  saveLocation=~/OneDrive/Pictures/Screenshots/Screenshot_$(date +%F_%H%M%S).png
else
  saveLocation=~/Pictures/Screenshots/Screenshot_$(date +%F_%H%M%S).png
fi

if [ $1 = 1 ]; then
  grim $saveLocation
else
  grim -g "$(slurp)" $saveLocation
fi

wl-copy < $saveLocation
notify-send Screenshot "Saved to $saveLocation"
