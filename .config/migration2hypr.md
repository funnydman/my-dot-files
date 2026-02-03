# Migration Plan: i3/X11 to Hyprland/Wayland

## Overview
Migrate from i3+polybar+picom (X11) to Hyprland+waybar (Wayland) while preserving all keybindings, window rules, and visual preferences.

**Estimated effort:** 3-4 hours
**Risk:** Low (i3 remains installed as fallback)

---

## Phase 1: Install Packages

```bash
sudo pacman -S hyprland xdg-desktop-portal-hyprland waybar hyprpaper \
    hyprlock hypridle mako grim slurp wl-clipboard cliphist \
    foot brightnessctl qt5-wayland qt6-wayland xorg-xwayland wofi
```

---

## Phase 2: Create Config Files

### Directory structure
```
~/.config/hypr/
├── hyprland.conf    # Main config (keybindings, rules, appearance)
├── hyprpaper.conf   # Wallpaper
├── hypridle.conf    # Idle management (dim/lock/suspend)
└── hyprlock.conf    # Lock screen appearance

~/.config/waybar/
├── config           # Modules (workspaces, battery, network, etc.)
└── style.css        # Nord-ish theme matching polybar

~/.config/wofi/
├── config           # Launcher settings
└── style.css        # Solarized dark theme

~/.config/mako/
└── config           # Notifications (matching dunst)
```

---

## Phase 3: Key Configurations

### 3.1 hyprland.conf

**Monitors:**
```bash
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = DP-1, 3840x2160@60, 1920x0, 1.5  # 4K with 1.5x scale
```

**Keybindings to port:**
| i3 | Hyprland |
|----|----------|
| `bindsym $mod+h focus left` | `bind = $mod, H, movefocus, l` |
| `bindsym $mod+Shift+h move left` | `bind = $mod SHIFT, H, movewindow, l` |
| `bindsym $mod+1 workspace 1` | `bind = $mod, 1, workspace, 1` |
| `bindsym $mod+f fullscreen` | `bind = $mod, F, fullscreen` |
| `bindsym $mod+Shift+space floating toggle` | `bind = $mod SHIFT, Space, togglefloating` |
| `bindsym $mod+r mode "resize"` | `bind = $mod, R, submap, resize` |

**Window rules:**
```bash
windowrulev2 = workspace 1, class:^(firefox)$
windowrulev2 = workspace 2, class:^(jetbrains-pycharm)$
windowrulev2 = float, title:^(Telegram)$
windowrulev2 = float, class:^(MPlayer)$
windowrulev2 = pin, class:^(MPlayer)$  # sticky
```

**Appearance:**
```bash
general {
    gaps_in = 4
    gaps_out = -4
    border_size = 2
    col.active_border = rgb(556064)
    col.inactive_border = rgb(2F3D44)
}
```

**Startup:**
```bash
exec-once = waybar
exec-once = hyprpaper
exec-once = hypridle
exec-once = mako
exec-once = dropbox
exec-once = udiskie &
```

### 3.2 waybar config

**Modules:** workspaces, window, language, network speed, wifi, backlight, pulseaudio, tray, battery

**Theme:** Nord colors (#292d3e bg, #c0c5ce fg), UbuntuMono Nerd Font, 20px height

### 3.3 hypridle.conf

```bash
listener {
    timeout = 600
    on-timeout = brightnessctl -s set 10%
    on-resume = brightnessctl -r
}
listener {
    timeout = 700
    on-timeout = loginctl lock-session
}
listener {
    timeout = 3600
    on-timeout = systemctl suspend
}
```

### 3.4 hyprlock.conf

- Blurred wallpaper background
- Centered password input with Nord colors
- Time display with UbuntuMono font

---

## Phase 4: Implementation Order

| Step | Task | Test |
|------|------|------|
| 1 | Install packages | `pacman -Qs hyprland` |
| 2 | Create `~/.config/hypr/` | Directory exists |
| 3 | Minimal hyprland.conf | Login, Mod+Return works |
| 4 | Add monitor config | `hyprctl monitors` correct |
| 5 | Add all keybindings | hjkl, workspaces, modes |
| 6 | Add window rules | Firefox→ws1 works |
| 7 | Create waybar config | Bar shows modules |
| 8 | Create hyprpaper.conf | Wallpaper displays |
| 9 | Create hypridle/hyprlock | Mod+Escape locks |
| 10 | Create mako config | `notify-send` works |
| 11 | Create wofi config | Mod+D launches |
| 12 | Add startup apps | guake, dropbox start |

---

## Phase 5: Component Mapping

| i3/X11 | Hyprland/Wayland | Notes |
|--------|------------------|-------|
| i3 config | hyprland.conf | Similar syntax |
| polybar | waybar | JSON, full rewrite |
| picom | Built-in | Use `decoration {}` |
| rofi | wofi | Or rofi-wayland |
| dunst | mako | Or keep dunst |
| feh | hyprpaper | Simple |
| i3lock-fancy | hyprlock | Better integration |
| xidlehook | hypridle | Same timeouts |
| flameshot | grim+slurp | `grim -g "$(slurp)"` |
| st | foot | Native Wayland |

---

## Phase 6: Scripts to Keep/Modify

**Keep as-is (work on Wayland):**
- `~/.config/scripts/volume.sh` - uses pactl
- `~/.config/polybar/ipfinder.sh` - uses curl/jq
- `~/.config/rofi/config.rasi` - if using rofi-wayland

**Replace:**
- `~/.config/scripts/xidlelock.sh` → hypridle config
- `~/.config/scripts/run_rofi.sh` → wofi or update for rofi-wayland

**Not needed:**
- picom config (compositor built into Hyprland)
- snixembed (waybar has native tray)

---

## Phase 7: Rollback Strategy

1. **Keep i3 installed** - both show in login screen
2. **Backup first:**
   ```bash
   cp -r ~/.config/i3 ~/.config/i3.backup
   cp -r ~/.config/polybar ~/.config/polybar.backup
   ```
3. **Quick escape:** Ctrl+Alt+F2 → login → reboot → select i3

---

## Known Issues

| Issue | Solution |
|-------|----------|
| Screen sharing | Add `exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP` |
| JetBrains IDEs | Add `env = _JAVA_AWT_WM_NONREPARENTING,1` |
| Guake | Use foot with scratchpad instead |
| Clipboard history | Use cliphist: `bind = $mod SHIFT, V, exec, cliphist list \| wofi --dmenu \| cliphist decode \| wl-copy` |
| Electron apps | Add `--ozone-platform=wayland` flag |

---

## Verification Checklist

After migration:
- [ ] 4K monitor scales correctly (text readable)
- [ ] All keybindings work (hjkl, workspaces, resize mode, exit mode)
- [ ] Waybar shows: workspaces, window title, keyboard, network, battery, tray
- [ ] Lock screen works (Mod+Escape)
- [ ] Idle dim/lock/suspend works
- [ ] Screenshots work (Print key)
- [ ] Firefox launches to workspace 1
- [ ] PyCharm launches to workspace 2
- [ ] Notifications appear
- [ ] Volume/brightness keys work
- [ ] Wallpaper displays on both monitors

---

## Reference Files

| Source (read) | Target (create) |
|---------------|-----------------|
| `~/.config/i3/config` | `~/.config/hypr/hyprland.conf` |
| `~/.config/polybar/config.ini` | `~/.config/waybar/config` + `style.css` |
| `~/.config/scripts/xidlelock.sh` | `~/.config/hypr/hypridle.conf` |
| `~/.config/dunst/dunstrc` | `~/.config/mako/config` |
| `~/.config/wallpapers/wall.jpg` | Referenced in `hyprpaper.conf` |