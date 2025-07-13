#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 --city <city_name>"
  echo ""
  echo "  --city             : Specify the city for which to fetch weather information."
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case $1 in
  --city)
    if [[ -z "$2" || "$2" == --* ]]; then
      echo "Error: City name is required after --city"
      exit 1
    fi
    city="$2"
    shift 2
    ;;
  *)
    echo "Unknown parameter: $1"
    echo "Usage: $0 --city <city_name>"
    exit 1
    ;;
  esac
done

curl -s "wttr.in/$city?format=%c+%t+%h+%w" || echo "Failed to fetch weather information"
