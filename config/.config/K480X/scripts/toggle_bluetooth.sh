#!/usr/bin/env bash

if pgrep -x blueman-manager > /dev/null; then
    pkill blueman-manager
else
    (sleep 0.2 && blueman-manager) &
fi
