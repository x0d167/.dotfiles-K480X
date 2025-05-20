#!/usr/bin/env bash

# ┌──────────────────────────────────────────────────────────┐
# │ Hyprshade controller: rofi selector or toggle executor   │
# │ Usage:                                                   │
# │   hyprshade.sh rofi  → choose shader from rofi menu      │
# │   hyprshade.sh        → toggle current shader on/off     │
# └──────────────────────────────────────────────────────────┘

FILTER_FILE="$HOME/.config/K480X/settings/hyprshade.sh"
DEFAULT_FILTER="blue-light-filter-50"

mkdir -p "$(dirname "$FILTER_FILE")"

if [[ "$1" == "rofi" ]]; then
    options="$(hyprshade ls)\noff"
    choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/config-hyprshade.rasi -i -no-show-icons -l 4 -width 30 -p "Hyprshade")

    if [[ -n "$choice" ]]; then
        echo "hyprshade_filter=\"$choice\"" > "$FILTER_FILE"

        if [[ "$choice" == "off" ]]; then
            hyprshade off
            notify-send "Hyprshade" "Shader deactivated"
        else
            notify-send "Hyprshade" "Selected '$choice' (toggle with SUPER+SHIFT+S)"
        fi
    fi

else
    hyprshade_filter="$DEFAULT_FILTER"

    [[ -f "$FILTER_FILE" ]] && source "$FILTER_FILE"

    if [[ "$hyprshade_filter" != "off" ]]; then
        current="$(hyprshade current)"

        if [[ -z "$current" ]]; then
            hyprshade on "$hyprshade_filter"
            notify-send "Hyprshade activated" "Using: $hyprshade_filter"
        else
            hyprshade off
            notify-send "Hyprshade deactivated"
        fi
    else
        hyprshade off
    fi
fi
