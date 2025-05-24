#!/usr/bin/env bash

# Screenshot path & name format
dir="$HOME/media/pictures/screenshots"
filename="wayshot-$(date '+%Y_%m_%d-%H_%M_%S').png"
fullpath="$dir/$filename"

# Ensure directory exists
mkdir -p "$dir"

# Get region via slurp
region=$(slurp)
[ -z "$region" ] && exit 1  # cancel if no region selected

# Take screenshot
wayshot -s "$region" -f "$fullpath"

# Copy to clipboard
wl-copy < "$fullpath"

# Open in viewer
imv "$fullpath" & disown

