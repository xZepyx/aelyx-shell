#!/bin/bash
# ~/config/quickshell/scripts/background/gencolors.sh
# Generate Matugen color scheme for a given wallpaper

WALLPAPER_PATH="$1"
SCHEME_TYPE="$2"
SCHEME_MODE="$3"

if [[ -z "$WALLPAPER_PATH" || "$WALLPAPER_PATH" == "null" ]]; then
    echo "Error: no wallpaper provided" >&2
    exit 1
fi

# Strip file:// prefix if present
if [[ "$WALLPAPER_PATH" == file://* ]]; then
    WALLPAPER_PATH="${WALLPAPER_PATH#file://}"
fi

matugen image "$WALLPAPER_PATH" --type "$SCHEME_TYPE" --mode "$SCHEME_MODE"
