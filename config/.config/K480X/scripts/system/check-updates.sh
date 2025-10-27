#!/usr/bin/env bash

# Pick AUR helper
if command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
elif command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
else
    AUR_HELPER=""
fi

# Get update counts using safer tools
REPO_UPDATES=$(checkupdates 2>/dev/null)
if [ -n "$AUR_HELPER" ]; then
    AUR_UPDATES=$($AUR_HELPER -Qu --aur 2>/dev/null)
else
    AUR_UPDATES=""
fi

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
