#!/usr/bin/env bash

# Commands and labels
options=(
    "  Poweroff|systemctl poweroff"
    "  Reboot|systemctl reboot"
    "  Suspend|systemctl suspend"
    "  Lock|hyprlock"
    "  Logout|hyprctl dispatch exit"
)

# Generate menu entries
choices=$(printf '%s\n' "${options[@]}" | cut -d'|' -f1)

# Run rofi
selection=$(echo "$choices" | rofi -theme ~/.config/rofi/config-powermenu2.rasi -dmenu -p " ")

# If user typed something instead of choosing
if [[ -z "$selection" ]]; then
    exit 0
fi

# Find command
cmd=$(printf '%s\n' "${options[@]}" | grep -F "$selection" | cut -d'|' -f2)

# If it matches one of the icons, run corresponding command
if [[ -n "$cmd" ]]; then
    eval "$cmd"
else
    # Otherwise treat as arbitrary shell command
    eval "$selection"
fi
