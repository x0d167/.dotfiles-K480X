# ~/.config/shellrc/init.sh

# 🧠 Detect shell
if [[ -n "$BASH_VERSION" ]]; then
  export IS_BASH=true
  export IS_ZSH=false
elif [[ -n "$ZSH_VERSION" ]]; then
  export IS_ZSH=true
  export IS_BASH=false
fi

# 🧪 Interactive?
if [[ $- == *i* ]]; then
  export SHELL_IS_INTERACTIVE=true
else
  export SHELL_IS_INTERACTIVE=false
fi

# 🧊 Optional: display fastfetch (interactive only)
# if [[ $SHELL_IS_INTERACTIVE == true && -x $(command -v fastfetch) ]]; then
#   fastfetch
# fi

# 🧠 Enable programmable Bash completion (if applicable)
if [[ $IS_BASH == true ]]; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# 📂 Source common shellrc components
SHELLRC_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/shellrc"

for file in aliases.sh exports.sh functions.sh prompt.sh; do
  [[ -f "$SHELLRC_HOME/$file" ]] && source "$SHELLRC_HOME/$file"
done
