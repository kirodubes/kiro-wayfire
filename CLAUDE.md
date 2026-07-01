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
- **Launchers: fuzzel (keyboard) + nwg-drawer (visual grid), not plain rofi.** `SUPER+D`/`SUPER+
  Space`/`SUPER+F11`/`F12` open **fuzzel** (fast, Wayland-native, themed Tokyo Night — found via
  community precedent in multiple `~/Public` niri/sway/river rices, not just wayfire). The waybar
  top-left icon (`` U+F0BAF, nf-md-apps) opens **nwg-drawer** via
  `~/.config/wayfire/scripts/app-drawer.sh` — a 5-column, 96px-icon, Surfn-themed app grid sized
  to the center 60%×70% of the *actual* output resolution (computed at runtime from `wlr-randr`,
  not hardcoded — the values were tuned live on a 1920x1080 display but the script scales).
  `rofi` stays for `SUPER+SHIFT+D` (run launcher) and `SUPER+R`/`ALT+R` (theme selector) — no
  fuzzel/nwg-drawer equivalent for those.
- **Autostart:** wayfire's `[autostart]` table (`name = command`, run via `/bin/sh -c` — pipes &
  `[ ]` work, unlike Hyprland's exec_cmd). `autostart_wf_shell = false` so wf-panel doesn't fight
  waybar. XDG-autostart-only items (`xdg-user-dirs-update`) added by hand.
- **Theming:** **pywal** (Erik's explicit choice). `set-theme.sh` runs pywal on the wallpaper at
  login → regenerates `waybar/colors.css`, rewrites mako + `wayfire.ini` colour lines, reloads.
  This differs from kiro-hyprland (static Tokyo Night) and niri (noctalia/matugen).
- **Lock/idle:** hyprlock + hypridle (wlroots-compatible), reusing kiro-hyprland's `hyprlock.conf`
  + the betterlockscreen blur cache. `session-lock` is in the plugin list so the protocol is live.
- **Dependencies:** everything from Arch `extra` — **nothing into `nemesis_repo`**.
  `wayfire-plugins-extra` is a free optdepend (chaotic-aur/cachyos). pixdecor (rounded corners)
  deliberately skipped for v1 — wayfire's built-in `decoration` plugin is used (square corners).

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
- **No native waybar workspace module** for wayfire — the bar uses `wlr/taskbar`; workspaces are
  surfaced by the expo overview (tap SUPER) + SUPER+1..9. A custom IPC workspace module is a
  documented future enhancement.
- **cube is loaded but bound to CTRL+ALT+drag** — a showcase, not the everyday switcher (vswitch).
- **Validated on a real wayfire boot** (picard, real-metal, 2026-07-01): installed via `pacman`,
  confirmed waybar/`wlr/taskbar` render correctly, fuzzel and nwg-drawer both launch and theme
  correctly. (The one issue hit — no workspace pills in waybar — was expected/by-design, not a
  bug; see the "No native waybar workspace module" note below.)
- `nwg-drawer`'s window content sits in an unnamed inner GTK box (`win.Add(outerVBox)` in its
  source, no `#id`), so `window { padding: ... }` in `drawer.css` is silently ignored by GTK3 —
  target `window > box` instead for inner padding.

## Build / delivery
- Source-of-truth for the config; delivered as the `kiro-wayfire` package via
  `../KIROTUX-PKG-BUILD/kiro-wayfire/build.sh` (public recipe → `~/EDU/nemesis_repo/`). After
  editing here: rebuild the package (recipe `build.sh`), then the ISO to test a fresh install.
- See [../CLAUDE.md](../CLAUDE.md) for the full KIROTUX delivery architecture.
