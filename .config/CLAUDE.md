# Dotfiles Index: ~/.config

ThinkPad X1 Extreme 2nd Gen | Hyprland/Wayland | Gruvbox Dark
Migrated from i3/X11 (2020) to Hyprland/Wayland (2025)

## Dotfiles Management

Bare git repo at `~/.cfg/`, worktree at `$HOME`. 52 tracked files.
```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config status          # check status
config add <file>      # track new file
config commit -m "msg" # commit
config push            # push to remote
config ls-files        # list all tracked files
```

## Hardware

- **CPU**: Intel i7-9750H | **iGPU**: Intel UHD 630 | **dGPU**: NVIDIA GTX 1650 Mobile
- **Internal**: eDP-1 1920x1080@60Hz (Intel) | **External**: 4K@60Hz 1.5x (NVIDIA)
- **External connectors**: DP-1/DP-2 (direct USB-C) or HDMI-A-1 (via UGREEN KVM 2-in-2-out)
- Hybrid GPU: each display renders on its own GPU (zero cross-GPU lag)
- See `hypr/NVIDIA_HYBRID_FIX.md` for GPU symlinks and AQ_DRM_DEVICES setup

## Technology Stack

| Component | App | Config |
|-----------|-----|--------|
| Compositor/WM | Hyprland | `hypr/hyprland.conf` |
| Status Bar | Waybar | `waybar/{config,style.css}` |
| Terminal | Kitty | `kitty/kitty.conf` |
| Dropdown Term | Kitty (scratchpad) | Super+C / XF86Favorites |
| App Launcher | Rofi (Arc-Dark) | `rofi/config.rasi` |
| Notifications | mako | `mako/config` |
| Lock Screen | swaylock-effects | `swaylock/config`, `hypr/hyprland.conf` (bind), `hypr/hypridle.conf` (auto) |
| Idle | hypridle | `hypr/hypridle.conf` (dim 600s, screen off 800s, lock 3h, no suspend) |
| Wallpaper | swaybg | launched in hyprland.conf |
| Screenshots | grim + slurp + swappy | `swappy/config` |
| PDF Viewer | Sioyek | `sioyek/prefs_user.config` (barebone) |
| Video Player | mpv | `mpv/{mpv.conf,input.conf}` + uosc + thumbfast |
| Editor | Neovim | `nvim/init.vim` |
| IDE | PyCharm (WLToolkit/Wayland) | `JetBrains/PyCharm*/pycharm64.vmoptions` |
| VS Code | Native Wayland | `code-flags.conf` |
| Audio | WirePlumber/PipeWire | `wireplumber/wireplumber.conf.d/` |

## Theme & Appearance

- **GTK**: Arc-Dark | **Icons**: Papirus-Dark | **Colors**: Gruvbox Dark Soft
- **UI Font**: Noto Sans 10 | **Terminal Font**: Hack 10 | **Waybar/Icons**: JetBrainsMono Nerd Font
- **Terminal bg**: `#32302f` | **Waybar bg**: `#1d2021` | **Cursor**: `#add8e6`
- GTK config: `gtk-3.0/settings.ini`, `gtk-4.0/settings.ini`, `~/.gtkrc-2.0`
- Font rendering: `fontconfig/fonts.conf`, `~/.Xresources`, `/etc/fonts/local.conf`

## Active Scripts (`scripts/`)

| Script | Trigger | Purpose |
|--------|---------|---------|
| `brightness-adjust.sh` | F5/F6 | Auto-detect display, brightnessctl (internal) or ddcutil (external) |
| `ddc-bus.sh` | (helper) | Auto-detect DDC i2c bus for external monitor (DP or HDMI) |
| `monitor-toggle.sh` | Super+P | Exclusive toggle internal/external display (DP or HDMI) |
| `scratchpad-toggle.sh` | Super+K | Toggle scratchpad windows (KeePassXC, etc.) |
**Note**: Volume keys now use `wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+` directly.

## Key Keybindings (Super = Mod)

- `Mod+Return` terminal | `Mod+Q` close | `Mod+D` Rofi | `Mod+F` fullscreen
- `Mod+hjkl` / arrows: focus | `Mod+Shift+hjkl`: move windows
- `Mod+1-9,0` workspaces | `Mod+Shift+1-9,0` move to workspace
- `Mod+Escape` lock | `Mod+P` monitor toggle | `Mod+R` reload
- `Print` screenshot region | `Shift+Print` fullscreen screenshot
- `F12` Guake dropdown | `F5/F6` brightness

## Known Issues & Pitfalls

- **PyCharm image paste**: WLToolkit clipboard bug (Ctrl+Shift+V images). No fix without losing native Wayland quality
- **Monitor toggle**: Internal display may stay black (deep GPU power state). Script works but physical output may not wake
- **Super+K conflict**: Duplicate binding with `movefocus, u` (line ~226 in hyprland.conf). First match wins
- **Waybar startup**: Must start after monitor-toggle (`exec-once = sleep 3 && waybar`)
- **Nerd Font name**: Use `"JetBrainsMono Nerd Font"` not `"JetBrainsMono NF"` in CSS
- **Waybar config**: Must be named `config` not `config.jsonc`
- **XML leading whitespace**: `/etc/fonts/local.conf` must not have spaces before `<?xml`
- **JetBrains on Wayland**: Needs `_JAVA_AWT_WM_NONREPARENTING=1` env var
- **swaylock + disabled eDP-1**: Indicator ring may render offset when eDP-1 is disabled but still reported by Hyprland. Known swaylock bug with disabled outputs (swaywm/swaylock#380)
- **NVIDIA HDMI Limited Range**: NVIDIA sends Limited Range (16-235) over HDMI on Wayland. No driver-level fix available. Set monitor OSD to Limited to match, or use DisplayPort for Full Range
- **KVM suspend on switch**: KVM switch-away disconnects HDMI, logind sees lid closed + AC power + no display → suspends immediately. Fixed: `HandleLidSwitchExternalPower=ignore` in `/etc/systemd/logind.conf`
- **No suspend on AC**: USB/xHCI controller fails to resume from S3 deep sleep (PCI error -19), killing the KVM connection. Suspend removed from hypridle — DPMS off handles power saving on AC

## Conventions

- **Dotfiles**: bare git repo, `config` alias, track individual files (not dirs)
- **Keybindings**: Vim-style (hjkl), Super as mod key
- **Color scheme**: Gruvbox Dark Soft everywhere (terminal, waybar, GTK)
- **Wayland-native**: Prefer Wayland apps over XWayland (Kitty > st, code-flags.conf)
- **Audio**: WirePlumber priority config for stable defaults, wpctl for runtime control

## Documentation

- `CLAUDE.md` - This index (you are here)
- `hypr/NVIDIA_HYBRID_FIX.md` - GPU hybrid setup, udev symlinks, troubleshooting
- `docs/brightness-auto-detection.md` - DDC bus auto-detection for external monitor brightness
- `docs/nuphy-air75-v3-linux.md` - NuPhy Air75 V3 keyboard setup on Linux
- `IDEAVIM_GUIDE.md` - IdeaVim keybindings reference

## Quick Troubleshooting

**Waybar icons missing**: `fc-cache -fv` then restart waybar
**Font rendering wrong**: Check `fontconfig/fonts.conf` + `~/.Xresources` + `fc-cache -fv`
**App not floating**: Find class with `hyprctl clients`, add windowrule in hyprland.conf
**Volume not working**: Verify `wpctl status`, check default sink with `wpctl inspect @DEFAULT_AUDIO_SINK@`
**Brightness not working**: Internal: `brightnessctl -l` | External: `ddcutil detect`
**Display lag**: See `hypr/NVIDIA_HYBRID_FIX.md` - likely cross-GPU frame copying
