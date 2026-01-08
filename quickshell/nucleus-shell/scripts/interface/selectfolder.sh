#!/bin/bash

# Folder selector for wallpaper slideshow

START_DIR="${1:-$HOME/Pictures/Wallpapers}"

# Ensure start dir exists, fallback to Pictures or Home
if [ ! -d "$START_DIR" ]; then
    START_DIR="$HOME/Pictures"
fi
if [ ! -d "$START_DIR" ]; then
    START_DIR="$HOME"
fi

FOLDER=$(zenity --file-selection \
    --directory \
    --title="Select Wallpaper Folder" \
    --filename="$START_DIR/" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$FOLDER" ]; then
    echo "$FOLDER"
else
    echo "null"
fi
