#!/usr/bin/env bash
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   Launch nwg-drawer (the big-icon app grid) sized to roughly the
#   center 60% width / 70% height of the active output, computed from
#   the live resolution instead of hardcoded pixels.
# Why:
#   nwg-drawer's -ml/-mr/-mt/-mb margins are pixel values, not
#   percentages, so a fixed number only looks right on the resolution
#   it was tuned on (1920x1080). Computing them from wlr-randr keeps
#   the same proportions on any display.
#####################################################################

set -euo pipefail

read -r RES < <(wlr-randr | grep -m1 "current" | grep -oP '\d+x\d+')
WIDTH="${RES%x*}"
HEIGHT="${RES#*x}"

MARGIN_LR=$(( WIDTH * 20 / 100 ))
MARGIN_TB=$(( HEIGHT * 15 / 100 ))

exec nwg-drawer -c 5 -is 96 -spacing 24 -i Surfn -g adw-gtk3-dark -term alacritty \
    -k -ovl -ml "$MARGIN_LR" -mr "$MARGIN_LR" -mt "$MARGIN_TB" -mb "$MARGIN_TB"
