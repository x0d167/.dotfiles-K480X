#!/bin/bash

SCREENSHOT_DIR="$HOME/media/pictures/screenshots"
FILENAME="screenshot-$(date '+%Y-%m-%d_%H-%M-%S').png"
FULLPATH="$SCREENSHOT_DIR/$FILENAME"

mkdir -p "$SCREENSHOT_DIR"

grim -g "$(slurp)" - | satty --filename - --output-filename "$FULLPATH"
