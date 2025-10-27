# ~/.zshenv

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
  exec uwsm start -- hyprland.desktop
fi

# Respect XDG layout if not already set
if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

# Tell Zsh to look for config in $XDG_CONFIG_HOME/zsh
if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
. "/home/operator/.local/share/cargo/env"
