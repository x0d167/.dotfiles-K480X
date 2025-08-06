# ~/.config/shellrc/exports.sh

# History size (works in both, other settings shell-specific)
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTTIMEFORMAT="%F %T"

# XDG base dirs
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOAD_DIR="$HOME/tmp/downloads"
export XDG_DOCUMENTS_DIR="$HOME/docs"
export XDG_MUSIC_DIR="$HOME/media/music"
export XDG_PICTURES_DIR="$HOME/media/pictures"
export XDG_VIDEOS_DIR="$HOME/media/videos"
export XDG_DESKTOP_DIR="$HOME/archive/desktop"
export XDG_TEMPLATES_DIR="$HOME/archive/templates"
export XDG_PUBLICSHARE_DIR="$HOME/tmp/public"
export ZDOTDIR="$HOME/.config/zsh"

# Tool-specific paths
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export RUFF_CACHE_DIR="$XDG_CACHE_HOME/ruff"
export MANPAGER='nvim +Man!'
export OPENAUDIBLE_HOME="$XDG_CONFIG_HOME/openaudible"

# Editor
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=nvim
  alias nv='nvim'
  alias svi='sudo nvim'
  alias vis='nvim "+set si"'
else
  export EDITOR=vim
  export VISUAL=vim
fi

alias spico='sudo pico'
alias snano='sudo nano'

# Color settings
export CLICOLOR=1
export LS_COLORS='...'
export LESS_TERMCAP_mb=$'\E[01;31m'
# (rest of LESS_TERMCAPs)

# PATH
export PATH="$PATH:$HOME/.local/bin:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:/opt/nvim/:/home/operator/.lmstudio/bin"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export LIBVIRT_DEFAULT_URI='qemu:///system'
export AURDEST="$HOME/.cache/aurutils"
export AURREPO=k480x
. "$CARGO_HOME/env"
