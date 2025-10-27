# Zsh-specific shell config

# ------------------------------
# 🧠 History and Behavior
# ------------------------------
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
setopt autocd extendedglob nomatch notify
unsetopt beep
setopt NO_FLOW_CONTROL
setopt CORRECT

# ------------------------------
# ⌨️ Vi Mode
# ------------------------------
bindkey -v

# ------------------------------
# 🔍 FZF: Fuzzy History (Ctrl+R)
# ------------------------------
fzf_history_widget() {
  local selected
  selected=$(fc -l 1 | fzf --tac --no-sort --preview 'echo {}' --height=40% --border --prompt='History > ' | sed 's/^[ ]*[0-9]\+[ ]*//')
  if [[ -n "$selected" ]]; then
    LBUFFER="$selected"
    zle reset-prompt
  fi
}
zle -N fzf_history_widget
bindkey '^R' fzf_history_widget

# ------------------------------
# ⚡ Fuzzy Alias Picker (Alt+A)
# ------------------------------
aliasf_widget() {
  local selected _cmd
  selected=$(alias | fzf --prompt="Alias > " | sed -E "s/^alias ([^=]+)='(.*)'/\2/")
  if [[ -n "$selected" ]]; then
    read -k _key '?Run selected alias? (y/N): '
    [[ "$_key" == [yY] ]] && BUFFER="$selected"
    zle reset-prompt
  fi
}
zle -N aliasf_widget
bindkey '\ea' aliasf_widget

# ------------------------------
# 🗂️ FZF File Opener (Ctrl+F)
# ------------------------------
fzf_open_file_widget() {
  local file
  file=$(find . -type f 2>/dev/null | fzf) && BUFFER="nvim '$file'"
  zle accept-line
}
zle -N fzf_open_file_widget
bindkey '^F' fzf_open_file_widget

# ------------------------------
# 📁 FZF Directory Jumper (Ctrl+O)
# ------------------------------
fzf_cd_widget() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) && BUFFER="cd '$dir'"
  zle accept-line
}
zle -N fzf_cd_widget
bindkey '^O' fzf_cd_widget
