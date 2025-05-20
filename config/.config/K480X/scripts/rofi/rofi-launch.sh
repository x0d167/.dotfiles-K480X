#!/usr/bin/env bash

if pgrep -x rofi >/dev/null; then
    pkill -x rofi
else
    nohup rofi -show drun >/dev/null 2>&1 &
fi
