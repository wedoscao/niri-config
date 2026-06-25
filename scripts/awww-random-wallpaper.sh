#!/bin/bash
dir="$1"
WALLPAPER_LIST="/tmp/wallpaper_list.txt"

if [ ! -d "$dir" ]; then
    echo "Error: '$dir' is not a directory."
    exit 1
fi

for cmd in awww shuf grep find; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: '$cmd' is not installed or not in your PATH."
        exit 1
    fi
done

if [ ! -s "$WALLPAPER_LIST" ]; then
    find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.gif" \) >"$WALLPAPER_LIST"
    if [ ! -s "$WALLPAPER_LIST" ]; then
        echo "Error: No supported images found in '$dir'."
        rm -f "$WALLPAPER_LIST"
        exit 1
    fi
fi

while [[ -s "$WALLPAPER_LIST" ]]; do
    selected=$(shuf -n 1 "$WALLPAPER_LIST")
    grep -vFx "$selected" "$WALLPAPER_LIST" >"${WALLPAPER_LIST}.$$" && mv "${WALLPAPER_LIST}.$$" "$WALLPAPER_LIST"
    if [[ -f "$selected" ]]; then
        awww img "$selected"
        if command -v "notify-send" &>/dev/null; then
            notify-send --urgency=normal --expire-time=2000 "Wallpaper Changed"
        fi
        exit 0
    fi
done

echo "Error: All images in the list were missing."
exit 1
