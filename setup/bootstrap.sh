#!/usr/bin/env bash
set -Eeuo pipefail

PROFILE="${1:-full}"

# ---------- Colors ----------
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
GRAY="\033[0;90m"
RESET="\033[0m"

# ---------- Packages ----------
FULL_PACKAGES=(
    hyprland hyprpaper hyprlock hyprpicker
    wf-recorder grim slurp
    kitty fish starship
    firefox nautilus
    networkmanager wireplumber bluez-utils
    fastfetch playerctl brightnessctl
    papirus-icon-theme-git
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
    quickshell matugen-bin
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    xdg-desktop-portal-hyprland
    zenity jq ddcutil flatpak
)

SHELL_PACKAGES=(
    quickshell matugen-bin zenity
    kitty starship fish
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
)

PACKAGES=("${FULL_PACKAGES[@]}")
[[ "$PROFILE" == "shell" ]] && PACKAGES=("${SHELL_PACKAGES[@]}")

# ---------- Helpers ----------
exists() { command -v "$1" &>/dev/null; }
installed() { pacman -Qs "$1" &>/dev/null; }

install_yay() {
    echo -e "${BLUE}>> Installing yay...${RESET}"
    sudo pacman -S --needed --noconfirm base-devel git
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    pushd "$tmp/yay" >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf "$tmp"
}

# ---------- Start ----------
clear
echo -e "${GREEN}"
cat <<"EOF"
   ____    __
  / __/__ / /___ _____
 _\ \/ -_) __/ // / _ \
/___/\__/\__/\_,_/ .__/
                /_/
Aelyx dependency installer (Arch-based)
EOF
echo -e "${RESET}"

# ---------- yay ----------
if ! exists yay; then
    install_yay
else
    echo -e "${GRAY}:: yay already installed${RESET}"
fi

# ---------- Install ----------
for pkg in "${PACKAGES[@]}"; do
    if installed "$pkg"; then
        echo -e "${GRAY}:: $pkg already installed${RESET}"
    else
        echo -e "${BLUE}:: Installing $pkg${RESET}"
        yay -S --noconfirm "$pkg" || {
            echo -e "${RED}Failed to install $pkg${RESET}"
            exit 1
        }
    fi
done

echo -e "${GREEN}✔ Dependencies installed successfully${RESET}"
