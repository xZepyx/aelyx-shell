#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG="$HOME/.config/aelyx-shell/config/settings.json"
QS_DIR="$HOME/.config/quickshell/aelyx-shell"
REPO="xZepyx/aelyx-shell"
API="https://api.github.com/repos/$REPO/releases"

figlet "Updating"

echo
echo "Version to install:"
echo "  1) Stable"
echo "  2) Pre-release (indev)"
echo

read -rp "Select option (1/2): " choice

case "$choice" in
    1) mode="stable" ;;
    2) mode="indev" ;;
    *)
        echo "invalid option"
        exit 1
        ;;
esac

# Check config exists
if [[ ! -f "$CONFIG" ]]; then
    echo "settings.json not found"
    exit 1
fi

# Get current version
current="$(jq -r '.shellInfo.version // empty' "$CONFIG")"
if [[ -z "$current" ]]; then
    echo "version not found"
    exit 1
fi

# Fetch releases and select tag
latest_tag="$(
  curl -fsSL "$API" |
  jq -r "
    map(select(.draft == false)) |
    $( [[ "$mode" == "stable" ]] && echo 'map(select(.prerelease == false)) |' ) 
    sort_by(.published_at) |
    last |
    .tag_name
  "
)"

if [[ -z "$latest_tag" || "$latest_tag" == "null" ]]; then
    echo "failed to determine release version"
    exit 1
fi

latest="${latest_tag#v}"

if [[ "$current" == "$latest" ]]; then
    echo "already up to date ($current)"
    exit 0
fi

# Download GitHub source zip
tmp="$(mktemp -d)"
zip="$tmp/source.zip"

curl -fL \
    "https://github.com/$REPO/archive/refs/tags/$latest_tag.zip" \
    -o "$zip"

# Extract zip
unzip -q "$zip" -d "$tmp"

root_dir="$tmp/aelyx-shell-${latest}"

if [[ ! -d "$root_dir" ]]; then
    echo "failed to locate extracted source directory: $root_dir"
    exit 1
fi

SRC_DIR="$root_dir/quickshell/aelyx-shell"

if [[ ! -d "$SRC_DIR" ]]; then
    echo "aelyx-shell folder not found in source archive"
    exit 1
fi

# Replace contents
rm -rf "$QS_DIR"
mkdir -p "$QS_DIR"
cp -r "$SRC_DIR/"* "$QS_DIR/"

# Update version in config.json
tmp_cfg="$(mktemp)"
jq --arg v "$latest" '.shellInfo.version = $v' "$CONFIG" > "$tmp_cfg"
mv "$tmp_cfg" "$CONFIG"

# Reload system
nohup killall qs; qs -c aelyx-shell > /dev/null 2>&1 & disown

echo "Updated $current -> $latest"
