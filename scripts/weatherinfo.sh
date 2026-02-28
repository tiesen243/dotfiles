#!/bin/bash

while [[ "$#" -gt 0 ]]; do
  case $1 in
  --city)
    if [[ -z "$2" || "$2" == --* ]]; then
      echo "Error: City name is required after --city" >&2
      exit 1
    fi

    city="$2"
    shift 2
    ;;
  --help)
    echo "Usage: $0 --city <city_name>" >&2
    exit 1
    ;;
  esac
done

if [[ -z "$city" ]]; then
  curl -s "wttr.in/?format=%c+%t+%h+%w" || echo "Failed to fetch weather information"
else
  curl -s "wttr.in/$city?format=%c+%t+%h+%w" || echo "Failed to fetch weather information"
fi
