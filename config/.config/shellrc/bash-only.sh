# ~/.config/shellrc/bash-only.sh

# ➡️ Bash-specific config for interactive sessions

# History config
shopt -s checkwinsize
shopt -s histappend
export HISTCONTROL=erasedups:ignoredups:ignorespace
export PROMPT_COMMAND='history -a'
[[ $- == *i* ]] && stty -ixon

# Bash-specific input behavior
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous On"
bind "set bell-style visible"

# Load cargo env if available
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ------------------------------
# 🔍 Fuzzy History (Ctrl+R)
# ------------------------------
__fuzzy_history() {
  local selected
  selected=$(HISTTIMEFORMAT= history | tac | fzf --no-sort --preview 'echo {}' --height=40% --border --prompt='History > ' | sed 's/^[ ]*[0-9]\+[ ]*//')
  if [[ -n "$selected" ]]; then
    READLINE_LINE="$selected"
    READLINE_POINT=${#selected}
  fi
}
bind -x '"\C-r": __fuzzy_history'

# ------------------------------
# ⚡ Fuzzy Alias Picker (Alt+A)
# ------------------------------
aliasf() {
  local selection
  selection=$(alias | fzf --prompt="Alias > " | sed -E "s/^alias ([^=]+)='(.*)'/\2/")
  if [[ -n "$selection" ]]; then
    read -e -i "$selection" _cmd
    eval "$_cmd"
  fi
}
bind -x '"\ea": aliasf'

# ------------------------------
# 📂 FZF File Opener (Ctrl+F)
# ------------------------------
fzf_open_file() {
  local file
  file=$(find . -type f 2>/dev/null | fzf) && nvim "$file"
}
bind -x '"\C-f": fzf_open_file'

# ------------------------------
# 📁 FZF Directory Jumper (Ctrl+O)
# ------------------------------
fzf_cd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) && builtin cd "$dir"
}
bind -x '"\C-o": fzf_cd'
