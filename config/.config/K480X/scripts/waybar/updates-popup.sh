#!/usr/bin/env bash

TERMINAL="kitty"
SUMMARY_FILE=~/.cache/update_summary

$TERMINAL --class floating-update -e bash -c '
    if [[ -f "$SUMMARY_FILE" ]]; then
        cat "$SUMMARY_FILE"
        echo
        read -p "Run full update? (y/N) " ans
        [[ $ans =~ ^[Yy]$ ]] && paru -Syu
    else
        echo "No update summary found."
        read -p "Press enter to exit."
    fi
'

