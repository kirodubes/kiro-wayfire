# kiro-wayfire — Claude project instructions

## Overview
Config package for the **Kiro wayfire edition** — the 3D-effects member of the KIROTUX Wayland
line (sibling to [kiro-hyprland](../kiro-hyprland/CLAUDE.md)). Public, open-core, shipped via
`nemesis_repo`. Full research + decisions live in the internal `Kiro-HQ/Kirotux/study-of-wayfire.md`.

## Edition spec (the WM-variable matrix)
- **Compositor:** wayfire 0.10.x (wlroots-based, 3D/Compiz-style — cube, expo, wobbly, wrot, zoom).
- **Config language:** INI, **single file** `etc/skel/.config/wayfire.ini` (no include mechanism,
  unlike niri's modular KDL). `[core] plugins =` is the master switch; `[command]` holds app
  launchers; window management lives in the plugin sections.
- **Desktop shell:** **waybar + mako + swaybg** — the same stack as kiro-hyprland (wayfire is
  wlroots, so it ports almost directly). This is the deliberate "re-converge the line" choice.
- **Launchers: fuzzel (keyboard) + rofi Kiro-Grid (visual grid).** `SUPER+D`/`SUPER+Space`/`SUPER+F11`/`F12`
  open **fuzzel** (fast, Wayland-native, themed Tokyo Night). The waybar top-left icon (U+F0BAF, nf-md-apps) runs
  `~/.config/wayfire/scripts/app-drawer.sh`: rofi 2.0 (native Wayland) with the **`Kiro-Grid`** theme from
  `kiro-rofi-themes` — a centered 750px card, 5 columns x 3 rows of 64px Surfn icons with names (adi1090x launcher
  type-3 style-1). A second click closes it. It replaced nwg-drawer on 2026-10-22 (sleeker, no extra package).
  The card is 85% opaque so it reads without blur; `[blur] blur_by_default` also matches `app_id contains "rofi"`
  for the frosted look. `rofi` also covers `SUPER+SHIFT+D` (run) and `SUPER+R`/`ALT+R` (theme selector).
- **Autostart:** wayfire's `[autostart]` table (`name = command`, run via `/bin/sh -c` — pipes &
  `[ ]` work, unlike Hyprland's exec_cmd). `autostart_wf_shell = false` so wf-panel doesn't fight
  waybar. XDG-autostart-only items (`xdg-user-dirs-update`) added by hand.
- **Theming:** **pywal** (Erik's explicit choice). `set-theme.sh` runs pywal on the wallpaper at
  login → regenerates `waybar/colors.css`, rewrites mako + `wayfire.ini` colour lines, reloads.
  This differs from kiro-hyprland (static Tokyo Night) and niri (noctalia/matugen).
- **Lock/idle:** hyprlock + hypridle (wlroots-compatible), reusing kiro-hyprland's `hyprlock.conf`
  + the betterlockscreen blur cache. `session-lock` is in the plugin list so the protocol is live.
- **Dependencies:** everything from Arch `extra` — **nothing into `nemesis_repo`**.
  `wayfire-plugins-extra` is left out (2026-10-22): wayfire 0.11 moved fisheye there, but chaotic-aur/cachyos still
  ship its 0.10 build, which doesn't load on 0.11. pixdecor (rounded corners)
  deliberately skipped for v1 — wayfire's built-in `decoration` plugin is used (square corners).
- **KiroTux premium contract:** Kirotux Wayfire Premium writes only its own keys into `wayfire.ini` and lists them in
  `~/.config/wayfire/kirotux-appearance.ini`. Anything else that edits `wayfire.ini` (`set-theme.sh`,
  `keyboard-from-installer.sh`) must skip a key listed there. hypridle runs the app's
  `~/.config/kirotux-wayfire-premium/hypridle.conf` when present. wf-config: an unescaped `#` anywhere starts a
  comment, so colours are written as floats (`r g b a`).

## Keybindings
- SUPER grammar ported from kiro-hyprland: CTRL+ALT launchers + SUPER+F1..F12 + `kiro-keybindings`
  on SUPER+CTRL+S. App launches in `[command]`; window-management chords in wayfire's own
  vocabulary (`simple-tile` focus, `grid` snap, `vswitch` workspaces, `wm-actions`) — **not** a
  1:1 copy of Hyprland's dispatchers (no master/dwindle/groups/scratchpad in wayfire).
- `etc/skel/.config/wayfire/keybindings.txt` mirrors `wayfire.ini` — keep them in lockstep; a
  duplicate-chord scan must pass. `kiro-keybindings`'s `WM_MAP` already includes `wayfire`
  (fixed 2026-07-01, along with the other five KIROTUX Wayland editions missing at the time).

## Patterns / gotchas
- **wayfire colours are float-RGBA** (`r g b a`, 0–1), not hex — `set-theme.sh` converts.
- wayfire **watches wayfire.ini and live-reloads on save**, which is why `set-theme.sh` can patch
  the border/background colours in place with no explicit reload command.
- **waybar workspaces = native `wayfire/workspaces`** (2026-10-26, waybar 0.13+): shows 1..9 for the 3x3 vswitch grid,
  clickable, and follows SUPER+1..9. It talks wayfire IPC, so `ipc` + `ipc-rules` must stay in `plugins =`.
  `wlr/taskbar` was dropped (Erik doesn't want app icons; it never worked anyway, since `foreign-toplevel` isn't loaded).
  Bar height 26 (the module's minimum).
- **cube is loaded but bound to CTRL+ALT+drag** — a showcase, not the everyday switcher (vswitch).
- **Validated on a real wayfire boot** (picard, real-metal, 2026-07-01): installed via `pacman`,
  confirmed waybar renders correctly, fuzzel launches and themes correctly. Workspace numbers in waybar
  were added later (2026-10-26, tested on picard).
- **nwg-drawer is gone** (2026-10-22): the app grid is rofi Kiro-Grid, so the dependency and the
  `~/.config/nwg-drawer/` skel folder were dropped (−41 MiB on the ISO).
- **Own session** (2026-10-22): `kiro-wayfire.desktop` ("Kiro Wayfire") runs `/usr/bin/kiro-wayfire-session`, which
  exports `QT_QPA_PLATFORMTHEME=gtk3` + `QT_STYLE_OVERRIDE=kvantum` and execs wayfire (same `~/.config/wayfire.ini`).
  The hide helper + pacman hook stamp `NoDisplay=true` on upstream `wayfire.desktop`; `kiro-wayfire.install` applies
  it on install and moves SDDM's remembered session (`/var/lib/sddm/state.conf`) from `wayfire.desktop` to
  `kiro-wayfire.desktop`, so existing users don't fall into another session. Calamares maps
  `/usr/bin/kiro-wayfire-session` → `kiro-wayfire` (kirotux-calamares-config).

- **VM cursor:** `etc/profile.d/kiro-wayfire-vm-cursor.sh` sets `WLR_NO_HARDWARE_CURSORS=1` for wayfire in a
  VM only. Without it, QEMU virtio-gpu draws the pointer away from where clicks land (Calamares unclickable).
  wayfire has no env setting in `wayfire.ini`; SDDM's wayland-session sources `/etc/profile`, so profile.d works.

## Build / delivery
- Source-of-truth for the config; delivered as the `kiro-wayfire` package via
  `~/KIRO-PKG-BUILD-APPS/kiro-wayfire/build.sh` (public recipe → `~/EDU/nemesis_repo/`). After
  editing here: rebuild the package (recipe `build.sh`), then the ISO to test a fresh install.
- See [KIROTUX/CLAUDE.md](../../KIROTUX/CLAUDE.md) for the full KIROTUX delivery architecture.
