# 🚀 Hyprland Dotfiles

> A modern, keyboard-driven Wayland desktop environment for developers who love vim keybindings

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-0.53.3-blue)](https://hyprland.org/)
[![Wayland](https://img.shields.io/badge/Wayland-FCC624?style=flat&logo=wayland&logoColor=black)](https://wayland.freedesktop.org/)

## 📖 Table of Contents
- [✨ Features](#-features)
- [🖼️ Screenshots](#️-screenshots)
- [🎨 What's Inside](#-whats-inside)
- [💻 Hardware](#-hardware)
- [🔧 Installation](#-installation)
- [⚙️ Configuration](#️-configuration)
- [⌨️ Keybindings](#️-keybindings)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [📚 Documentation](#-documentation)
- [📜 Changelog](#-changelog)

## ✨ Features

### 🎮 Hybrid GPU Zero-Lag Setup
Optimized for laptops with Intel + NVIDIA GPUs. Eliminates input lag on external displays through smart GPU routing.
- 📺 Internal display → Intel iGPU (direct rendering)
- 🖥️ External display → NVIDIA dGPU (direct rendering)
- ⚡ No cross-GPU frame copying = zero lag
- 📄 Full docs: [NVIDIA_HYBRID_FIX.md](hypr/NVIDIA_HYBRID_FIX.md)

### 🎯 Smart Display Management
- 🔆 Auto brightness detection (internal vs external)
- 🎚️ F5/F6 for brightness control (5% steps)
- 🖥️ Super+P to toggle monitors
- 💡 Waybar brightness widget with scroll support

### ⌨️ Vim Everywhere
- 🎯 hjkl navigation throughout the system
- 🪟 Window management with vim bindings
- 📝 Consistent keybindings across all apps
- 🚀 Super (Windows) key as modifier

### 🎨 Beautiful & Fast
- 🌈 Gruvbox color scheme
- 🎭 Arc-Dark GTK theme
- ⚡ Buttery smooth animations
- 🖼️ Transparent terminal (0.8 opacity)

## 🖼️ Screenshots

![Desktop](./screen.png)

- 🔒 Lock screen with blur effect
- 📊 Waybar status bar with custom modules
- 🖥️ Kitty terminal with Gruvbox theme

## 🎨 What's Inside

### 🪟 Core Desktop

| Component | What I Use | Why |
|-----------|-----------|-----|
| 🗔 **Compositor** | Hyprland 0.53.3 | Modern tiling Wayland compositor |
| 📊 **Bar** | Waybar | Highly customizable status bar |
| 💻 **Terminal** | Kitty | Fast, GPU-accelerated, Wayland-native |
| 📥 **Dropdown** | Kitty (Super+C / F12) | Centered floating scratchpad terminal |
| 🔍 **Launcher** | Rofi | Quick app launcher |
| 🔔 **Notifications** | mako | Lightweight notification daemon |
| 🔒 **Lock** | hyprlock | Beautiful lock screen with blur |
| 📸 **Screenshots** | grim + slurp + swappy | Screenshot, select, edit, done! |

### 🛠️ Development Stack

- 📝 **Editors**: Neovim + VS Code (Wayland-native)
- 🐍 **IDE**: PyCharm (via XWayland)
- 🐚 **Shell**: ZSH with custom completions
- 📦 **Dotfiles**: Bare git repo (no symlinks!)

### 🔊 Audio & Media

- 🎵 **Audio**: PipeWire + WirePlumber (auto device switching)
- 🎧 **USB-C headphones**: Plug & play, auto-routes on connect/disconnect
- 🔊 **Volume**: Media keys with 100% cap

### 🎨 Theme & Appearance

- 🎨 **GTK**: Arc-Dark
- 🎭 **Icons**: Papirus-Dark
- 🔤 **UI Font**: Noto Sans 10
- 💻 **Terminal Font**: JetBrainsMono Nerd Font
- 🌈 **Colors**: Gruvbox Dark Soft
  - Terminal: `#32302f`
  - Waybar: `#1d2021`

## 💻 Hardware

**Device**: ThinkPad X1 Extreme 2nd Gen (20QV0007US)

| Component | Spec |
|-----------|------|
| 🧠 **CPU** | Intel i7-9750H (6c/12t) @ 4.5GHz |
| 🎮 **iGPU** | Intel UHD 630 |
| 🖥️ **dGPU** | NVIDIA GTX 1650 Mobile |
| 📱 **Internal** | 1920×1080 @ 60Hz (eDP-1) |
| 🖥️ **External** | ASUS PA279CV 27" 4K @ 60Hz (DP-2, 1.5× scale) |

## 🔧 Installation

### 📦 Prerequisites

```bash
# Core desktop
sudo pacman -S hyprland waybar kitty rofi mako swaybg grim slurp swappy

# Audio (PipeWire + WirePlumber for auto device switching)
sudo pacman -S pipewire pipewire-pulse wireplumber

# Fonts & themes
sudo pacman -S ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
sudo pacman -S arc-gtk-theme papirus-icon-theme

# Hybrid GPU support
sudo pacman -S nvidia-open-lts brightnessctl ddcutil

# Development tools
sudo pacman -S neovim zsh fzf ripgrep
```

### 📥 Clone Dotfiles

```bash
# Clone as bare repo
git clone --bare https://github.com/funnydman/my-dot-files.git $HOME/.cfg

# Setup alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Checkout configs
config checkout master

# Hide untracked files
config config --local status.showUntrackedFiles no
```

### 🚀 Post-Install

```bash
# NVIDIA setup
sudo systemctl enable --now nvidia-persistenced
sudo udevadm control --reload-rules && sudo udevadm trigger

# Fonts
fc-cache -fv

# Launch Hyprland
Hyprland
```

## ⚙️ Configuration

### 📁 Key Config Files

<details>
<summary><b>🗔 Hyprland Configs</b></summary>

- `~/.config/hypr/hyprland.conf` (460 lines) - Main configuration
- `~/.config/hypr/hypridle.conf` - Idle management
- `~/.config/hypr/hyprlock.conf` - Lock screen config
- `~/.config/hypr/hyprpaper.conf` - Wallpaper settings
- `~/.config/hypr/NVIDIA_HYBRID_FIX.md` - GPU docs
</details>

<details>
<summary><b>📊 Status Bar</b></summary>

- `~/.config/waybar/config` (120 lines) - Modules & layout
- `~/.config/waybar/style.css` (285 lines) - Gruvbox styling
</details>

<details>
<summary><b>💻 Terminal</b></summary>

- `~/.config/kitty/kitty.conf` (105 lines) - Kitty config (also used as dropdown terminal)
</details>

<details>
<summary><b>🎨 Theme</b></summary>

- `~/.config/gtk-3.0/settings.ini` - GTK3 theme
- `~/.config/gtk-4.0/settings.ini` - GTK4 theme
- `~/.gtkrc-2.0` - GTK2 legacy
- `~/.config/fontconfig/fonts.conf` - Font rendering
- `~/.Xresources` - Xft settings
</details>

<details>
<summary><b>📝 Development</b></summary>

- `~/.config/nvim/init.vim` (209 lines) - Neovim config
- `~/.ideavimrc` - Vim bindings for PyCharm
- `~/.config/code-flags.conf` - VS Code Wayland flags
- `~/.zshrc` (184 lines) - Shell config
</details>

### 🔧 Custom Scripts

**📊 Smart Brightness** (`~/.config/scripts/brightness-adjust.sh`)
- Auto-detects which display is active
- Internal: `brightnessctl` for laptop screen
- External: `ddcutil` for monitor (DDC/CI)

**🖥️ Monitor Toggle** (`~/.config/scripts/monitor-toggle.sh`)
- Switch between internal/external displays
- Bound to Super+P
- Auto-runs on startup

**🔊 Volume Control** (`~/.config/scripts/volume.sh`)
- Volume control with 100% limit
- Used by media keys

## ⌨️ Keybindings

> **Note**: `Mod` = Super (Windows key)

### 🪟 Window Management

| Keys | Action |
|------|--------|
| `Mod + Return` | 💻 Launch terminal |
| `Mod + Q` | ❌ Close window |
| `Mod + F` | ⛶ Toggle fullscreen |
| `Mod + Shift + Space` | 🎈 Toggle floating |
| `Mod + hjkl` / `Arrows` | 🧭 Focus windows |
| `Mod + Shift + hjkl` / `Arrows` | 🚚 Move windows |

### 📑 Workspaces

| Keys | Action |
|------|--------|
| `Mod + 1-9, 0` | 🔢 Switch workspace 1-10 |
| `Mod + Shift + 1-9, 0` | 📦 Move window to workspace |
| `Mod + Tab` | ⏮️ Previous workspace |

### 🚀 Applications

| Keys | Action |
|------|--------|
| `Mod + D` | 🔍 Launch Rofi |
| `Mod + C` / `F12` | 📥 Toggle kitty dropdown |
| `Mod + Escape` | 🔒 Lock screen |

### 🖥️ System Controls

| Keys | Action |
|------|--------|
| `Mod + P` | 🖥️ Toggle monitor |
| `F5` / `F6` | 🔆 Brightness down/up |
| `Print` | 📸 Screenshot region |
| `Shift + Print` | 📸 Screenshot fullscreen |
| `XF86Audio*` | 🔊 Volume/media controls |

### 🎯 Advanced Modes

| Keys | Mode |
|------|------|
| `Mod + R` | 📏 **Resize mode** (hjkl/arrows to resize) |
| `Mod + X` | 🚪 **Exit mode** (L=logout, R=reboot, S=shutdown) |
| `Mod + Shift + G` | 📐 **Gap mode** (O=outer, I=inner) |

📖 Full keybindings: `~/.config/hypr/hyprland.conf` (lines 209-393)

## 🛠️ Troubleshooting

### 🐌 Input lag on external monitor?

**Symptoms**: 0.1-0.3s delay when typing/moving mouse

**Fix**: Apply the GPU configuration from `NVIDIA_HYBRID_FIX.md`
- Creates stable GPU device symlinks
- Routes each display to its physically-connected GPU
- Eliminates cross-GPU frame copying

### 🔤 Fonts look weird?

```bash
# Rebuild font cache
fc-cache -fv

# Verify Nerd Fonts are installed
pango-list | grep -i nerd

# Check config
cat ~/.config/fontconfig/fonts.conf
```

### ❌ Waybar icons not showing?

```bash
# Install fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols

# Restart waybar
killall waybar && waybar &
```

### 🔆 Brightness keys don't work?

**Internal display**: Check `brightnessctl -l`

**External display**: Verify DDC/CI support
```bash
ddcutil detect
```

### 🔄 SDDM login loop?

Check GPU configuration in `~/.config/hypr/hyprland.conf`:
- Verify `AQ_DRM_DEVICES` setting
- See troubleshooting in `NVIDIA_HYBRID_FIX.md`

### 🔍 Debug Logs

```bash
# Hyprland logs
cat ~/.hyprland.log

# Check which GPU is rendering
cat /proc/$(pgrep -x Hyprland)/maps | grep -E "nvidia|i915"

# Waybar debug
killall waybar && waybar
```

## 📚 Documentation

### 📖 Detailed Guides

- **🎮 [NVIDIA_HYBRID_FIX.md](hypr/NVIDIA_HYBRID_FIX.md)** - Complete hybrid GPU setup guide
  - Root cause analysis of input lag
  - Step-by-step fix with udev rules
  - Verification commands

- **📝 [CLAUDE.md](CLAUDE.md)** - Migration reference & troubleshooting
  - Font configuration tricks
  - Theme setup steps
  - Terminal configuration
  - Common issues & solutions

- **⌨️ [IDEAVIM_GUIDE.md](IDEAVIM_GUIDE.md)** - IdeaVim configuration & plugins
  - Available plugins (20+ options)
  - Recommended additions (which-key, NERDTree, exchange)
  - Modern best practices (2025-2026)
  - Action mappings for refactoring & testing

### 🔧 Quick Reference

**Managing dotfiles**:
```bash
# Add new config
config add ~/.config/newapp/config.conf
config commit -m "Add newapp config"
config push

# Check status
config status

# List tracked files
config ls-files
```

**Config locations**:
- 🗔 Hyprland: `~/.config/hypr/`
- 📊 Waybar: `~/.config/waybar/`
- 🔧 Scripts: `~/.config/scripts/`
- 📄 Docs: `~/.config/*.md`

## 📜 Changelog

### Version History

| Version | Date | Changes |
|---------|------|---------|
| **v2.1** | 2026-02 | 🔧 **Polish & Modernization** |
| | | - Replaced Guake with Kitty dropdown (Super+C, centered float) |
| | | - Per-app scratchpads (Telegram, KeePass) |
| | | - PipeWire + WirePlumber (auto USB-C audio switching) |
| | | - Fixed font rendering with croscore metric-compatible fonts |
| | | - Focus follows mouse |
| **v2.0** | 2025-02 | 🎉 **Hyprland/Wayland Migration** |
| | | - Switched from i3 to Hyprland |
| | | - X11 → Wayland (native) |
| | | - polybar → Waybar |
| | | - st → Kitty (Wayland-native) |
| | | - i3lock-fancy → hyprlock |
| | | - dunst → mako |
| | | - Fixed NVIDIA hybrid GPU input lag |
| | | - Preserved vim keybindings & workflow |
| **v1.0** | 2020 | 🚀 Initial i3/X11 setup |

### 🔄 Key Preserved Features

Despite the major migration, these features remained unchanged:
- ⌨️ Vim-style hjkl navigation
- 🔢 Workspace numbers (1-10)
- 📥 Dropdown terminal (now Kitty instead of Guake)
- 📐 Negative gaps (i3-style: 4px inner, -4px outer)
- 🎨 Arc-Dark + Gruvbox theme combination

### 🆕 New in v2.0

- ⚡ Zero-lag external display support
- 🎮 Hybrid GPU optimization
- 🔆 Smart brightness control
- 🖥️ Monitor toggle (Super+P)
- 📸 Modern screenshot workflow (grim + slurp + swappy)
- 🎭 Native Wayland app support

## 🙏 Credits

- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - Highly customizable status bar
- [Gruvbox](https://github.com/morhetz/gruvbox) - Retro groove color scheme
- [Arc Theme](https://github.com/horst3180/arc-theme) - Flat GTK theme
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) - Icon fonts for developers

## 📄 License

Personal dotfiles - use freely, modify as needed! 🎉
