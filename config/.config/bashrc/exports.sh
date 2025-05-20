#!/usr/bin/env bash

# History behavior
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T"
export HISTCONTROL=erasedups:ignoredups:ignorespace
shopt -s checkwinsize
shopt -s histappend
PROMPT_COMMAND='history -a'

# XDG Base Directory spec
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Syntax/color highlighting for man pages
export MANPAGER='nvim +Man!'

# CLI behavior
[[ $- == *i* ]] && stty -ixon
if [[ -n "$iatest" && $iatest -gt 0 ]]; then
  bind "set completion-ignore-case on"
  bind "set show-all-if-ambiguous On"
  bind "set bell-style visible"
fi

# Editor settings
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=nvim
  alias vim='nvim'
  alias vi='nvim'
  alias nv='nvim'
  alias svi='sudo nvim'
  alias vis='nvim "+set si"'
else
  export EDITOR=vim
  export VISUAL=vim
fi

alias spico='sudo pico'
alias snano='sudo nano'

# Colors
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# grep color fallback
if command -v rg &>/dev/null; then
  alias grep='rg'
else
  alias grep='grep --color=auto'
fi

# PATH additions
export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:$HOME/.cargo/bin/hx"
export PATH="$PATH:/opt/nvim/"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export LIBVIRT_DEFAULT_URI='qemu:///system'
export AURDEST="$HOME/.cache/aurutils"
export AURREPO=k480x
