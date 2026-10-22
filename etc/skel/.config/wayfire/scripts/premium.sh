#!/usr/bin/env bash
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   Ctrl+Alt+H: start Kirotux Wayfire Premium when it is installed; otherwise show a notification
#   with a "Get KiroTux" button that opens the KiroTux page.
# Why:
#   This edition is used with and without the premium app (free Kiro users get the config from
#   nemesis_repo). Same behaviour as the Hyprland and niri editions' Ctrl+Alt+H.
#####################################################################

set -euo pipefail

if command -v kirotux-wayfire-premium >/dev/null 2>&1; then
    exec kirotux-wayfire-premium
fi

answer=$(notify-send -a Kirotux -i preferences-desktop-theme -A get='Get KiroTux' 'Get Kirotux Wayfire Premium' \
    'Theme, window look, wallpaper and keyboard in one app. Comes with the KIROTUX ISOs.' || true)
[ "$answer" = "get" ] && exec xdg-open https://kiroproject.be/kirotux.html
exit 0
