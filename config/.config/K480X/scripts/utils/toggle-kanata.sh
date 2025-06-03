#!/bin/bash
# toggle-kanata.sh
if pgrep -x kanata >/dev/null; then
    pkill kanata
    notify-send "Kanata disabled"
else
    kanata & disown >/dev/null 2>&1
    notify-send "Kanata enabled"
fi

