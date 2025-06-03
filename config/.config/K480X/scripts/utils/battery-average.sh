#!/bin/bash
# This is just for a laptop with dual batteries like the T480

bat0=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
bat1=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo 0)

# Simple average
avg=$(( (bat0 + bat1) / 2 ))

# Pick icon
if [ "$avg" -ge 90 ]; then icon="󰂂"
elif [ "$avg" -ge 70 ]; then icon="󰂀"
elif [ "$avg" -ge 50 ]; then icon="󰁾"
elif [ "$avg" -ge 30 ]; then icon="󰁼"
else icon="󰂎"; fi

# Check if charging (AC online = 1)
charging=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)
if [ "$charging" -eq 1 ]; then
    icon="󰂄" # charging dual-battery icon
fi

echo "$icon $avg%"

