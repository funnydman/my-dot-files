# Hyprland Dotfiles - Wayland Setup

> Vim-driven Hyprland configuration for ThinkPad X1 Extreme 2nd Gen
> Migrated from i3/X11 to Hyprland/Wayland in 2025

## Table of Contents
- [Overview](#overview)
- [Screenshots](#screenshots)
- [Hardware](#hardware)
- [Technology Stack](#technology-stack)
- [Features](#features)
- [Installation](#installation)
- [Configuration Files](#configuration-files)
- [Custom Scripts](#custom-scripts)
- [Keybindings](#keybindings)
- [Troubleshooting](#troubleshooting)
- [Migration Notes](#migration-notes)
- [Documentation](#documentation)

## Overview

A complete Wayland desktop environment setup featuring:
- **Window Manager**: Hyprland (tiling compositor)
- **Status Bar**: Waybar with Gruvbox theme
- **Terminal**: Kitty + Guake (F12 dropdown)
- **GPU Setup**: Hybrid Intel + NVIDIA with zero-lag external display
- **Theme**: Arc-Dark + Gruvbox colorscheme
- **Icons**: Papirus-Dark + JetBrainsMono Nerd Font

## Screenshots

![Screenshot reference](./screen.png)

- Lock screen: hyprlock with blur effect
- Status bar: Waybar with Gruvbox theme
- Terminal: Kitty with 0.8 opacity, Gruvbox Dark Soft

## Hardware

**Device**: ThinkPad X1 Extreme 2nd Gen (20QV0007US)
- **CPU**: Intel Core i7-9750H (6 cores, 12 threads) @ 4.5GHz
- **iGPU**: Intel UHD Graphics 630 (internal display)
- **dGPU**: NVIDIA GeForce GTX 1650 Mobile (external displays)
- **Internal Display**: 1920x1080 @ 60Hz (eDP-1)
- **External Display**: ASUS PA279CV 27" 4K @ 60Hz (DP-2, 1.5x scaling)

## Technology Stack

### Core Desktop
| Component | Application | Config Location |
|-----------|-------------|-----------------|
| Compositor/WM | Hyprland 0.53.3 | `~/.config/hypr/hyprland.conf` |
| Status Bar | Waybar | `~/.config/waybar/{config,style.css}` |
| Terminal | Kitty | `~/.config/kitty/kitty.conf` |
| Dropdown Terminal | Guake | Auto-configured |
| App Launcher | Rofi (Arc-Dark) | `~/.config/rofi/config.rasi` |
| Notifications | mako | `~/.config/mako/config` |
| Lock Screen | hyprlock | `~/.config/hypr/hyprlock.conf` |
| Idle Manager | hypridle | `~/.config/hypr/hypridle.conf` |
| Wallpaper | swaybg | Launched in hyprland.conf |
| Screenshots | grim + slurp + swappy | `~/.config/swappy/config` |

### Development Tools
- **Editor**: Neovim + VS Code (Wayland-native)
- **IDEs**: JetBrains (PyCharm) via XWayland
- **Shell**: ZSH with custom completion
- **Git**: Bare repo dotfiles management

### Theme & Appearance
- **GTK Theme**: Arc-Dark
- **Icon Theme**: Papirus-Dark
- **Font**: Noto Sans 10 (UI), JetBrainsMono Nerd Font (terminal/waybar)
- **Color Scheme**: Gruvbox Dark Soft (#32302f terminal bg, #1d2021 waybar bg)

## Features

### Hybrid GPU Configuration (Zero-Lag External Display)
- **Problem Solved**: Eliminated 0.1-0.3s input lag caused by cross-GPU frame copying
- **Solution**: Stable udev GPU symlinks + proper AQ_DRM_DEVICES configuration
- Internal display → Intel iGPU (direct rendering)
- External display → NVIDIA dGPU (direct rendering)
- **Documentation**: See `~/.config/hypr/NVIDIA_HYBRID_FIX.md`

### Smart Brightness Control
- Automatic detection of active display (internal vs external)
- F5/F6: Adjust brightness (5% steps)
- Internal: `brightnessctl`
- External: `ddcutil` with DDC/CI protocol
- Waybar indicator with mouse scroll support

### Monitor Management
- **Super+P**: Toggle between internal-only and external-only modes
- Automatic GPU switching per display
- No cross-GPU rendering overhead

### Vim-Style Keybindings
- All navigation with `hjkl` or arrow keys
- Mod key: Super (Windows key)
- Workspace switching: Mod+1-9, Mod+0
- Window management: Mod+hjkl, Mod+Shift+hjkl

## Installation

### Prerequisites
```bash
# Core packages
sudo pacman -S hyprland waybar kitty rofi mako swaybg grim slurp swappy
sudo pacman -S ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
sudo pacman -S arc-gtk-theme papirus-icon-theme

# Hybrid GPU (NVIDIA + Intel)
sudo pacman -S nvidia-open-lts brightnessctl ddcutil

# Development
sudo pacman -S neovim zsh fzf ripgrep
```

### Clone Dotfiles
```bash
# Clone bare repo
git clone --bare <your-repo-url> $HOME/.cfg

# Define config alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Checkout files
config checkout master

# Hide untracked files
config config --local status.showUntrackedFiles no
```

### Post-Install
```bash
# Enable NVIDIA persistence
sudo systemctl enable --now nvidia-persistenced

# Apply udev rules for stable GPU symlinks
sudo udevadm control --reload-rules
sudo udevadm trigger

# Rebuild font cache
fc-cache -fv

# Start Hyprland
Hyprland
```

## Configuration Files

### Core Configurations

**Hyprland**:
- `~/.config/hypr/hyprland.conf` (460 lines) - Main config
- `~/.config/hypr/hypridle.conf` - Idle management (dim 600s → lock 700s → suspend 3600s)
- `~/.config/hypr/hyprlock.conf` - Lock screen with blur
- `~/.config/hypr/hyprpaper.conf` - Wallpaper config
- `~/.config/hypr/NVIDIA_HYBRID_FIX.md` (256 lines) - GPU documentation

**Waybar**:
- `~/.config/waybar/config` (120 lines) - Module configuration
- `~/.config/waybar/style.css` (285 lines) - Gruvbox theme styling

**Terminal**:
- `~/.config/kitty/kitty.conf` (105 lines) - Kitty terminal
- Guake: F12 dropdown (auto-configured)

**Theme**:
- `~/.config/gtk-3.0/settings.ini` - GTK3 Arc-Dark
- `~/.config/gtk-4.0/settings.ini` - GTK4 Arc-Dark
- `~/.gtkrc-2.0` - GTK2 legacy
- `~/.config/fontconfig/fonts.conf` (157 lines) - Font rendering
- `~/.Xresources` - Xft settings

**Shell**:
- `~/.zshrc` (184 lines) - ZSH configuration
- `~/.bashrc` (188 lines) - Bash fallback
- `~/.config/aliasrc` - Aliases

**Development**:
- `~/.config/nvim/init.vim` (209 lines) - Neovim
- `~/.ideavimrc` - IdeaVim for JetBrains
- `~/.config/code-flags.conf` - VS Code Wayland flags

**Screenshots**:
- `~/.config/swappy/config` - Swappy editor settings
- `~/.config/mako/config` - Notification daemon

See complete file list: `config ls-files`

## Custom Scripts

### Active Scripts (Hyprland-integrated)

**Brightness Control** (`~/.config/scripts/brightness-adjust.sh`):
- Auto-detects internal vs external display
- Internal: brightnessctl for laptop screen
- External: ddcutil for monitor via DDC/CI
- Usage: F5/F6 keys (5% steps)

**Monitor Toggle** (`~/.config/scripts/monitor-toggle.sh`):
- Exclusive switching between internal/external displays
- Triggered by Super+P keybinding
- Auto-runs on startup to disable internal if external connected

**Volume Control** (`~/.config/scripts/volume.sh`):
- PulseAudio volume adjustment with 100% cap
- Used by XF86Audio keybindings

### Legacy Scripts (i3 era, archived)
- `switcher.py` - Window switcher for messaging apps
- `next_available.py` - Find next workspace
- `center_windows_jetbrains.sh` - Center PyCharm dialogs
- See `~/.config/scripts/` and `~/.config/i3/scripts/`

## Keybindings

### Essential Bindings

**Window Management**:
- `Mod+Return` - Open Kitty terminal
- `Mod+Q` - Close window
- `Mod+F` - Toggle fullscreen
- `Mod+Shift+Space` - Toggle floating
- `Mod+hjkl` / `Mod+Arrows` - Focus windows
- `Mod+Shift+hjkl` / `Mod+Shift+Arrows` - Move windows

**Workspaces**:
- `Mod+1-9, Mod+0` - Switch to workspace 1-10
- `Mod+Shift+1-9, Mod+Shift+0` - Move window to workspace
- `Mod+Tab` - Previous workspace

**Applications**:
- `Mod+D` - Launch Rofi
- `F12` - Toggle Guake dropdown terminal
- `Mod+Escape` - Lock screen (hyprlock)

**System**:
- `Mod+R` - Enter resize mode
- `Mod+P` - Toggle monitor (internal ↔ external)
- `F5/F6` - Brightness down/up
- `Print` - Screenshot region (swappy)
- `Shift+Print` - Screenshot fullscreen

**Audio**:
- `XF86AudioRaiseVolume` - Volume up
- `XF86AudioLowerVolume` - Volume down
- `XF86AudioMute` - Toggle mute

**Submaps**:
- `Mod+X` - Exit mode (L=logout, R=reboot, S=shutdown)
- `Mod+R` - Resize mode (hjkl/arrows to resize)
- `Mod+Shift+G` - Gap adjustment mode (O=outer, I=inner)

See complete bindings: `~/.config/hypr/hyprland.conf` (lines 209-393)

## Troubleshooting

### Common Issues

**Input lag on external monitor**:
- Symptom: 0.1-0.3s typing/mouse delay
- Cause: Cross-GPU frame copying (Intel → NVIDIA)
- Solution: Apply NVIDIA_HYBRID_FIX.md configuration

**Fonts look wrong**:
- Rebuild font cache: `fc-cache -fv`
- Check fontconfig: `~/.config/fontconfig/fonts.conf`
- Verify Nerd Fonts: `pango-list | grep -i nerd`

**Waybar icons not showing**:
- Install: `ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols`
- Verify font name: `"JetBrainsMono Nerd Font"` (not "NF")
- Restart waybar: `killall waybar && waybar &`

**Brightness keys not working**:
- Check scripts: `~/.config/scripts/brightness-adjust.sh`
- For external: Verify DDC/CI support with `ddcutil detect`
- For internal: Check brightnessctl: `brightnessctl -l`

**SDDM login loop**:
- Likely cause: Incorrect AQ_DRM_DEVICES or GPU configuration
- Check: `~/.config/hypr/hyprland.conf` GPU environment variables
- See: NVIDIA_HYBRID_FIX.md troubleshooting section

### Logs & Debug
```bash
# Hyprland logs
cat ~/.hyprland.log

# Waybar output
killall waybar && waybar &

# Check GPU active rendering
cat /proc/$(pgrep -x Hyprland)/maps | grep -E "nvidia|i915"
```

## Migration Notes

### From i3/X11 (2020) → Hyprland/Wayland (2025)

**Key Changes**:
- Replaced picom compositor (built-in to Hyprland)
- polybar → Waybar (native Wayland)
- st → Kitty (native Wayland, no XWayland artifacts)
- i3lock-fancy → hyprlock (Wayland-native)
- dunst → mako (Wayland notifications)

**Compatibility**:
- Firefox: Native Wayland (MOZ_ENABLE_WAYLAND=1)
- VS Code: Native Wayland (code-flags.conf)
- JetBrains IDEs: XWayland (requires _JAVA_AWT_WM_NONREPARENTING=1)
- Electron apps: Auto-detect (ELECTRON_OZONE_PLATFORM_HINT=auto)

**Preserved from i3**:
- Vim-style keybindings (hjkl navigation)
- Workspace numbers (1-10)
- Guake F12 dropdown terminal
- Negative gaps (i3-style: 4px inner, -4px outer)

See complete migration details:
- `~/.config/CLAUDE.md` - Step-by-step migration notes
- `~/.config/migration2hypr.md` - Original migration plan
- `~/.config/migration_summary.md` - Summary of changes

## Documentation

### Comprehensive Guides

**GPU Configuration**:
- `~/.config/hypr/NVIDIA_HYBRID_FIX.md` - Complete NVIDIA hybrid GPU setup
  - Root cause analysis of input lag
  - Stable udev symlinks solution
  - Verification commands
  - Troubleshooting steps

**Migration Notes**:
- `~/.config/CLAUDE.md` - Detailed migration guide covering:
  - Font configuration (GTK, fontconfig, Xft)
  - Dark theme setup (GTK, Waybar, Rofi)
  - Nerd Font icons installation
  - Terminal migration (st → Kitty)
  - Waybar module configuration
  - Firefox font rendering
  - Window rules
  - Screenshot tools
  - Dotfiles management

- `~/.config/migration2hypr.md` - Original migration plan
- `~/.config/migration_summary.md` - Migration summary

### Quick References

**Add new config to dotfiles**:
```bash
config add ~/.config/newapp/config.conf
config commit -m "Add newapp config"
config push
```

**Check tracked files**:
```bash
config ls-files
```

**View dotfiles status**:
```bash
config status
```

**Common directories**:
- Hyprland configs: `~/.config/hypr/`
- Waybar: `~/.config/waybar/`
- Scripts: `~/.config/scripts/`
- Documentation: `~/.config/*.md`

## Credits

- Hyprland compositor: https://hyprland.org/
- Waybar: https://github.com/Alexays/Waybar
- Gruvbox theme: https://github.com/morhetz/gruvbox
- Arc-Dark GTK theme: https://github.com/horst3180/arc-theme
- JetBrainsMono Nerd Font: https://github.com/ryanoasis/nerd-fonts

## License

Personal dotfiles configuration. Use at your own discretion.
