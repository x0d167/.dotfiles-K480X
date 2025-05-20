#!/usr/bin/env bash

if [[ -f ~/.cache/update_counts ]]; then
    IFS="|" read -r repo aur < ~/.cache/update_counts
    total=$((repo + aur))

    class="no-updates"
    tooltip="System up to date"

    if [[ $total -gt 0 ]]; then
        class="has-updates"
        tooltip="Repo: $repo | AUR: $aur"
    fi

    echo "{\"text\": \"\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
else
    echo '{"text": "", "tooltip": "Update status unknown", "class": "unknown-updates"}'
fi
