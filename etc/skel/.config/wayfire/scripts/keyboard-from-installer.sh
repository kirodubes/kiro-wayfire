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
#   AZERTY (first layout be or fr): wayfire binds keys by position (keycode), not by letter, so Super+Q
#   would sit on the key labelled A. The few shipped bindings on A/Q/Z/W/M move to the AZERTY positions,
#   so the letters in keybindings.txt are right. Only untouched shipped lines change (idempotent).
#####################################################################

set -euo pipefail

INI="$HOME/.config/wayfire.ini"
DEFAULT='xkb_layout = us,be'

[ -f "$INI" ] || exit 0
[ -r /etc/vconsole.conf ] || exit 0

layout=$(sed -n 's/^XKBLAYOUT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)
variant=$(sed -n 's/^XKBVARIANT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' /etc/vconsole.conf | head -n1)

set_layout() {
    # The layout was picked in Kirotux Wayfire Premium (its record file lists the key): that choice wins.
    grep -q '^xkb_layout = ' "$HOME/.config/wayfire/kirotux-appearance.ini" 2>/dev/null && return 0
    # Live ISO / no installer choice, or the installer picked exactly the shipped default: nothing to do.
    [ -n "$layout" ] || return 0
    [ "$layout" = "us,be" ] && [ -z "$variant" ] && return 0
    grep -qxF "$DEFAULT" "$INI" || return 0
    local new="xkb_layout = $layout" tmp="$INI.tmp.$$"
    [ -n "$variant" ] && new="$new
xkb_variant = $variant"
    awk -v def="$DEFAULT" -v new="$new" '$0 == def { print new; next } { print }' "$INI" > "$tmp" && mv "$tmp" "$INI"
}

azerty_binds() {
    # The layout wayfire uses now (after set_layout, or picked in the app), first code only.
    local first tmp="$INI.tmp.$$"
    first=$(sed -n 's/^xkb_layout = \([^,# ]*\).*/\1/p' "$INI" | head -n1)
    case "$first" in be|fr) ;; *) return 0 ;; esac
    awk '
        $0 == "close_top_view = <super> KEY_Q | <super> <shift> KEY_Q | <alt> KEY_F4" {
            print "close_top_view = <super> KEY_A | <super> <shift> KEY_A | <alt> KEY_F4"; next }
        $0 == "toggle_always_on_top = <super> <shift> KEY_A" { print "toggle_always_on_top = <super> <shift> KEY_Q"; next }
        $0 == "binding_wall_selector = <alt> KEY_W" { print "binding_wall_selector = <alt> KEY_Z"; next }
        $0 == "binding_usbwriter = <ctrl> <alt> KEY_M" { print "binding_usbwriter = <ctrl> <alt> KEY_SEMICOLON"; next }
        $0 == "binding_volume = <super> KEY_V | <ctrl> <alt> KEY_U | <super> <ctrl> KEY_A" {
            print "binding_volume = <super> KEY_V | <ctrl> <alt> KEY_U | <super> <ctrl> KEY_Q"; next }
        $0 == "binding_ai_agent = <super> <ctrl> <shift> KEY_A" { print "binding_ai_agent = <super> <ctrl> <shift> KEY_Q"; next }
        $0 == "binding_spotify = <super> <shift> KEY_M" { print "binding_spotify = <super> <shift> KEY_SEMICOLON"; next }
        { print }' "$INI" > "$tmp"
    if cmp -s "$tmp" "$INI"; then rm -f "$tmp"; else mv "$tmp" "$INI"; fi
}

layout_switch_keys() {
    # grp:alt_shift_toggle (shipped until 2026-10-22) made Alt+Shift switch layouts inside xkb, so wayfire never saw
    # the Shift and every <alt> <shift> binding (the Variety recolour keys) fell through to plain Alt. Both Ctrl
    # keys switch layouts now. Only the untouched shipped line changes.
    local tmp="$INI.tmp.$$"
    awk '$0 == "xkb_options = grp:alt_shift_toggle,compose:caps" { print "xkb_options = grp:ctrls_toggle,compose:caps"; next }
        { print }' "$INI" > "$tmp"
    if cmp -s "$tmp" "$INI"; then rm -f "$tmp"; else mv "$tmp" "$INI"; fi
}

set_layout
azerty_binds
layout_switch_keys
