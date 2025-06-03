#!/usr/bin/env bash

TERMINAL="kitty"
SUMMARY_FILE="$HOME/.cache/update_summary"

$TERMINAL --class floating-update -e bash -c '
    summary="$HOME/.cache/update_summary"
    if [[ -f "$summary" ]]; then
        cat "$summary"
        echo
        read -p "Run full update? (y/N) " ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            paru -Syu
        fi
        ~/.config/K480X/scripts/system/check-updates.sh
    else
        echo "No update summary found."
    fi
    echo
    read -p "Press enter to close."
'

