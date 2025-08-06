#!/bin/bash

SCREENSHOT_DIR="$HOME/media/pictures/screenshots"
FILENAME="screenshot-$(date '+%Y-%m-%d_%H-%M-%S').png"
FULLPATH="$SCREENSHOT_DIR/$FILENAME"

mkdir -p "$SCREENSHOT_DIR"

# First menu
option_now="Take Screenshot Now"
option_delay="Take Screenshot After Delay"
main_choice=$(echo -e "$option_now\n$option_delay" | rofi -dmenu -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "Screenshot")

case "$main_choice" in
    "$option_now")
        delay=0
        ;;
    "$option_delay")
        # Delay menu
        delay_choice=$(echo -e "3\n5\n10\n20" | rofi -dmenu -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "Delay (seconds)")
        [ -z "$delay_choice" ] && exit 0
        delay=$delay_choice
        ;;
    *)
        exit 0
        ;;
esac

# Optional delay with notify
if (( delay > 0 )); then
    notify-send "Screenshot in ${delay}s"
    sleep "$delay"
fi

grim -g "$(slurp)" - | satty --filename - --output-filename "$FULLPATH"
