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

if [[ "$query" =~ ^(http://|https://)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(:[0-9]+)?(/.*)?$ ]]; then
  $1 $query
else
  $1 "https://www.google.com/search?q=$query"
fi
