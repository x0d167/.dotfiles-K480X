#!/usr/bin/env bash

input="$1"
cache_dir="$HOME/.config/K480X/cache"
archive_dir="$cache_dir/wallpaper-generated"

# Tell Matugen the current wallpaper
matugen image "$input"
wallust run "$input"

# Reload Waybar to apply new theme
killall waybar 2>/dev/null
waybar & 

mkdir -p "$cache_dir" "$archive_dir"

filename=$(basename "$input")
base="${filename%.*}"

# Write current wallpaper path to file
echo "$input" > "$cache_dir/current_wallpaper"

# Define outputs
blurred="$cache_dir/blurred_wallpaper.png"
square="$cache_dir/square_wallpaper.png"
rasi_file="$cache_dir/current_wallpaper.rasi"

archived_blur="$archive_dir/${base}_blur.png"
archived_square="$archive_dir/${base}_square.png"

# Use cached if available
if [[ -f "$archived_blur" && -f "$archived_square" ]]; then
    cp "$archived_blur" "$blurred"
    cp "$archived_square" "$square"
else
    # Generate 50x30 blurred version
    magick "$input" -resize 1920x1200^ -gravity center -extent 1920x1200 -blur 0x12 "PNG24:$blurred"

    # Generate small square crop
    magick "$input" -resize 1200x1200^ -gravity center -extent 1200x1200 "PNG24:$square"

    # Save to archive
    cp "$blurred" "$archived_blur"
    cp "$square" "$archived_square"
fi

# Generate .rasi for Rofi use
cat <<EOF > "$rasi_file"
* {
    current-image: url("$blurred", height);
}
EOF

