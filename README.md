# kiro-wayfire

The **wayfire desktop edition** of Kiro — the 3D-effects member of the Kiro Wayland line (sibling to [kiro-hyprland](https://github.com/kirodubes/kiro-hyprland)).

## What it is

A configuration package: the source-of-truth config tree for Kiro's wayfire edition. wayfire is a
wlroots-based 3D Wayland compositor (cube, expo, wobbly, wrot, zoom) with a plugin system at its
core. Because it is wlroots, it rides the same shell stack as kiro-hyprland — **waybar + mako +
swaybg** — so the look and feel match the Hyprland edition; only the compositor file and the
keybind vocabulary differ. The signature 3D effects are core wayfire plugins, so they cost no
extra packages.

## What it ships

- `etc/skel/.config/wayfire.ini` — the wayfire config: `[core]` plugin list, `[autostart]`
  session, `[command]` app launchers (SUPER grammar + CTRL+ALT + SUPER+F1..F12), tiling
  (`simple-tile`), workspaces (`vswitch`), and the 3D effects.
- `etc/skel/.config/waybar/` — the bar (`config.jsonc`, `style.css`, pywal-driven `colors.css`).
- `etc/skel/.config/mako/config` — notifications.
- `etc/skel/.config/wayfire/` — Kiro assets: the wallpaper, `keybindings.txt`, and the
  `scripts/` (pywal `set-theme.sh`, `import-gsettings.sh`).
- `etc/skel/.config/hypr/` — `hyprlock.conf` + `hypridle.conf` for the Wayland lock pipeline.

## Theming — pywal

One wallpaper drives every colour. At login `set-theme.sh` runs pywal on the wallpaper and fans
the palette out to waybar, mako, and the wayfire window borders, then live-reloads each. Re-theme
any time with `~/.config/wayfire/scripts/set-theme.sh /path/to/wallpaper.jpg`.

## How to install

```sh
sudo pacman -S kiro-wayfire
```

`kiro-wayfire` depends on `wayfire` + the waybar shell stack + `python-pywal` (all from Arch
`extra`). On a fresh login wayfire starts the bar and wallpaper. Press **Super + Ctrl + S** for the
searchable keybindings cheat sheet. **Tap Super** for the workspace overview (expo); the 3D **cube**
is a showcase — hold **Ctrl + Alt** and drag.

A pristine copy of the config is kept at `/usr/share/kiro/kiro-wayfire/` so it can be restored.
