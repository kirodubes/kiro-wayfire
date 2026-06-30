# Changelog

All notable changes to **kiro-wayfire** are documented here.
Format: one dated entry per day (`YYYY.MM.DD`), newest first.

## 2026.06.30

### What Changed
- **Initial config package** for the Kiro wayfire edition — the 3D-effects member of the KIROTUX
  Wayland line. wayfire (wlroots) compositor with the same waybar + mako + swaybg shell as
  kiro-hyprland, so the look and feel match the Hyprland edition.
- **pywal theming.** One wallpaper drives every colour: `set-theme.sh` runs pywal at login and
  fans the palette out to waybar, mako, and the wayfire window borders, then live-reloads each.
- **3D effects as the signature**, at zero package cost — cube/expo/wobbly/wrot/zoom/fisheye/
  invert are core wayfire plugins. The cube is a deliberate showcase (Ctrl+Alt+drag), not the
  everyday switcher (that is `vswitch`, Super+1..9).

### Technical Details
- `etc/skel/.config/wayfire.ini` — single-file wayfire config modelled on the CachyOS and
  Archcraft references. Kiro's SUPER-based keybinds blended onto wayfire's plugin + `[command]`
  model: app launchers (CTRL+ALT + SUPER+F1..F12) in `[command]`; window management in
  `simple-tile`/`grid`/`vswitch`/`wm-actions`. `kiro-keybindings` on SUPER+CTRL+S. Layout `be,us`,
  Kiro-blue borders, blur on, transparent terminal via a window-rule.
- **Shell ported from kiro-hyprland** — `waybar/config.jsonc` keeps the same layout but uses
  `wlr/taskbar` in place of the Hyprland-only workspace module (wayfire has no native waybar
  workspace module; workspaces are driven by the expo overview + Super+1..9). `mako/config` and
  `style.css` carry Tokyo Night defaults, overwritten at login by pywal.
- **Lock pipeline** = hyprlock + hypridle (both wlroots-compatible via ext-session-lock /
  ext-idle-notify), reusing kiro-hyprland's `hyprlock.conf` + the betterlockscreen blur cache.
- `set-theme.sh` (pywal) — regenerates `waybar/colors.css`, rewrites the mako colour lines and the
  `wayfire.ini` border/background colours (hex→float), then SIGUSR2-reloads waybar + `makoctl
  reload` (wayfire auto-reloads its config on save).
- Everything from `extra` — **nothing built into `nemesis_repo`**. `wayfire-plugins-extra` is a
  free optdepend from chaotic-aur/cachyos; pixdecor (rounded corners) deliberately skipped for v1.

### Files
- `etc/skel/.config/wayfire.ini`
- `etc/skel/.config/waybar/{config.jsonc,style.css,colors.css}`
- `etc/skel/.config/mako/config`
- `etc/skel/.config/wayfire/{keybindings.txt,bg/kiro.jpg,scripts/set-theme.sh,scripts/import-gsettings.sh}`
- `etc/skel/.config/hypr/{hyprlock.conf,hypridle.conf}`
- `README.md`, `CLAUDE.md`, `up.sh`, `setup.sh`, `.gitignore`, `kiro.jpg`

### Not yet verified
- `wayfire.ini` not validated on a real wayfire boot (wayfire not installed on the build box) —
  verify on a real wayfire session before/at first ISO test, same caveat niri carried.
- `kiro-keybindings` / `/kiro-create-keybindings` still need **wayfire** added to their
  WM-detection table (known gap, same one Hyprland and niri hit).
