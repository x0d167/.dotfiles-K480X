#!/usr/bin/env bash

# ➡️  This file is managed. Don’t edit directly.

# Modular Bash config loader
for part in init.sh exports.sh aliases.sh prompt.sh functions.sh; do
  [ -f "$HOME/.config/bashrc/$part" ] && source "$HOME/.config/bashrc/$part"
done

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/operator/.lmstudio/bin"
# End of LM Studio CLI section

