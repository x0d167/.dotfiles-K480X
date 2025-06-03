#!/usr/bin/env bash

LAPTOP_MONITOR="eDP-1"

# Margin safety
WIDTH_MARGIN=40
HEIGHT_MARGIN=80

sleep 0.5

# Monitor size
read MON_WIDTH MON_HEIGHT < <(hyprctl monitors -j |
  jq -r --arg name "$LAPTOP_MONITOR" '.[] | select(.name == $name) | "\(.width) \(.height)"')

SAFE_WIDTH=$((MON_WIDTH - WIDTH_MARGIN))
SAFE_HEIGHT=$((MON_HEIGHT - HEIGHT_MARGIN))

clients=$(hyprctl clients -j | jq -c '.[] | select(.class == "org.gnome.Boxes" or .class == "org.gnome.Nautilus")')

echo "$clients" | while read -r client; do
    wid=$(echo "$client" | jq -r '.address')
    cls=$(echo "$client" | jq -r '.class')
    monitor=$(echo "$client" | jq -r '.monitor')

    # Fallback monitor name (fixes 0 case)
    monitor_name=$(hyprctl monitors -j | jq -r --argjson index "$monitor" '.[ $index ]?.name // "unknown"')

    if [[ "$monitor_name" == "$LAPTOP_MONITOR" ]]; then
        echo ":: $cls on $monitor_name → fullscreen"
        hyprctl dispatch focuswindow "$wid"
        hyprctl dispatch fullscreen
    else
        echo ":: $cls on $monitor_name → resize to ${SAFE_WIDTH}x${SAFE_HEIGHT} and center"
        hyprctl dispatch focuswindow "$wid"
        hyprctl dispatch resizewindowpixel ${SAFE_WIDTH} ${SAFE_HEIGHT}
        hyprctl dispatch centerwindow
    fi
done

