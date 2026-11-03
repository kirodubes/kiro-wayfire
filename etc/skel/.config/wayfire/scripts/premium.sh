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

# The logic and its translated notification live in kiro-premium-hint (kiro-wayland-dotfiles), shared by
# every KiroTux edition; this script stays because existing wayfire.ini copies point Ctrl+Alt+H here.
exec kiro-premium-hint wayfire
