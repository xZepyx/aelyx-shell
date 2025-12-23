#!/bin/bash

DIR="$HOME/Pictures/Wallpapers"

find "$DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) \
    -printf "%p\n"
