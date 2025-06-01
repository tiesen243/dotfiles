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

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [--full | --select]"
  echo ""
  echo "  --full   : Capture a full screenshot."
  echo "  --select : Capture a selected area screenshot."
  exit 1
fi

case $1 in
"--full")
  grim "$saveLocation"
  ;;
"--select")
  grim -g "$(slurp)" "$saveLocation"
  if [ $? -ne 0 ]; then
    exit 1
  fi
  ;;
esac

wl-copy <"$saveLocation"

notify-send "Screenshot saved to $saveLocation"
