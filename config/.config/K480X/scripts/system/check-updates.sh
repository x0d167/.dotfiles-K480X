#!/usr/bin/env bash

# Trigger a lightweight sync
paru -Sy --quiet > /dev/null

# Get update counts
REPO_UPDATES=$(paru -Qu --repo 2>/dev/null)
AUR_UPDATES=$(paru -Qu --aur 2>/dev/null)

REPO_COUNT=$(echo "$REPO_UPDATES" | grep -c '^[^ ]')
AUR_COUNT=$(echo "$AUR_UPDATES" | grep -c '^[^ ]')

# Save counts for Waybar
echo "$REPO_COUNT|$AUR_COUNT" > ~/.cache/update_counts

# Save detailed summary
{
    echo "== Repo Updates ($REPO_COUNT) =="
    echo "$REPO_UPDATES"
    echo
    echo "== AUR Updates ($AUR_COUNT) =="
    echo "$AUR_UPDATES"
} > ~/.cache/update_summary

