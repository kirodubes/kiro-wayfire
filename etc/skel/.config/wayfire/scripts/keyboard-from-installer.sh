#!/usr/bin/env bash
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   At login on an installed system, set wayfire's keyboard layout to the one picked in the installer.
#   Calamares (kiro_final) writes XKBLAYOUT / XKBVARIANT to /etc/vconsole.conf; this script puts them
#   into the user's own wayfire.ini in place of the shipped us,be default. wayfire reloads wayfire.ini
#   when it changes, so the layout applies straight away.
# Why:
#   wayfire.ini can't read a file at runtime, so a user who picked e.g. Belgian still typed US. Same
#   approach as the niri editions. Only the untouched shipped line is replaced, so a layout the user set
#   is never overwritten, and there is no "done" stamp: `skell` copies /etc/skel back and restores the
#   shipped line. To keep us,be on purpose, change the line in any way, e.g. xkb_layout = us,be # mine
#   No-op on the live ISO (no XKBLAYOUT there).
#####################################################################

set -euo pipefail

INI="$HOME/.config/wayfire.ini"
DEFAULT='xkb_layout = us,be'

[ -f "$INI" ] || exit 0
[ -r /etc/vconsole.conf ] || exit 0

layout=$(sed -n 's/^XKBLAYOUT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)
variant=$(sed -n 's/^XKBVARIANT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)

# Live ISO / no installer choice, or the installer picked exactly the shipped default: nothing to do.
[ -n "$layout" ] || exit 0
[ "$layout" = "us,be" ] && [ -z "$variant" ] && exit 0

grep -qxF "$DEFAULT" "$INI" || exit 0
new="xkb_layout = $layout"
[ -n "$variant" ] && new="$new
xkb_variant = $variant"
tmp="$INI.tmp.$$"
awk -v def="$DEFAULT" -v new="$new" '$0 == def { print new; next } { print }' "$INI" > "$tmp" && mv "$tmp" "$INI"
