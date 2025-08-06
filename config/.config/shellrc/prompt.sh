# ~/.config/shellrc/prompt.sh

# 🧠 Init Starship prompt (portable between Bash and Zsh)
if [[ -n "$BASH_VERSION" ]]; then
  eval "$(starship init bash)"
elif [[ -n "$ZSH_VERSION" ]]; then
  eval "$(starship init zsh)"
fi

# 🧪 Shell completions for uv and uvx
if command -v uv &>/dev/null; then
  if [[ -n "$BASH_VERSION" ]]; then
    eval "$(uv generate-shell-completion bash)"
  elif [[ -n "$ZSH_VERSION" ]]; then
    eval "$(uv generate-shell-completion zsh)"
  fi
fi

if command -v uvx &>/dev/null; then
  if [[ -n "$BASH_VERSION" ]]; then
    eval "$(uvx --generate-shell-completion bash)"
  elif [[ -n "$ZSH_VERSION" ]]; then
    eval "$(uvx --generate-shell-completion zsh)"
  fi
fi

# 🚀 Zoxide
if command -v zoxide &>/dev/null; then
  if [[ -n "$BASH_VERSION" ]]; then
    eval "$(zoxide init bash)"
  elif [[ -n "$ZSH_VERSION" ]]; then
    eval "$(zoxide init zsh)"
  fi
fi
export _ZO_DOCTOR=0
