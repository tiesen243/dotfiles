#!/bin/bash

function show_help() {
  echo "Usage: $0 [option] [profile]"
  echo "Options:"
  echo "  -h | --help      Show help"
  echo "  -g | --get       Get current profile"
  echo "  -s | --set       Set profile (battery, balanced, performance)"
}

function get_power_profile() {
  profile=$(system76-power profile)
  echo "$profile" | grep "Power Profile" | sed 's/Power Profile: //'
}

function set_power_profile() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <profile>"
    echo "Available profiles: battery, balanced, performance"
    exit 1
  fi

  profile=$1
  case "$profile" in
  battery | balanced | performance)
    system76-power profile "$profile"
    ;;
  *)
    echo "Invalid profile. Available profiles: battery, balanced, performance"
    exit 1
    ;;
  esac
}

case "$1" in
-h | --help)
  show_help
  ;;
-g | --get)
  get_power_profile
  ;;
-s | --set)
  shift
  set_power_profile "$@"
  ;;
*)
  show_help
  ;;
esac
