#!/bin/bash

color=$(hyprpicker -a -f hex)
notify-send "Color Picker" "Copied $color"
