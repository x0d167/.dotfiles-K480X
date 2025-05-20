#!/usr/bin/env bash

if pgrep -x waypaper > /dev/null; then
  pkill waypaper
else
  waypaper &
fi
