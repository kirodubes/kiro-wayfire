#!/bin/bash
set -euo pipefail
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   Open the app grid: rofi with the Kiro-Grid theme (kiro-rofi-themes),
#   a centered card of big icons with their names, 5 per row. A second
#   click on the waybar icon closes it again.
# Why:
#   rofi 2.0 is native Wayland and already a dependency, so the grid
#   costs no extra package (it replaced nwg-drawer here).
#####################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ -t 1 ]]; then
    RED="$(tput setaf 1 2>/dev/null || true)"
    GREEN="$(tput setaf 2 2>/dev/null || true)"
    YELLOW="$(tput setaf 3 2>/dev/null || true)"
    BLUE="$(tput setaf 4 2>/dev/null || true)"
    CYAN="$(tput setaf 6 2>/dev/null || true)"
    RESET="$(tput sgr0 2>/dev/null || true)"
else
    RED="" GREEN="" YELLOW="" BLUE="" CYAN="" RESET=""
fi

log_section() { echo "${GREEN}############################################################"; echo "$*"; echo "############################################################${RESET}"; }
log_info()    { echo "${BLUE}############################################################"; echo "$*"; echo "############################################################${RESET}"; }
log_warn()    { echo "${YELLOW}############################################################"; echo "$*"; echo "############################################################${RESET}"; }
log_error()   { echo "${RED}############################################################"; echo "$*"; echo "############################################################${RESET}"; }
log_success() { echo "${GREEN}############################################################"; echo "$*"; echo "############################################################${RESET}"; }

on_error() {
    echo "${RED}ERROR on line $1: $2${RESET}"
    sleep 10
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

main() {
    if pgrep -x rofi >/dev/null; then
        log_info "rofi is open, closing it"
        pkill -x rofi || true
    else
        log_section "Opening the Kiro-Grid app grid"
        # Escape (exit 1) and the toggle's pkill (143) are normal ways to close it, not errors
        rofi -show drun -theme Kiro-Grid -icon-theme Surfn || true
    fi
    log_success "$(basename "$0") done"
}

main "$@"
