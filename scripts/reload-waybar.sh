#!/bin/bash

killall waybar
sleep 0.1

waybar &
disown
