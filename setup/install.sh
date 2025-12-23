#!/usr/bin/env bash
set -Eeuo pipefail

# ==================================================
# AELYX INSTALLER
# ==================================================

# ---------- Styling ----------
BOLD="\e[1m"
DIM="\e[2m"
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
GRAY="\e[90m"
RESET="\e[0m"

# ---------- Paths ----------
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_DIR="$ROOT_DIR/system"

# ---------- Helpers ----------
pause() { read -rp "$(echo -e "${DIM}Press Enter to continue...${RESET}")"; }

header() {
    clear
    echo -e "${BOLD}${BLUE}        >>> AELYX INSTALLER <<<${RESET}"
    echo -e "${GRAY}---------------------------------------------${RESET}\n"
}

confirm() {
    local prompt="$1"
    read -rp "$(echo -e "${BOLD}${prompt} [Y/n]: ${RESET}")" yn
    [[ -z "$yn" || "$yn" =~ ^[Yy]$ ]]
}

run_cmd() {
    local cmd="$1"
    echo -e "${BLUE}>> ${cmd}${RESET}"
    if ! bash -c "$cmd"; then
        while true; do
            echo -e "${RED}Command failed.${RESET}"
            echo "  1) Retry (default)"
            echo "  2) Skip (may break system)"
            echo "  3) Exit installer"
            read -rp "> " choice
            case "${choice:-1}" in
                1) bash -c "$cmd" && break ;;
                2) echo -e "${GRAY}Skipping...${RESET}"; break ;;
                3) exit 1 ;;
            esac
        done
    fi
}

# ---------- Header ----------
header

echo -e "${BOLD}NOTICE${RESET}"
echo -e "${GRAY}---------------------------------------------${RESET}"
echo "• This installer will modify your system"
echo "• You take full responsibility for all changes"
echo

if ! confirm "Do you want to continue?"; then
    echo "Aborted."
    exit 0
fi

# ---------- Install Mode ----------
header
echo -e "${BOLD}Select installation type:${RESET}\n"
echo "  1) All .dotfiles"
echo "     • All configs"
echo "     • All dependencies"
echo
echo "  2) Standalone shell"
echo "     • aelyx-shell + required deps"
echo

read -rp "> " INSTALL_MODE

case "$INSTALL_MODE" in
    1) INSTALL_PROFILE="full" ;;
    2) INSTALL_PROFILE="shell" ;;
    *) echo "Invalid selection"; exit 1 ;;
esac

# ---------- Execution Mode ----------
header
echo -e "${BOLD}Execution mode:${RESET}\n"
echo "  1) Ask before every command"
echo "  2) Automatic (recommended)"
echo

read -rp "> " EXEC_MODE
[[ "$EXEC_MODE" == "1" ]] && ASK_EACH=true || ASK_EACH=false

# ---------- Bootstrap ----------
header
echo -e "${BLUE}>> Preparing system...${RESET}"

BOOTSTRAP_CMD="bash \"$ROOT_DIR/bootstrap.sh\" $INSTALL_PROFILE"

if $ASK_EACH; then
    confirm "Run dependency installer?" && run_cmd "$BOOTSTRAP_CMD"
else
    run_cmd "$BOOTSTRAP_CMD"
fi

# ---------- File Installation ----------
header
echo -e "${BLUE}>> Installing configuration files...${RESET}"

run_cmd "mkdir -p ~/.config ~/.local/share/aelyx"

if [[ "$INSTALL_PROFILE" == "full" ]]; then
    run_cmd "cp -r \"$SYSTEM_DIR/.config/\"* ~/.config/"
    run_cmd "cp -r \"$SYSTEM_DIR/.local/share/aelyx/\"* ~/.local/share/aelyx/"
else
    run_cmd "cp -r \"$SYSTEM_DIR/.config/quickshell\" ~/.config/"
    run_cmd "cp -r \"$SYSTEM_DIR/.config/matugen\" ~/.config/"
    run_cmd "cp -r \"$SYSTEM_DIR/.local/share/aelyx/\"* ~/.local/share/aelyx/"
fi

# ---------- Finish ----------
header
echo -e "${GREEN}✔ Installation complete!${RESET}\n"
echo -e "${GRAY}Log out or reboot to ensure everything loads correctly.${RESET}"
