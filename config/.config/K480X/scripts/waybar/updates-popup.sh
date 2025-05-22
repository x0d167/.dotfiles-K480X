#!/usr/bin/env bash

TERMINAL="kitty"
SUMMARY_FILE="$HOME/.cache/update_summary"

$TERMINAL --class floating-update -e bash -c '
    summary="$HOME/.cache/update_summary"
    if [[ -f "$summary" ]]; then
        cat "$summary"
        echo
        read -p "Run full update? (y/N) " ans
        [[ $ans =~ ^[Yy]$ ]] && paru -Syu
    else
        echo "No update summary found."
        read -p "Press enter to exit."
    fi
'

