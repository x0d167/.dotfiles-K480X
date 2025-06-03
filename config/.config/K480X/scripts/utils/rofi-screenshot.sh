#!/bin/bash
#  ____                               _           _
# / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_
# \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __|
#  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_
# |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__|
#
# Based on https://github.com/hyprwm/contrib/blob/main/grimblast/screenshot.sh
# -----------------------------------------------------

# Screenshot Folder (Hardcoded – no fallbacks, no XDG guessing)
XDG_PICTURES_DIR="$HOME/media/pictures"
screenshot_folder="$XDG_PICTURES_DIR/screenshots"

# Screenshot Filename
NAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).jpg"

# Screenshot Editor
export GRIMBLAST_EDITOR="pinta"

# Screenshot UI Options
option_1="Immediate"
option_2="Delayed"

option_capture_1="Capture Everything"
option_capture_2="Capture Active Display"
option_capture_3="Capture Selection"

option_time_1="5s"
option_time_2="10s"
option_time_3="20s"
option_time_4="30s"
option_time_5="60s"

list_col='1'
list_row='2'

copy='Copy'
save='Save'
copy_save='Copy & Save'
edit='Edit'

# Rofi Command Helpers
rofi_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "Take screenshot"
}

run_rofi() {
    echo -e "$option_1\n$option_2" | rofi_cmd
}

timer_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 5 -width 30 -p "Choose timer"
}

timer_exit() {
    echo -e "$option_time_1\n$option_time_2\n$option_time_3\n$option_time_4\n$option_time_5" | timer_cmd
}

timer_run() {
    selected_timer="$(timer_exit)"
    case "$selected_timer" in
        "$option_time_1") countdown=5 ;;
        "$option_time_2") countdown=10 ;;
        "$option_time_3") countdown=20 ;;
        "$option_time_4") countdown=30 ;;
        "$option_time_5") countdown=60 ;;
        *) exit ;;
    esac
    $1
}

type_screenshot_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 3 -width 30 -p "Type of screenshot"
}

type_screenshot_exit() {
    echo -e "$option_capture_1\n$option_capture_2\n$option_capture_3" | type_screenshot_cmd
}

type_screenshot_run() {
    selected_type_screenshot="$(type_screenshot_exit)"
    case "$selected_type_screenshot" in
        "$option_capture_1") option_type_screenshot=screen ;;
        "$option_capture_2") option_type_screenshot=output ;;
        "$option_capture_3") option_type_screenshot=area ;;
        *) exit ;;
    esac
    $1
}

copy_save_editor_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "How to save"
}

copy_save_editor_exit() {
    echo -e "$copy\n$save\n$copy_save\n$edit" | copy_save_editor_cmd
}

copy_save_editor_run() {
    selected_chosen="$(copy_save_editor_exit)"
    case "$selected_chosen" in
        "$copy") option_chosen=copy ;;
        "$save") option_chosen=save ;;
        "$copy_save") option_chosen=copysave ;;
        "$edit") option_chosen=edit ;;
        *) exit ;;
    esac
    $1
}

timer() {
    if [[ $countdown -gt 10 ]]; then
        notify-send -t 1000 "Taking screenshot in ${countdown} seconds"
        sleep $((countdown - 10))
        countdown=10
    fi
    while [[ $countdown -ne 0 ]]; do
        notify-send -t 1000 "Taking screenshot in ${countdown} seconds"
        countdown=$((countdown - 1))
        sleep 1
    done
}

takescreenshot() {
    sleep 1
    grimblast --freeze --notify "$option_chosen" "$option_type_screenshot" "$NAME"
    if [ -f "$HOME/$NAME" ] && [ -d "$screenshot_folder" ]; then
        mv "$HOME/$NAME" "$screenshot_folder/"

        case "$option_chosen" in
            "copy")
                wl-copy < "$screenshot_folder/$NAME"
                ;;
            "copysave")
                wl-copy < "$screenshot_folder/$NAME"
                imv "$screenshot_folder/$NAME" &
                ;;
            "save")
                imv "$screenshot_folder/$NAME" &
                ;;
            "edit")
                : # grimblast handles it
                ;;
        esac
    fi
}

takescreenshot_timer() {
    sleep 1
    timer
    sleep 1
    grimblast --freeze --notify "$option_chosen" "$option_type_screenshot" "$NAME"
    if [ -f "$HOME/$NAME" ] && [ -d "$screenshot_folder" ]; then
        mv "$HOME/$NAME" "$screenshot_folder/"

        case "$option_chosen" in
            "copy")
                wl-copy < "$screenshot_folder/$NAME"
                ;;
            "copysave")
                wl-copy < "$screenshot_folder/$NAME"
                imv "$screenshot_folder/$NAME" &
                ;;
            "save")
                imv "$screenshot_folder/$NAME" &
                ;;
            "edit")
                : # grimblast handles it
                ;;
        esac
    fi
}

run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        type_screenshot_run
        copy_save_editor_run takescreenshot
    elif [[ "$1" == '--opt2' ]]; then
        timer_run
        type_screenshot_run
        copy_save_editor_run takescreenshot_timer
    fi
}

chosen="$(run_rofi)"
case "$chosen" in
    "$option_1") run_cmd --opt1 ;;
    "$option_2") run_cmd --opt2 ;;
    *) exit ;;
esac

