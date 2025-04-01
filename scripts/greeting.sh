#!/usr/bin/env bash

# Read the username alias from hyprlock.conf
username=$(whoami)

# Check if the username was successfully extracted
if [ -z "$username" ]; then
  echo "Username not found in hyprlock.conf."
  exit 1
fi

# Get the current hour
hour=$(date +%H)

# Determine the greeting based on the time
if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
  greeting="Ohayou"
elif [ "$hour" -ge 12 ] && [ "$hour" -lt 17 ]; then
  greeting="Konnichiwa"
elif [ "$hour" -ge 17 ] && [ "$hour" -lt 21 ]; then
  greeting="Konbanwa"
elif [ "$hour" -ge 21 ] && [ "$hour" -lt 24 ]; then
  greeting="Oyasumi"
else
  greeting="Oyasumi"
fi

# Output the combined text
echo -e "$greeting, $username!"
