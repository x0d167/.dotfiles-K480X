#!/usr/bin/env bash
shopt -s extglob

# ============================
# 🧰 Core File/Directory Helpers
# ============================

# 🔍 Enhanced file viewer
cat() {
  if command -v batcat &>/dev/null; then
    batcat "$@"
  elif command -v bat &>/dev/null; then
    bat "$@"
  else
    command cat "$@"
  fi
}

# 📁 Smart cd
cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && zoxide add . && ls
  else
    builtin cd ~ && zoxide add . && ls
  fi
}

# 📁 Make dir and go
mkdirg() {
  mkdir -p "$1"
  cd "$1" || return
}

# 📁 Move and go
mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# 📁 Copy and go
cpg() {
  if [ -d "$2" ]; then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

# 🛠️ Touch with mkdir
touchy() {
  local target="$1"
  mkdir -p "$(dirname "$target")" && touch "$target"
}

# 📍 Short path
pwdtail() {
  pwd | awk -F/ '{nlast = NF -1; print $nlast"/"$NF}'
}

# ============================
# 📥 Download Helpers
# ============================

pilfer() {
  local type="$1"; shift

  if [[ -z "$type" || $# -eq 0 ]]; then
    echo "Usage: pilfer <type> <url> [more...]"
    echo "Supported types: wallpaper, git, font, video, doc"
    return 1
  fi

  case "$type" in
    wallpaper)
      local dest=~/media/pictures/wallpapers
      mkdir -p "$dest"
      for url in "$@"; do
        local filename=$(basename "$url")
        local fullpath="$dest/$filename"
        echo ":: Downloading wallpaper from $url"
        curl -L --fail -o "$fullpath" "$url" || { echo "❌ Failed: $url"; continue; }
        echo ":: Saved as $filename"
        read -p "Rename? (new name without extension, Enter to skip): " newname
        if [[ -n "$newname" ]]; then
          local ext="${filename##*.}"
          mv "$fullpath" "$dest/$newname.$ext"
          echo ":: Renamed to $newname.$ext"
        fi
      done
      ;;
    git)
      local dest=~/tmp/git
      mkdir -p "$dest"
      for repo in "$@"; do
        echo ":: Cloning repo $repo"
        git clone "$repo" "$dest/$(basename "${repo%.git}")" || echo "❌ Failed: $repo"
      done
      ;;
    font)
      local dest=~/.local/share/fonts
      mkdir -p "$dest"
      for url in "$@"; do
        echo ":: Downloading font from $url"
        curl -L --fail -o "$dest/$(basename "$url")" "$url" || echo "❌ Failed: $url"
      done
      ;;
    video)
      local dest=~/media/videos/pilfered
      mkdir -p "$dest"
      for url in "$@"; do
        echo ":: Downloading video from $url"
        yt-dlp -P "$dest" "$url" || echo "❌ Failed: $url"
      done
      ;;
    doc)
      local dest=~/docs/lib
      mkdir -p "$dest"
      for url in "$@"; do
        echo ":: Downloading document from $url"
        curl -L --fail -o "$dest/$(basename "$url")" "$url" || echo "❌ Failed: $url"
      done
      ;;
    *)
      echo "Unknown pilfer type: $type"
      return 2
      ;;
  esac
}

# 📦 Extract archive
extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case "$archive" in
        *.tar.bz2) tar xvjf "$archive" ;;
        *.tar.gz)  tar xvzf "$archive" ;;
        *.bz2)     bunzip2 "$archive" ;;
        *.rar)     rar x "$archive" ;;
        *.gz)      gunzip "$archive" ;;
        *.tar)     tar xvf "$archive" ;;
        *.tbz2)    tar xvjf "$archive" ;;
        *.tgz)     tar xvzf "$archive" ;;
        *.zip)     unzip "$archive" ;;
        *.Z)       uncompress "$archive" ;;
        *.7z)      7z x "$archive" ;;
        *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

# ============================
# 🧪 Git Shortcuts
# ============================

gcom() {
  if [ $# -eq 0 ]; then
    echo "Usage: gcom \"commit message\" or gcom file1 file2 ... \"msg\""
    return 1
  fi
  if [ $# -eq 1 ]; then
    git add . && git commit -m "$1"
  else
    local msg="${*: -1}"
    local files=("${@:1:$#-1}")
    git add "${files[@]}"
    git commit -m "$msg"
  fi
}

gundo() {
  git reset --soft HEAD~1 && echo "Commit undone (soft)."
}

lazyg() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M')
  local messages=(
    "ugh, I'm probably just tweaking some annoying thing I missed before pushing the last time."
    "why is this always the last thing I see after pushing 😭"
    "tiny fix that shouldn't exist, but here we are."
    "did I push too early? yes. am I fixing it now? also yes."
    "fixing that one thing I swore was fine 10 minutes ago."
    "the commit of shame. [$timestamp]"
    "past me was too confident. again."
    "you didn't see this commit, okay?"
    "nothing to see here... just a tiny mistake with big dreams."
    "guess what? I forgot something. [$timestamp]"
  )
  local random_index=$((RANDOM % ${#messages[@]}))
  local random_msg="${messages[$random_index]} [$timestamp]"
  if [ $# -eq 0 ]; then
    git add . && git commit -m "$random_msg"
  elif [ $# -eq 1 ]; then
    git add . && git commit -m "$1"
  else
    local msg="${*: -1}"
    local files=("${@:1:$#-1}")
    git add "${files[@]}"
    git commit -m "$msg"
  fi
  git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
}

# ============================
# 🛠 Package & Repo Tools
# ============================

pacswap() {
  sudo pacman -Rns "$1" && sudo pacman -S "$2"
}

aurf() {
  local package_name="$1"
  local dest_dir="$HOME/.cache/aurutils/$package_name"
  if [ -z "$package_name" ]; then
    echo "Usage: aurf <package_name>"
    return 1
  fi
  if ! aur fetch "$package_name"; then
    echo "Error: Failed to fetch $package_name"
    return 1
  fi
  mkdir -p "$HOME/.cache/aurutils"
  mv "$package_name" "$dest_dir" || echo "Error: Failed to move $package_name to $dest_dir"
}

inspect() {
  local pkg_path="$AURDEST/$1/PKGBUILD"
  if [ -z "$1" ]; then
    echo "Usage: inspect <package_name>"
    return 1
  fi
  if [ -f "$pkg_path" ]; then
    less "$pkg_path"
  else
    echo "Error: PKGBUILD not found for package '$1'"
    return 1
  fi
}

# ============================
# 🔎 Search / Navigation
# ============================

ftext() {
  grep -iIHrn --color=always "$1" . | less -r
}

up() {
  local d=""
  for ((i = 1; i <= $1; i++)); do d="${d}/.."; done
  d="${d#/}"
  [ -z "$d" ] && d=..
  cd "$d" || return
}

z() {
  if declare -f __zoxide_z &>/dev/null; then
    __zoxide_z "$@" && ls
  else
    echo "zoxide is not initialized. Did you source prompt.sh first?"
  fi
}

# ============================
# 🧠 System Info / OS
# ============================

distribution() {
  local dtype="unknown"
  if [ -r /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      fedora | rhel | centos) dtype="redhat" ;;
      sles | opensuse*) dtype="suse" ;;
      ubuntu | debian) dtype="debian" ;;
      gentoo) dtype="gentoo" ;;
      arch | manjaro) dtype="arch" ;;
      slackware) dtype="slackware" ;;
      *) [[ "$ID_LIKE" =~ fedora|rhel|centos ]] && dtype="redhat"
         [[ "$ID_LIKE" =~ ubuntu|debian ]] && dtype="debian"
         [[ "$ID_LIKE" =~ arch ]] && dtype="arch" ;;
    esac
  fi
  echo "$dtype"
}

ver() {
  case "$(distribution)" in
    redhat) cat /etc/redhat-release ;;
    suse)   cat /etc/SuSE-release ;;
    debian) lsb_release -a ;;
    gentoo) cat /etc/gentoo-release ;;
    arch)   cat /etc/os-release ;;
    slackware) cat /etc/slackware-version ;;
    *) [ -s /etc/issue ] && cat /etc/issue || echo "Unknown distribution" ;;
  esac
  uname -a
}

# ============================
# 🔥 Firewall / Network Zones
# ============================

_log_fw() {
  local log_dir="$HOME/.local/var/log/firewall"
  mkdir -p "$log_dir"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$log_dir/zone-switch.log"
}

fwstatus() {
  echo "🔥 Active Zones:"
  sudo firewall-cmd --get-active-zones
  echo -e "\n📋 Current Rules:"
  sudo firewall-cmd --list-all
}

pentestmode() {
  _log_fw "Entering pentest mode..."
  for iface in $(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2~/^(wifi|ethernet|tun|vpn)$/ {print $1}'); do
    _log_fw " → $iface → pentest"
    sudo firewall-cmd --zone=pentest --change-interface="$iface" --permanent
  done
  sudo firewall-cmd --reload
  fwstatus
}

normalmode() {
  _log_fw "Reverting to FedoraWorkstation zone..."
  for iface in $(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2~/^(wifi|ethernet|tun|vpn)$/ {print $1}'); do
    _log_fw " → $iface → FedoraWorkstation"
    sudo firewall-cmd --zone=FedoraWorkstation --change-interface="$iface" --permanent
  done
  sudo firewall-cmd --reload
  fwstatus
}

# ============================
# 📚 Function Index
# ============================

index() {
  local search="${1,,}"
  local lines=(
    "aurf       - 📦 Fetch AUR package for local repo"
    "cat        - 🔍 Enhanced file viewer"
    "cd         - 📁 Smart cd"
    "cpg        - 📁 Copy and go"
    "countfiles - 📊 Count files in current dir"
    "distribution - 🧠 Detect distro type"
    "extract    - 📦 Extract any archive"
    "ftext      - 🔎 Search files by content"
    "fwstatus   - 🔥 Show firewall status"
    "gcom       - 🧪 Git commit helper"
    "gundo      - ↩️ Undo last commit"
    "inspect    - 📦 Inspect PKGBUILD"
    "lazyg      - 😅 Lazy git commit + push"
    "mkdirg     - 📁 Make and enter dir"
    "mvg        - 📁 Move and go"
    "normalmode - 🔐 Restore firewall zone"
    "pacswap    - ↔️ Replace a package"
    "pentestmode - 🛡️ Harden interfaces"
    "pilfer     - 📥 Download helper"
    "pwdtail    - 📍 Show last 2 path segments"
    "touchy     - 🛠️ Touch with mkdir"
    "up         - ⬆️ Go up N directories"
    "ver        - 🧠 Show version info"
    "z          - 🚀 zoxide wrapper"
  )
  echo -e "\n📚 Custom Function Index\n────────────────────────────"
  for line in "${lines[@]}"; do
    if [[ -z "$search" || "${line,,}" == *"$search"* ]]; then
      echo "$line"
    fi
  done
  echo
}

aliasindex() {
  local search="${1,,}"
  echo -e "\n📘 Alias Index\n────────────────────────────"
  alias | grep -i "$search"
  echo
}

