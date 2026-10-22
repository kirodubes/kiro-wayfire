# Changelog

All notable changes to **kiro-wayfire** are documented here.
Format: one dated entry per day (`YYYY.MM.DD`), newest first.

## 2026.10.22

### What Changed
- **The Alt+Shift keys work: layouts switch with both Ctrl keys now.** `xkb_options` had `grp:alt_shift_toggle`, so
  Alt+Shift switched the keyboard layout before wayfire saw the keys, and every Alt+Shift binding fell through to
  plain Alt: Alt+Shift+N changed the wallpaper (Alt+N) but never recoloured. The layout toggle is
  `grp:ctrls_toggle` (left + right Ctrl together). Existing users get it at the next login (only the untouched shipped
  line changes).
- **Variety + recolour works on every wallpaper, with the right colours.** Two more fixes, found on two real machines:
  - The theme now uses **pywal16** (`python-pywal16`), the maintained fork of pywal. The old pywal 3.3 (archived
    upstream) gave up on flat wallpapers with few colours and then nothing was recoloured (about 1 in 25 Variety
    wallpapers). pywal16 recoloured all 40 test wallpapers and the failing one; `set-theme.sh` is unchanged.
  - Alt+Shift+N, Alt+Shift+P, Alt+Shift+T and Alt+Shift+F wait 3 seconds instead of 1 before asking Variety for the
    new wallpaper: after 1 second Variety could still report the previous one, so the colours lagged one wallpaper
    behind. New installs only; existing users can change `sleep 1` to `sleep 3` in their `~/.config/wayfire.ini`.
- **The terminal follows the wallpaper's colours too.** pywal recoloured waybar, mako and the borders, but Alacritty
  kept its built-in colours: pywal 3.3 has no Alacritty template and the edition ships no Alacritty config.
  `set-theme.sh` now writes the palette to `~/.cache/wal/colors-alacritty.toml`, and when you have no
  `~/.config/alacritty/alacritty.toml` it creates a small one that imports it. Alacritty reloads by itself, so open
  terminals change with Alt+Shift+N and at login. An existing `alacritty.toml` (yours or kiro-dot-files') is left
  alone. Tested on the QEMU install: the palette is rewritten on Alt+Shift+N and imported.
- **Own session "Kiro Wayfire" with the Qt variables.** Qt apps now get `QT_QPA_PLATFORMTHEME=gtk3` (tray icons, file
  dialogs) and `QT_STYLE_OVERRIDE=kvantum` (the KvGnomeDark look), like every other edition. wayfire.ini can't set
  environment variables, so a small wrapper, `kiro-wayfire-session`, exports them and starts wayfire with the same
  `~/.config/wayfire.ini`. Upstream's plain "Wayfire" entry is hidden at the login screen, and a user whose last
  session was the plain one is moved to "Kiro Wayfire" on update, so nobody lands in another session.
- **nwg-drawer dropped**: the app grid is rofi Kiro-Grid since today, so the dependency and its skel folder go
  (−41 MiB on the ISO). Existing users keep their old `~/.config/nwg-drawer/`, unused.
- **Ready for the KiroTux Wayfire ISO**: the fixes the other KiroTux editions got while becoming a product.
- **The keyboard layout follows the installer.** `xkb_layout = us,be` was fixed, so a user who picked German in
  Calamares still typed US/Belgian. At login a new script puts the installer's layout (and variant) from
  `/etc/vconsole.conf` into the user's `wayfire.ini`, the same way the niri editions do. A layout the user changed
  is left alone; the live ISO is unchanged.
- **Ctrl+Alt+H opens Kirotux Wayfire Premium** when it is installed; otherwise a notification with a **Get KiroTux**
  button that opens the KiroTux page. The key did nothing before.
- **Super+E and Super+F2 open Sublime Text** (`subl`); they started `code`, which the KiroTux ISOs don't ship.
- Qt apps get the KvGnomeDark Kvantum theme: the session runs `kiro-kvantum-default` at start.
- btop (Ctrl+Alt+End) is slightly transparent, like the terminal.
- `import-gsettings.sh` (every login) keeps a **Light** choice instead of forcing dark, and copies the cursor size
  into gsettings. Its header comment said "Hyprland session" (copied from kiro-hyprland); it says wayfire now.
- wayfire's `ipc` and `ipc-rules` plugins are on, for the premium app.
- pywal (`set-theme.sh`) leaves the window border and background colours in `wayfire.ini` alone once the premium
  app has saved a look, so its choice survives the next login.
- `keybindings.txt`: header line, Ctrl+Alt+H, editor rows.
- **New app grid.** The apps icon top-left in waybar now opens a sleek centered grid: 5 big icons with their
  names per row on a dark glass card, search on top (rofi with the new `Kiro-Grid` theme from kiro-rofi-themes).
  It replaces nwg-drawer there. Click the icon again to close it; fuzzel stays on Super+D.
- These are new installs only: existing users keep their `~/.config` copy.
- **Mouse fixed in a QEMU VM.** The pointer was drawn away from where clicks landed, so the Calamares buttons
  could not be clicked. In a VM the wayfire session now uses a software cursor (`WLR_NO_HARDWARE_CURSORS=1`,
  which the Hyprland editions already set). Real hardware is unchanged. This one reaches existing installs too.

### Technical Details
- Alt+Shift: proven on a bare-metal install by a uinput key press (Alt, Shift, N). With the toggle, only
  `variety --next` (the Alt+N command) started; with `xkb_options = compose:caps`, the `sh -c … set-theme.sh` command
  did. `keyboard-from-installer.sh` gains `layout_switch_keys`, which swaps the exact shipped line for the
  `grp:ctrls_toggle` one (idempotent, a second run changes nothing; checked). Super+Space is taken (drun), so
  `grp:win_space_toggle` was not an option. The premium app's live test ran the command string directly, so it
  never saw this; the other Kiro Wayland editions ship the same `grp:alt_shift_toggle` and are not checked yet.
- pywal 3.3's imagemagick backend needs 16 distinct colours and exits 1 when it can't find them; `set-theme.sh` runs
  under `set -e`, so it stopped before waybar, Alacritty and the borders. The package's dependency moves to
  `python-pywal16` (built from its AUR recipe into nemesis_repo). It
  `provides`/`conflicts` `python-pywal`, so an update replaces the old package. Tested on two bare-metal installs
  (RTX 2060 + HD 630, and HD 630): 0 of 20 random Variety wallpapers failed on each, open Alacritty windows recolour
  live (fastfetch output included). The `sleep 3` was checked on both: with `sleep 1` one box still got the old
  wallpaper from `variety --get`.
- `keyboard-from-installer.sh` only replaces the untouched line `xkb_layout = us,be` and adds `xkb_variant` when
  the installer set one; no stamp, so it works again after `skell`. Tested on a copy with `XKBLAYOUT="de"` +
  `XKBVARIANT="nodeadkeys"`, and a second run changes nothing.
- It runs in the same autostart entry as `set-theme.sh`, before it: both rewrite `wayfire.ini`, and two writers
  at once could lose one edit.
- Ctrl+Alt+H calls `scripts/premium.sh` instead of an inline `sh -c`, because of the quoting in a `.ini` value.
- The premium app's record file is `~/.config/wayfire/kirotux-appearance.ini`, an INI of the keys the app owns.
  `set-theme.sh` skips only those keys (e.g. `active_color`), so pywal keeps theming every colour the user didn't
  set in the app; `keyboard-from-installer.sh` stops when `xkb_layout` is listed, so a `us,be` picked in the app is
  never taken for the shipped default.
- hypridle starts with `-c ~/.config/kirotux-wayfire-premium/hypridle.conf` when the premium app saved its own
  timeouts; otherwise the shared `hypridle.conf` from kiro-wayland-dotfiles, untouched.
- **wlsunset** moves from optdepends to depends: the premium app's Night light page drives it.
- **Fisheye removed** (the `[fisheye]` section, Super+Ctrl+F in `keybindings.txt`, and the `wayfire-plugins-extra`
  optdepend). wayfire 0.11 moved fisheye out of core into `wayfire-plugins-extra`, and chaotic-aur/cachyos still
  carry its 0.10 build, which doesn't load on 0.11, so the key did nothing.
- **pywal theming never ran**: `set-theme.sh` was committed without the executable bit (mode 644 since June), so
  the `[autostart] theme` line and the Variety Alt+Shift keys could not start it, and colours stayed Tokyo Night
  (found on a QEMU install: no `~/.cache/wal`). The file is executable now (git mode 100755); new installs only.
  Once it ran, it stopped right after `wal`: it runs under `set -u` and sources pywal's `colors.sh`, which reads the
  unset `$FZF_DEFAULT_OPTS`. It now sources that file with `set +u`, and calls `wal -e` (no xrdb/GTK reload: there is
  no X display). Checked on the QEMU install: borders, waybar and mako took the wallpaper's colours.
- **Super+Q closes the window on AZERTY keyboards too.** wayfire binds keys by position (keycode), not by letter, and
  has no option to change that (Hyprland has `resolve_binds_by_sym`, niri binds by letter), so on a Belgian install
  Super+Q sat on the key labelled A. When the first layout is `be` or `fr`, `keyboard-from-installer.sh` now moves the
  shipped bindings on those letters to the AZERTY positions at login: close window (Super+Q, Super+Shift+Q), always
  on top (Super+Shift+A), the Variety selector (Alt+W) and the USB writer (Ctrl+Alt+M). Bindings that already list
  both keys (Ctrl+Alt+A/Q, Ctrl+Alt+W/Z) stay. Only untouched shipped lines change, so a second run does nothing.
  Tested on copies (be, fr, us, already-`be` home) and on the QEMU install: wayfire loaded `<super> KEY_A`.
- Not ported: `QT_QPA_PLATFORMTHEME` / `QT_STYLE_OVERRIDE`. wayfire has no environment setting in `wayfire.ini`
  and this edition uses wayfire's own session, so there is no wrapper to export them from.
- The cursor fix is `etc/profile.d/kiro-wayfire-vm-cursor.sh`: SDDM's `wayland-session` sources `/etc/profile`
  before it starts wayfire, for every login shell including fish. It exports the variable only when
  `XDG_SESSION_DESKTOP` starts with `Wayfire` and `systemd-detect-virt -q` succeeds, so other sessions are left
  alone. The X screen matched the 1280x800 output, so this was not the niri stale-X-screen click bug. Tested live
  in the QEMU virtio-gpu (virgl) VM: wayfire's environment has the variable and the Calamares buttons click.
- App grid: `app-drawer.sh` runs `rofi -show drun -theme Kiro-Grid -icon-theme Surfn` (rewritten to the Kiro
  bash template); if rofi is already open it closes it, so the waybar icon toggles. rofi 2.0 in `[extra]` is native
  Wayland (it replaced `rofi-wayland`), so no package is added. The theme is adi1090x launcher type-3 style-1
  with its colours inlined and the card at 85% opacity, so it reads without blur. `[blur] blur_by_default` now
  also matches `app_id contains "rofi"` for the frosted look (`contains` covers however wayfire names the
  layer-shell surface). Escape and the toggle's pkill end rofi with a non-zero code, so the call is `|| true`.
  Tested live in the installed Wayfire QEMU VM: the grid opens as a native Wayland window (grim screenshot),
  the second click closes it, and the script exits 0.

### Files Modified
- `etc/skel/.config/wayfire.ini`
- `etc/skel/.config/wayfire/keybindings.txt`
- `etc/skel/.config/wayfire/scripts/import-gsettings.sh`
- `etc/skel/.config/wayfire/scripts/set-theme.sh`
- `etc/skel/.config/wayfire/scripts/keyboard-from-installer.sh` (new)
- `etc/skel/.config/wayfire/scripts/premium.sh` (new)
- `etc/profile.d/kiro-wayfire-vm-cursor.sh` (new)
- `etc/skel/.config/wayfire/scripts/app-drawer.sh` (nwg-drawer → rofi Kiro-Grid)
- `etc/skel/.config/waybar/config-wayfire.jsonc` (comment)
- `CLAUDE.md`
- `KIRO-PKG-BUILD-APPS/kiro-wayfire/PKGBUILD` (wlsunset depends, plugins-extra optdepend dropped)

## 2026.10.10

### What Changed
- Source repo moved from `~/KIROTUX/kiro-wayfire` to `~/KIRO/kiro-wayfire` and its recipe to `~/KIRO-PKG-BUILD-APPS/kiro-wayfire`: ATT installs it from nemesis_repo, so it is a Kiro package, not KiroTux-only. Paths and links in the docs follow. The package itself is unchanged.

### Files Modified
- `CLAUDE.md`, `CHANGELOG.md`

## 2026.09.05

### What Changed
- **Print now leaves a file behind.** The screenshot binds ran `grim … | wl-copy`, which put the
  image on the clipboard and nowhere else — no file, no notification, so the key looked dead next to
  chadwm's scrot bind that writes into `~/Pictures`. Both binds now call the shared
  `kiro-screenshot region` / `kiro-screenshot screen`, which saves a timestamped PNG in
  `~/Pictures/Screenshots`, still copies to the clipboard, and notifies with a thumbnail.

### Technical Details
- The helper is `/usr/bin/kiro-screenshot`, shipped by `kiro-wayland-dotfiles` — already a dependency
  of this package. The same clipboard-only line had been copy-pasted into twelve editions, so it now
  lives in exactly one place instead of being fixed twelve times.
- `wayfire.ini`: `command_screenshot_region = kiro-screenshot region`; the key bindings themselves
  (`binding_screenshot_region = KEY_PRINT`) are unchanged.
- **Build `kiro-wayland-dotfiles` first**: it provides the binary this edition's binds call.

### Files Modified
- `etc/skel/.config/wayfire.ini`
- `etc/skel/.config/wayfire/keybindings.txt`

## 2026.07.07

### Keyboard: US default + Alt+Shift layout toggle

**What Changed**
- Flipped the layout order `be,us` → **`us,be`**: US QWERTY is now the default at login, Belgian AZERTY the secondary layout.
- Added **`grp:alt_shift_toggle`** to the xkb options (now `grp:alt_shift_toggle,compose:caps`) so **Alt+Shift** switches `us`↔`be`. Before, the second layout was loaded but had no switch key — unreachable.

**Technical Details**
- `grp:alt_shift_toggle` matches the CachyOS Calamares reference (`keyboard/Config.cpp` defaults the group switcher to it when a second layout exists). `compose:caps` (Caps = Compose) unchanged. `[input] xkb_layout` / `xkb_options` in `wayfire.ini`.

**Files Modified**
- `etc/skel/.config/wayfire.ini`

## 2026.07.02

### What Changed
- **Moved `/etc/dconf/profile/user` + `/etc/dconf/db/local.d/00-kiro.conf` to
  `kiro-wayland-dotfiles`.** All 9 Kiro Wayland editions had shipped identical copies of these
  files, which conflicted in pacman whenever two editions were installed on the same machine.
  Settings unchanged — now owned once in the shared package (already a dependency here).

### Files Modified
- `etc/dconf/` (removed, moved to `kiro-wayland-dotfiles`)

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
