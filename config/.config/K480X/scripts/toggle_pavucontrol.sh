#!/usr/bin/env bash

if pgrep -x pavucontrol > /dev/null; then
    pkill pavucontrol
else
    (sleep 0.2 && pavucontrol) &
fi
