#!/usr/bin/env bash
set -Eeuo pipefail

RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
GRAY="\033[90m"
RESET="\033[0m"

confirm() {
    read -rp "$1 [y/N]: " yn
    [[ "$yn" =~ ^[Yy]$ ]]
}

run_cmd() {
    local cmd="$1"
    echo -e "${BLUE}>> $cmd${RESET}"

    if ! bash -c "$cmd"; then
        echo -e "${RED}command failed${RESET}"
        echo "1) retry"
        echo "2) skip"
        echo "3) exit"
        read -rp "> " c
        case "${c:-1}" in
            1) run_cmd "$cmd" ;;
            2) echo -e "${GRAY}skipped${RESET}" ;;
            3) exit 1 ;;
        esac
    fi
}

exists() {
    command -v "$1" &>/dev/null
}

installed() {
    pacman -Qs "$1" &>/dev/null
}

if ! confirm "install dependencies?"; then
    exit 0
fi

if ! exists git; then
    run_cmd "sudo pacman -S --needed git"
fi

if ! exists yay; then
    confirm "install yay?" && {
        run_cmd "sudo pacman -S --needed base-devel"
        tmp=$(mktemp -d)
        run_cmd "git clone https://aur.archlinux.org/yay.git $tmp/yay"
        run_cmd "cd $tmp/yay && makepkg -si"
        rm -rf "$tmp"
    }
fi

packages=(
    hyprland hyprpaper hyprlock hyprpicker
    wf-recorder grim slurp
    kitty fish starship
    firefox nautilus
    networkmanager wireplumber bluez-utils
    fastfetch playerctl brightnessctl
    papirus-icon-theme-git hyprsunset
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
    quickshell matugen-bin
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    xdg-desktop-portal-hyprland
    zenity jq ddcutil flatpak
)

for pkg in "${packages[@]}"; do
    if installed "$pkg"; then
        echo -e "${GRAY}$pkg already installed${RESET}"
    else
        run_cmd "yay -S --noconfirm $pkg"
    fi
done

echo -e "${GREEN}done${RESET}"
