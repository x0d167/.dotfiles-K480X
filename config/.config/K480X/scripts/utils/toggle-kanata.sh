#!/bin/bash

KANATA_BIN="/usr/bin/kanata"
NOTIFY_SEND="/usr/bin/notify-send"

if pgrep -f "$KANATA_BIN" > /dev/null; then
    pkill -f "$KANATA_BIN"
    $NOTIFY_SEND "Kanata" "🚫 Deactivated"
else
    nohup $KANATA_BIN > /dev/null 2>&1 &
    $NOTIFY_SEND "Kanata" "✅ Activated"
fi
