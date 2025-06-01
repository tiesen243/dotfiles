#!/bin/bash

cached=$(cat ~/.cache/web-search-query 2>/dev/null || echo "")
query=$(echo "$cached" | rofi -dmenu "Web Search" -p "Search query:" -no-fixed-num-lines -no-show-icons)
[ -n "$query" ] && {
  echo "$query"
  cat ~/.cache/web-search-query 2>/dev/null
} | awk '!seen[$0]++' >~/.cache/web-search-query.tmp && mv ~/.cache/web-search-query.tmp ~/.cache/web-search-query

if [[ "$query" =~ ^(https?|ftp|file):// ]]; then
  xdg-open "$query"
elif [[ "$query" =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}(/.*)?$ ]]; then
  xdg-open "https://$query"
elif [[ "$query" =~ ^localhost(:[0-9]+)?(/.*)?$ ]]; then
  xdg-open "http://$query"
else
  xdg-open "https://www.google.com/search?q=$(echo "$query" | sed 's/ /+/g')"
fi
