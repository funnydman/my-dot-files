# Hyprland Migration Notes

## Font Configuration

### Problem
Firefox and other apps had different/wrong fonts after migrating to Hyprland.

### Solution
- GTK font was set to `Noto Sans Mono` (monospace) instead of proportional font
- Fixed by changing to `Noto Sans 10` in:
  - `~/.config/gtk-3.0/settings.ini`
  - `~/.config/gtk-4.0/settings.ini`
  - `~/.gtkrc-2.0`

### Nerd Font Icons
- Install `ttf-jetbrains-mono-nerd` for waybar icons
- Install `ttf-nerd-fonts-symbols` for symbol fallback
- Font name for CSS: `"JetBrainsMono Nerd Font"` (not "JetBrainsMono NF")
- Verify with: `pango-list | grep -i nerd`

## Dark Theme Setup

### GTK Apps (Firefox, Nemo, etc.)
```bash
# gsettings
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### GTK Config Files
- `gtk-theme-name=Arc-Dark`
- `gtk-icon-theme-name=Papirus-Dark`
- `gtk-application-prefer-dark-theme=1`

### Hyprland Environment Variables
Add to `~/.config/hypr/hyprland.conf`:
```
env = GTK_THEME,Arc-Dark
env = QT_QPA_PLATFORMTHEME,gtk2
```

### XDG Portal
Install `xdg-desktop-portal-gtk` for dark theme detection in apps.

## Rofi Dark Theme
Add to `~/.config/rofi/config.rasi`:
```
@theme "Arc-Dark"
```

## Hyprland Animation Speed
Faster animations in `~/.config/hypr/hyprland.conf`:
```
animations {
    animation = windows, 1, 0.8, easeOutQuint
    animation = windowsOut, 1, 0.5, linear, popin 80%
    animation = fade, 1, 0.8, quick
    animation = workspaces, 1, 0.5, quick, fade
}
```

## Waybar Configuration

### Config Location
- Waybar reads `~/.config/waybar/config` (not `config.jsonc`)
- If both exist, rename: `mv config.jsonc config`

### Working Module Formats (icon first, then value)
```json
"cpu": {
    "format": "󰍛 {usage}%"
},
"memory": {
    "format": "󰘚 {percentage}%"
},
"battery": {
    "format": "{icon} {capacity}%",
    "format-full": "󰂅 100%",
    "format-charging": "󰂄 {capacity}%"
},
"network": {
    "format-wifi": "󰇚 {bandwidthDownBits} 󰕒 {bandwidthUpBits}"
},
"pulseaudio": {
    "format": "{icon} {volume}%"
},
"backlight": {
    "format": "{icon} {percent}%"
}
```

### Style (Gruvbox Theme)
Key colors in `~/.config/waybar/style.css`:
- Background: `#1d2021` (Gruvbox hard dark - darker than guake)
- Foreground: `#ebdbb2`
- Active workspace: `#fabd2f`
- CPU: `#fabd2f`
- Memory: `#076678`
- Battery: `#b8bb26`
- Network: `#8ec07c`
- Volume: `#fb4934`
- Backlight: `#d3869b`

### Module Order (right side)
```json
"modules-right": [
    "tray",
    "backlight",
    "bluetooth",
    "pulseaudio",
    "network",
    "memory",
    "cpu",
    "battery"
]
```

## Firefox Font Rendering

### Problem
Firefox fonts look different/odd on Wayland after migrating from X11.

### Solution
Three-part fix:

#### 1. Xft Settings in ~/.Xresources
```
Xft.autohint: 0
Xft.antialias: 1
Xft.hinting: 1
Xft.hintstyle: hintslight
Xft.rgba: rgb
Xft.lcdfilter: lcddefault
Xft.dpi: 96
```
Apply with: `xrdb -merge ~/.Xresources`

#### 2. Fontconfig ~/.config/fontconfig/fonts.conf
Created with:
- Antialiasing enabled
- Hinting: hintslight
- Subpixel: rgb
- LCD filter: lcddefault
- Font substitutions (Arial → Noto Sans, etc.)
- Preferred font families for sans/serif/mono

Rebuild cache: `fc-cache -fv`

#### 3. Firefox about:config (optional tweaks)
- `gfx.font_rendering.fontconfig.max_generic_substitutions` = 127
- `layout.css.dpi` = 0 (use system DPI)
- `gfx.webrender.all` = true (better rendering on Wayland)

### Restart Required
After changes, restart Firefox completely (not just refresh).

## Troubleshooting

### Icons Not Showing in Waybar
1. Check font is installed: `fc-list | grep -i "JetBrains.*Nerd"`
2. Check pango sees it: `pango-list | grep -i nerd`
3. Refresh font cache: `fc-cache -f`
4. Use correct font name in style.css: `font-family: "JetBrainsMono Nerd Font";`

### Waybar Not Picking Up Config Changes
- Check which config file waybar uses (logs show path)
- Ensure file is named `config` not `config.jsonc`
- Restart waybar: `killall waybar && waybar &`

## Terminal Emulator (Kitty)

### Why Kitty
- **st** (suckless terminal) runs via XWayland, causing window artifacts on layout changes
- **Alacritty** and **foot** were tried but have slightly different color rendering than st
- **Kitty** provides best balance of features and Wayland-native support

### Configuration (~/.config/kitty/kitty.conf)
Key settings migrated from st:
```
# Terminal type
term xterm-256color

# Font (Hack, same as st)
font_family      Hack
font_size        10.0

# Cursor (block, no blink)
cursor_shape block
cursor_blink_interval 0

# Window
window_padding_width 2
hide_window_decorations yes
background_opacity 0.8
confirm_os_window_close 0

# Gruvbox Dark Soft theme
foreground #fbf1c7
background #32302f
```

### Keybindings (st-style vim bindings)
```
# Copy/Paste
map alt+c copy_to_clipboard
map alt+v paste_from_clipboard

# Scrolling (vim-style)
map alt+k scroll_line_up
map alt+j scroll_line_down
map alt+u scroll_page_up
map alt+d scroll_page_down

# Font size
map alt+shift+k change_font_size all +1.0
map alt+shift+j change_font_size all -1.0
map alt+shift+0 change_font_size all 0
```

### Color Note
Wayland terminals render colors differently than X11/st due to different rendering pipelines. Gruvbox Dark Soft (`#32302f` background) provides closest match to st appearance.

## Fontconfig System Configuration

### System-wide (/etc/fonts/local.conf)
Optimized font rendering with:
- Antialiasing: enabled
- Hinting: hintmedium (bolder than hintslight)
- Subpixel rendering: rgb
- LCD filter: lcddefault
- Noto fonts as primary fallback

### User fontconfig (~/.config/fontconfig/fonts.conf)
Font substitutions:
- Arial → Noto Sans
- Helvetica → Noto Sans
- Times New Roman → Noto Serif
- Courier New → JetBrains Mono

Preferred font families:
- Sans-serif: Noto Sans, DejaVu Sans
- Serif: Noto Serif, DejaVu Serif
- Monospace: JetBrains Mono, Hack, DejaVu Sans Mono

Rebuild cache after changes: `fc-cache -fv`

## Window Rules (Hyprland)

### Floating Windows
Apps that open in floating mode:
```
windowrule = float on, match:class ^(org.telegram.desktop)$
windowrule = float on, match:class ^(org.keepassxc.KeePassXC)$
windowrule = float on, match:class ^(zoom)$
windowrule = float on, match:class ^(pavucontrol)$
windowrule = float on, match:class ^(nm-connection-editor)$
windowrule = float on, match:class ^(blueman-manager)$
windowrule = float on, match:class ^(gnome-calculator)$
```

### Finding Window Class Names
Use `hyprctl clients` to find the correct class name for window rules.

### Smart Gaps
No gaps when only one window:
```
workspace = w[tv1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
windowrule = border_size 0, match:float false, match:workspace w[tv1]
windowrule = border_size 0, match:float false, match:workspace f[1]
```

## Screenshots (Flameshot)

### Keybindings in hyprland.conf
```
bind = , Print, exec, flameshot gui
bind = SHIFT, Print, exec, flameshot full -c -p ~/Pictures/
```

### Features
- `Print`: Opens interactive GUI for region selection and annotation
- `Shift+Print`: Captures full screen, copies to clipboard, saves to ~/Pictures/

## Config File Locations

| Component | Config Path |
|-----------|-------------|
| Hyprland | ~/.config/hypr/hyprland.conf |
| Kitty | ~/.config/kitty/kitty.conf |
| Alacritty | ~/.config/alacritty/alacritty.toml |
| Foot | ~/.config/foot/foot.ini |
| Waybar | ~/.config/waybar/config |
| Waybar style | ~/.config/waybar/style.css |
| Rofi | ~/.config/rofi/config.rasi |
| GTK3 | ~/.config/gtk-3.0/settings.ini |
| GTK4 | ~/.config/gtk-4.0/settings.ini |
| GTK2 | ~/.gtkrc-2.0 |
| Fontconfig | ~/.config/fontconfig/fonts.conf |
| Xresources | ~/.Xresources |
| System fonts | /etc/fonts/local.conf |

## Troubleshooting

### Terminal Colors Look Different from st
This is expected - Wayland terminals use different rendering than X11/XWayland. Use Gruvbox Dark Soft theme for closest match.

### st Window Artifacts on Layout Changes
st runs via XWayland and has rendering glitches when Hyprland layout changes. Use kitty (Wayland-native) instead.

### App Not Floating When It Should
1. Check class name: `hyprctl clients`
2. Verify windowrule syntax: `match:class ^(exact-class-name)$`
3. Some apps use different class names than expected (e.g., Telegram is `org.telegram.desktop`)

## Dropdown Terminal (Guake)

### Setup
Guake handles F12 keybinding internally - no Hyprland bind needed.

In `hyprland.conf`:
```
exec-once = guake

# Window rule to position below waybar (25px)
windowrule = float on, match:class ^(guake|Guake)$
windowrule = move 0 25, match:class ^(guake|Guake)$
```

### Why Guake over Kitty Dropdown
- Guake handles F12 internally (works reliably)
- Native dropdown behavior with animations
- Same setup as i3 config

## VS Code Wayland

### Native Wayland Support
Create `~/.config/code-flags.conf`:
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
```

### Check if Running Native
```bash
hyprctl clients | grep -A5 "code"
# xwayland: 0 = native Wayland
# xwayland: 1 = XWayland
```

## PyCharm / JetBrains IDEs

### Environment Variable (in hyprland.conf)
```
env = _JAVA_AWT_WM_NONREPARENTING,1
```

### VM Options (~/.config/JetBrains/PyCharm*/pycharm64.vmoptions)
```
-Dawt.useSystemAAFontSettings=lcd
```

JetBrains IDEs run via XWayland (no native Wayland support yet).
