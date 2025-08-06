# ~/.config/zsh/.zshrc

# Must happen before anything that triggers completions
autoload -Uz compinit
compinit
zstyle :compinstall filename "$HOME/.config/zsh/zshrc"

# Source unified shell config
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shellrc/init.sh" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shellrc/init.sh"

# Source Zsh-only tweaks (history, keybinds, fuzzy widgets, etc.)
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shellrc/zsh-only.sh" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shellrc/zsh-only.sh"
