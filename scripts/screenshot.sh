#!/bin/bash

if [ -d ~/OneDrive ]; then
  saveLocation=~/OneDrive/Pictures/Screenshots
else
  saveLocation=~/Pictures/Screenshots
  if [ ! -d $saveLocation ]; then
    mkdir -p $saveLocation
  fi
fi

saveLocation=($saveLocation/Screenshot\ $(date +%Y-%m-%d)\ $(date +%H%M%S)\.png)

if [ "$1" == "1" ]; then
  grim "$saveLocation"
else
  grim -g "$(slurp)" "$saveLocation"
fi

wl-copy < "$saveLocation"

notify-send "Screenshot taken" "Saved to $saveLocation"
