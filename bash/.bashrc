#!/usr/bin/env bash

# ➡️  This file is managed. Don’t edit directly.

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
  exec uwsm start -- hyprland.desktop
fi

# Modular Bash config loader
for part in init.sh exports.sh aliases.sh prompt.sh functions.sh; do
  [ -f "$HOME/.config/bashrc/$part" ] && source "$HOME/.config/bashrc/$part"
done
. "/home/operator/.local/share/cargo/env"
