# Mac Setup Guide

**Machine**: MacBook Pro M4 Pro, macOS Sequoia (work laptop — App Store restricted)
**Monitor**: ASUS PA279CV 27" (2560x1440 @ 60Hz)
**KVM**: Ugreen HDMI KVM switch
**Audio**: EarPods (USB), Insta360 Link 2 webcam
**Mouse**: Dell Universal Receiver (USB via KVM)

---

## Table of Contents

1. [Display: Fix Washed-Out External Monitor](#1-display-fix-washed-out-external-monitor)
2. [Display: Disable Internal Display](#2-display-disable-internal-display)
3. [Sleep: Prevent Sleep on Lid Close (KVM)](#3-sleep-prevent-sleep-on-lid-close-kvm)
4. [Audio: Route to EarPods](#4-audio-route-to-earpods)
5. [Mouse: Increase Cursor Speed](#5-mouse-increase-cursor-speed)
6. [Automation: Auto-Switch Script](#6-automation-auto-switch-script)
7. [Tools Installed](#7-tools-installed)
8. [Quick Reference](#8-quick-reference)

---

## 1. Display: Fix Washed-Out External Monitor

### Problem
External monitor looks washed out / whitish / milky when connected via HDMI through KVM.

### Root Cause
HDMI through KVM causes macOS to negotiate wrong color settings:
- **YCbCr 4:4:4** instead of RGB (wrong pixel encoding)
- **Limited Range (16-235)** instead of Full Range 0-255 (crushed contrast)
- **HDR enabled** (EOTF=2 PQ tone mapping on SDR workflow)

### Why Standard Fixes Don't Work (Apple Silicon + Sequoia)
- PlistBuddy edits to `com.apple.windowserver.displays.plist` — overwritten by WindowServer at runtime
- EDID overrides in `/Library/Displays/Contents/Resources/Overrides/` — ignored on Apple Silicon + Sequoia
- `displayplacer` — controls resolution/position only, not pixel encoding or color range
- ColorSync/ICC profiles — change color interpretation, not transmission mode

### Fix
```bash
# Step 1: Disable HDR
# System Settings > Displays > ASUS PA279CV > HDR → OFF

# Step 2: Install tools
brew install displayplacer
brew install --cask betterdisplay

# Step 3: Force RGB Full Range
betterdisplaycli set -productNameLike="PA279" -connectionMode="range:full+encoding:rgb"

# Step 4: Verify
betterdisplaycli get -productNameLike="PA279" -connectionMode
# Should show: RGB Full SRGB
```

### Available Connection Modes (ASUS PA279CV via HDMI/KVM)
| Mode | Encoding | Range | Depth |
|------|----------|-------|-------|
| **RGB Full (best)** | RGB | Full | 8-bit |
| RGB Limited | RGB | Limited | 8-bit |
| YCbCr 4:4:4 Limited | YCbCr | Limited | 8-bit |
| YCbCr 4:2:0 Limited | YCbCr | Limited | 10-bit |
| YCbCr 4:2:0 Limited | YCbCr | Limited | 8-bit |

10-bit only available in YCbCr 4:2:0 — not worth the subsampling tradeoff.

---

## 2. Display: Disable Internal Display

### Problem
Want to use only the external ASUS monitor when docked via KVM — no dual display.

### Fix
```bash
displayplacer "id:FCFF9FC6-9B5E-4359-BB56-D6BD243D9144 res:2560x1440 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 enabled:false"
```

### Display IDs
| Display | Persistent ID |
|---------|--------------|
| Internal MacBook | `37D8832A-2D66-02CA-B9F7-8F30A301B230` |
| ASUS PA279CV | `FCFF9FC6-9B5E-4359-BB56-D6BD243D9144` |

---

## 3. Sleep: Prevent Sleep on Lid Close (KVM)

### Problem
MacBook sleeps when lid is closed or KVM switches away. When KVM switches back, Mac is asleep and unresponsive — must open lid to wake.

### Root Cause
macOS enters sleep when lid closes or no external display detected. KVM switching away removes the display signal.

### Root Cause (detailed)
macOS has 3 layers of sleep that all need to be disabled:
- **Sleep** — triggered by lid close or idle timer
- **Standby** — deep sleep after ~3hrs, writes RAM to disk, powers down (kills Docker)
- **Hibernate** — writes RAM to disk for power loss protection (slows wake)
- **Auto Power Off** — another deep sleep trigger after extended idle

### Fix
```bash
# One-time apply (or re-run if settings reset):
sudo ~/bin/pmset-fix.sh

# What it sets (AC power only):
sudo pmset -c disablesleep 1      # Prevent lid-close sleep
sudo pmset -c sleep 0             # No sleep timer
sudo pmset -c disksleep 0         # Disk stays active
sudo pmset -c standby 0           # No deep sleep (kills Docker)
sudo pmset -c hibernatemode 0     # No hibernation (faster wake)
sudo pmset -c autopoweroff 0      # No auto power off
sudo pmset -c powernap 0          # No random wake cycles
sudo pmset -c tcpkeepalive 1      # Keep network alive
sudo pmset -c womp 1              # Wake on network access
```

### Boot-time persistence (LaunchDaemon)
Settings can reset after OS updates or Energy Saver changes. A LaunchDaemon re-applies on every boot:
```bash
# One-time setup (creates /Library/LaunchDaemons/com.user.pmset-fix.plist):
sudo ~/bin/setup-pmset-daemon.sh
```

### Verify
```bash
pmset -g | grep -E "SleepDisabled|sleep|standby|hibernate|powernap|disksleep"
# Expected: SleepDisabled=1, sleep=0, standby=0, hibernatemode=0, powernap=0, disksleep=0
```

### Safety Notes
- All settings use `-c` (AC power only) — battery behavior stays default
- M4 Pro has fans — no thermal risk with lid closed (unlike fanless MacBook Air)
- Display still turns off after 60min idle (`displaysleep 60`)
- Apple menu > Sleep won't work while on AC — unplug charger first
- Docker Desktop 4.36+ has a known bug where it doesn't survive sleep/wake — these settings avoid that entirely

### Scripts
- `~/bin/pmset-fix.sh` — applies all pmset settings (run with sudo)
- `~/bin/setup-pmset-daemon.sh` — creates LaunchDaemon for boot persistence (run once with sudo)

### Why Not Amphetamine?
Work laptop restrictions prevent App Store installs. `pmset` achieves the same result — it's what Amphetamine does under the hood.

---

## 4. Audio: Route to EarPods

### Problem
Audio goes to built-in MacBook speakers (lid closed = no sound). EarPods connected via USB but not selected as default. Teams follows system default.

### Fix
```bash
# Switch output to EarPods
SwitchAudioSource -s "EarPods" -t output

# Switch input to EarPods microphone
SwitchAudioSource -s "EarPods Microphone" -t input

# Verify
SwitchAudioSource -c -t output  # Should show: EarPods
SwitchAudioSource -c -t input   # Should show: EarPods Microphone
```

### Available Audio Devices
| Device | Type | Transport |
|--------|------|-----------|
| EarPods | Output + Mic | USB |
| ASUS PA279CV | Output | HDMI |
| Insta360 Link 2 | Input (webcam) | USB |
| MacBook Pro Speakers | Output | Built-in |
| MacBook Pro Microphone | Input | Built-in |
| Microsoft Teams Audio | Virtual I/O | Virtual |

### Useful Commands
```bash
# List all output/input devices
SwitchAudioSource -a -t output
SwitchAudioSource -a -t input

# Check current output/input
SwitchAudioSource -c -t output
SwitchAudioSource -c -t input
```

---

## 5. Mouse: Increase Cursor Speed

### Problem
Default mouse speed too slow. System Settings max is 3.0, not fast enough.

### Approach 1: LinearMouse (recommended — applies immediately)
```bash
brew install --cask linearmouse
```
- Open LinearMouse from menu bar
- **Cursor** tab → increase **Speed** to desired level
- Check **"Disable cursor acceleration"** for consistent 1:1 movement
- Changes apply immediately, no restart needed

### Approach 2: Terminal (requires restart)
```bash
# Set speed (GUI max is 3.0, can go higher)
defaults write -g com.apple.mouse.scaling 10.0

# Requires logout or restart to take effect
# Verify
defaults read -g com.apple.mouse.scaling
```

### Speed vs Acceleration
- **Speed** (scaling) = flat multiplier — how far cursor moves per unit of mouse movement. Consistent and predictable.
- **Acceleration** = non-linear — slow hand movement = small cursor move, fast hand movement = disproportionately large move.
- **Recommendation**: High speed + no acceleration for predictable muscle memory.

---

## 6. Automation: Auto-Switch Script

### Script: `~/bin/display-switch.sh`
Triggers when display config changes (KVM switched to this Mac):
1. Checks if ASUS PA279CV is connected
2. Disables internal MacBook display
3. Forces RGB Full Range if macOS reverted to YCbCr

### LaunchAgent: `~/Library/LaunchAgents/com.user.display-switch.plist`
- Watches `/Library/Preferences/com.apple.windowserver.displays.plist` for changes
- macOS updates this file whenever a display connects/disconnects
- Throttled to 5s to prevent rapid-fire triggers
- Logs to `~/.local/log/display-switch.log`

### LaunchAgent Management
```bash
# Load (enable)
launchctl load ~/Library/LaunchAgents/com.user.display-switch.plist

# Unload (disable)
launchctl unload ~/Library/LaunchAgents/com.user.display-switch.plist

# Check status
launchctl list | grep display-switch

# View logs
cat ~/.local/log/display-switch.log

# Manual trigger
~/bin/display-switch.sh
```

---

## 7. Tools Installed

| Tool | Install | Purpose |
|------|---------|---------|
| `displayplacer` | `brew install displayplacer` | Display arrangement, enable/disable displays |
| `BetterDisplay` | `brew install --cask betterdisplay` | Force RGB color mode (must be running) |
| `SwitchAudioSource` | `brew install switchaudio-osx` | Switch audio devices from CLI |
| `LinearMouse` | `brew install --cask linearmouse` | Mouse speed & acceleration control (immediate) |
| `mas` | `brew install mas` | Mac App Store CLI (installed but blocked by work policy) |

---

## 8. Quick Reference

### After fresh boot / KVM reconnect:
```bash
# 1. Force RGB Full Range
betterdisplaycli set -productNameLike="PA279" -connectionMode="range:full+encoding:rgb"

# 2. Disable internal display
displayplacer "id:FCFF9FC6-9B5E-4359-BB56-D6BD243D9144 res:2560x1440 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 enabled:false"

# 3. Switch audio to EarPods
SwitchAudioSource -s "EarPods" -t output
SwitchAudioSource -s "EarPods Microphone" -t input
```

### Reinstall all tools from scratch:
```bash
brew install displayplacer
brew install switchaudio-osx
brew install mas
brew install --cask betterdisplay
brew install --cask linearmouse
```

---

## Notes
- BetterDisplay must be running for `betterdisplaycli` to work
- BetterDisplay Pro ($) enables `protectSDRColorMode=on` to auto-prevent macOS from reverting color mode
- If color mode reverts after sleep: LaunchAgent should catch it, or manually run `~/bin/display-switch.sh`
- KVM only has HDMI — DisplayPort would avoid the RGB issue entirely but isn't available on this KVM
- App Store installs blocked by work laptop policy
