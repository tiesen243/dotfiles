#!/usr/bin/env bash

if [ -d ~/OneDrive ]; then
  saveLocation=~/OneDrive/Pictures/Screenshots
else
  saveLocation=~/Pictures/Screenshots
  if [ ! -d $saveLocation ]; then
    mkdir -p $saveLocation
  fi
fi

saveLocation=($saveLocation/Screenshot\ $(date +%Y-%m-%d)\ $(date +%H%M%S)\.png)

if [ "$1" == "--full" ]; then
  grim "$saveLocation"
elif [ "$1" == "--select" ]; then
  grim -g "$(slurp)" "$saveLocation"
  if [ $? -ne 0 ]; then
    exit 1
  fi
else
  notify-send "Invalid argument. Use --full or --select."
  exit 1
fi

wl-copy <"$saveLocation"

notify-send "Screenshot saved to $saveLocation"
