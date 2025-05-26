#!/bin/bash

# Bail if not in a git repo
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

# Get detailed status
status=$(git status --porcelain=2 --branch 2>/dev/null)

# Init counters
untracked=0
modified=0
staged=0
ahead=0
behind=0
commit_ahead=0
commit_behind=0

# ANSI colors
RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
RESET=$'\e[0m'

# Parse file status
while IFS= read -r line; do
  case "$line" in
    "# branch.ab "*)
      ahead=$(echo "$line" | awk '{print $3}' | sed 's/+//')
      behind=$(echo "$line" | awk '{print $4}' | sed 's/-//')
      ;;
    "? "*)
      ((untracked++))
      ;;
    "1 "*|"2 "*)  # Changed or renamed files
      x=${line:2:1}
      y=${line:3:1}
      [[ "$x" != "." ]] && ((staged++))
      [[ "$y" != "." ]] && ((modified++))
      ;;
  esac
done <<< "$status"

# Get actual commit counts vs remote
if git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
  commit_ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
  commit_behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
fi

# Build output
out=""
[[ $untracked -gt 0 ]]     && out+=" ?${untracked} "     # untracked
[[ $modified -gt 0 ]]      && out+="~${modified} "         # modified
[[ $staged -gt 0 ]]        && out+="${GREEN}++${staged}${RESET} "         # staged
[[ $commit_ahead -gt 0 ]]  && out+="${GREEN}⇡${commit_ahead}${RESET} "     # ahead
[[ $commit_behind -gt 0 ]] && out+="${RED}⇣${commit_behind}${RESET} "    # behind

# Output final result
echo "$out" | sed 's/ $//'

