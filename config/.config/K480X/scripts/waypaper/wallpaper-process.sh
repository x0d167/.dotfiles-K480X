#!/usr/bin/env bash

input="$1"

# PATHS --------------------------------------------------------

CACHEDIR="$HOME/.cache/wallpapers"
CURRENT_FILE="$CACHEDIR/current"
RASI_FILE="$CACHEDIR/current.rasi"

BLURDIR="$CACHEDIR/blurred"

# NEXT: wlogout and SDDM paths (we will troubleshoot if needed)
WLOGOUT_BG="$BLURDIR/wlogout.png"      # symlink or copy target
SDDM_BG="$BLURDIR/sddm.png"            # symlink or copy target

mkdir -p "$CACHEDIR" "$BLURDIR"

update_rofi_background() {
    # Use blurred wallpaper for Rofi
    local base="$(basename "$input")"
    local name="${base%.*}"
    local blur_src="$BLURDIR/$name-blur.png"

    if [[ ! -f "$blur_src" ]]; then
        echo "Warning: blurred wallpaper missing. Run grip-wallpaper-cache.sh"
        return
    fi

    cat <<EOF > "$RASI_FILE"
* {
    current-image: url("$blur_src", height);
}
EOF
}

update_wlogout_background() {
    local base="$(basename "$input")"
    local name="${base%.*}"
    local blur_src="$BLURDIR/$name-blur.png"

    if [[ ! -f "$blur_src" ]]; then
        echo "Warning: blurred wallpaper missing. Run grip-wallpaper-cache.sh"
        return
    fi

    # wlogout expects background INSIDE ~/.config/wlogout
    ln -sf "$blur_src" "$HOME/.config/wlogout/bg.png"
}

update_sddm_background() {
    local base="$(basename "$input")"
    local name="${base%.*}"
    local blur_src="$BLURDIR/$name-blur.png"

    if [[ ! -f "$blur_src" ]]; then
        echo "Warning: blurred wallpaper missing. Run grip-wallpaper-cache.sh"
        return
    fi

    local sddm_bg="/usr/share/sddm/themes/elarun/images/background.png"

    # Ensure directory exists
    if [[ ! -d "/usr/share/sddm/themes/elarun/images" ]]; then
        echo "SDDM directory missing!"
        return
    fi

    # Symlink blurred wallpaper for SDDM
    sudo ln -sf "$blur_src" "$sddm_bg"

    echo "Updated SDDM background → $sddm_bg"
}

apply_wallust_matugen() {
    matugen image "$input"
    wallust run "$input"
}

reload_waybar() {
    killall waybar 2>/dev/null
    waybar &>/dev/null &
}

write_current_path() {
    echo "$input" > "$CURRENT_FILE"
}

# Tell Matugen and Wallust the current wallpaper
apply_wallust_matugen

# Reload Waybar to apply new theme
reload_waybar 


# Write current wallpaper path to file
write_current_path

# Update Rofi and Wlogout backgrounds
update_wlogout_background
update_rofi_background



