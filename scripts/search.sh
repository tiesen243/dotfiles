#!/bin/bash

query="$(rofi \
-config "~/dotfiles/rofi/search.rasi" \
-p "Search: " \
-dmenu \
-l 0
)"

if [ -z "$query" ]; then
  exit 0
fi

# check if query is a URL
if [[ "$query" =~ ^(http://|https://)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(:[0-9]+)?(/.*)?$ ]]; then
  $1 $query
else
  $1 "https://www.google.com/search?q=$query"
fi

# move window to workspace of browser
window_info=$(hyprctl clients | grep -B 5 "zen-alpha")
workspace="$(echo "$window_info" | grep "workspace" | head -n 1 | awk '{print $2}')"
hyprctl dispatch workspace $workspace
