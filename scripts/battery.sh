battery_capacity=$(($(cat /sys/class/power_supply/BAT1/capacity)))
battery_status=$(cat /sys/class/power_supply/BAT1/status)

if [ "$battery_status" == "Charging" ]; then
    icon="󰂅"
elif [ "$battery_capacity" -eq 100 ]; then
    icon="󰁹"
elif [ "$battery_capacity" -ge 80 ]; then
    icon="󰂁"
elif [ "$battery_capacity" -ge 60 ]; then
    icon="󰁿"
elif [ "$battery_capacity" -ge 40 ]; then
    icon="󰁾"
elif [ "$battery_capacity" -ge 20 ]; then
    icon="󰁽"
else
    icon="󰁻"
fi

echo "$battery_capacity% $icon "
