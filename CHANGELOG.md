# Changelog

All notable changes to **kiro-wayfire** are documented here.
Format: one dated entry per day (`YYYY.MM.DD`), newest first.

## 2026.07.01

### What Changed
- **Added Variety wallpaper-rotator autostart + keybinds.** `variety` (configured by
  `kiro-variety-config`) now autostarts alongside the existing static `swaybg` wallpaper. Ported
  the ohmychadwm `keybindings.txt` scheme (alt+N/P/T/F/arrows/Up/Down/W): next/previous/trash/
  favorite/pause/resume/selector, plus alt+shift+N/P/T/F/U combos that also trigger this edition's
  `set-theme.sh` pywal recolor (waybar/mako/`wayfire.ini` colour lines — live-reloaded since
  wayfire watches its own config file). `variety` + `kiro-variety-config` added to `depends=()`.
- **Swapped `rofi -show drun` for fuzzel (SUPER+D/Space/F11/F12) + added an nwg-drawer app-grid
  icon to waybar.** Found via community precedent across independent niri/sway/river rices in
  `~/Public` — fuzzel is Wayland-native (`wlr-layer-shell`), themeable, and works on niri despite
  targeting "wlroots" compositors by description. Evaluated live on picard (real-metal) before
  committing: theme, sizing, and the waybar icon were all tuned interactively on a running wayfire
  session first. `rofi` stays for `SUPER+SHIFT+D` (run mode) and the theme selector — no
  fuzzel/nwg-drawer equivalent for those. `fuzzel` + `nwg-drawer` added to `depends=()`.

### Technical Details
- Verified no existing `<alt>` binds collided with the new letters/arrows before adding (`KEY_N`/
  `KEY_P`/`KEY_T`/`KEY_F`/`KEY_W`/arrows were only bound with `<super>`, `<super><ctrl>`, or
  `<ctrl><alt>`, all different chords).
- The waybar launcher icon runs `~/.config/wayfire/scripts/app-drawer.sh`, not a raw `nwg-drawer`
  command — nwg-drawer's `-ml/-mr/-mt/-mb` margins are pixel values, so a fixed number only looks
  right at the resolution it was tuned on. The script parses `wlr-randr`'s current mode and
  computes margins as 20%/15% of width/height, reproducing the exact pixel values tuned live on a
  1920x1080 display (384/162) while scaling correctly on any other resolution.
- `drawer.css`: `window { padding: ... }` is silently ignored by GTK3 (nwg-drawer's content sits
  in an unnamed inner box, no `#id` to target) — used `window > box` instead.

### Files Modified
- [etc/skel/.config/wayfire.ini](etc/skel/.config/wayfire.ini)
- [etc/skel/.config/wayfire/keybindings.txt](etc/skel/.config/wayfire/keybindings.txt)
- [etc/skel/.config/wayfire/scripts/app-drawer.sh](etc/skel/.config/wayfire/scripts/app-drawer.sh) (new)
- [etc/skel/.config/waybar/config-wayfire.jsonc](etc/skel/.config/waybar/config-wayfire.jsonc)
- [etc/skel/.config/fuzzel/fuzzel.ini](etc/skel/.config/fuzzel/fuzzel.ini) (new)
- [etc/skel/.config/nwg-drawer/drawer.css](etc/skel/.config/nwg-drawer/drawer.css) (new)
- [CLAUDE.md](CLAUDE.md)
- [../KIROTUX-PKG-BUILD/kiro-wayfire/PKGBUILD](../KIROTUX-PKG-BUILD/kiro-wayfire/PKGBUILD)

## 2026.06.30

### What Changed
- **Moved shared dotfiles into the new `kiro-wayland-dotfiles` base** — mako, hyprlock/hypridle,
  and the waybar `colors.css`/`style.css` now come from that package (resolves the cross-edition
  file conflict, e.g. kiro-hyprland ↔ kiro-river both owning `~/.config/mako/config`). This edition
  now ships only its `waybar/config-<wm>.jsonc` and launches `waybar -c` against it.
- **Initial config package** for the Kiro wayfire edition — the 3D-effects member of the KIROTUX
  Wayland line. wayfire (wlroots) compositor with the same waybar + mako + swaybg shell as
  kiro-hyprland, so the look and feel match the Hyprland edition.
- **Fixed waybar appearing ~25s late at login** — the `[autostart]` panel entry now launches
  `env GTK_A11Y=none waybar`, skipping the at-spi accessibility bus that stalled the GTK bar before
  it painted (same fix applied across the Wayland line; first found on kiro-river).
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
