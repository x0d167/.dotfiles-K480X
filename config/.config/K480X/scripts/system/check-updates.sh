#!/usr/bin/env bash

REPO_UPDATES=$(checkupdates 2>/dev/null)
AUR_UPDATES=$(paru -Qua 2>/dev/null)

REPO_COUNT=$(echo "$REPO_UPDATES" | grep -c '^[^ ]')
AUR_COUNT=$(echo "$AUR_UPDATES" | grep -c '^[^ ]')

# Cache counts for Waybar
echo "$REPO_COUNT|$AUR_COUNT" > ~/.cache/update_counts

# Cache full summary
{
    echo "== Repo Updates ($REPO_COUNT) =="
    echo "$REPO_UPDATES"
    echo
    echo "== AUR Updates ($AUR_COUNT) =="
    echo "$AUR_UPDATES"
} > ~/.cache/update_summary
