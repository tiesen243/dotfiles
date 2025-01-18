#!/usr/bin/env bash

cd ~

# Usage Information
usage() {
	echo "Usage: $0 [--drun | --run | --menu]"
	echo ""
	echo "  --drun   : Launches the application launcher (drun)."
	echo "  --run    : Launches the command runner (run)."
	echo "  --menu   : Displays a custom menu with multiple options."
	exit 1
}

# Function: DRUN Launcher
drun_launcher() {
	rofi \
		-show drun \
		-theme ~/.config/rofi/launcher.rasi
}

# Function: RUN Launcher
run_launcher() {
	rofi \
		-show run \
		-theme ~/.config/rofi/launcher.rasi
}

# Function: CONFIRMATION Launcher
conf_launcher() {
	rofi \
		-show run \
		-theme ~/.config/rofi/confirm.rasi
}

# Function: Custom Menu
menu() {
	# Menu options displayed in rofi
	options="\n\n\n\n\n"

	# Prompt user to choose an option
	chosen=$(echo -e "$options" | rofi -config ~/.config/rofi/submenu.rasi -dmenu -p "Select an option:")

	echo "$chosen"

	# Execute the corresponding command based on the selected option
	case $chosen in
	"")
		export EDITOR=nvim && kitty -e yazi
		;;
	"")
		xdg-open https://about:blank
		;;
	"")
		hyprlock
		;;
	"")
		hyprctl dispatch exit 0
		;;
	"")
		systemctl poweroff
		;;
	"")
		systemctl reboot
		;;
	*)
		echo "No option selected"
		;;
	esac
}

# Check for flags and validate input
if [[ $# -ne 1 ]]; then
	usage
fi

# Execute the appropriate function based on the provided flag
case "$1" in
--drun)
	drun_launcher
	;;
--run)
	run_launcher
	;;
--menu)
	menu
	;;
*)
	usage
	;;
esac
