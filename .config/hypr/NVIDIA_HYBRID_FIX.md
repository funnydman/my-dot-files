# Hyprland NVIDIA Hybrid GPU Input Lag Fix

## System Configuration
- **Laptop**: ThinkPad X1 Extreme 2nd Gen
- **CPU**: Intel i7-9750H
- **iGPU**: Intel UHD Graphics 630 (card1)
- **dGPU**: NVIDIA GeForce GTX 1650 Mobile (card0)
- **External Monitor**: ASUS PA279CV 27" 4K (3840x2160) @ 60Hz, 1.5x scale
- **Compositor**: Hyprland 0.53.3
- **Driver**: nvidia-open-lts 590.48.01

## The Problem

### Symptoms
- Noticeable input lag when typing (0.1-0.3s delay)
- Mouse movement felt "smooth but delayed"
- Lag was worse on external 4K monitor than laptop display

### Root Cause
Hyprland was rendering frames on the **Intel iGPU** (i915) while the external monitor was connected through **NVIDIA dGPU**.

This caused every frame to be:
1. Rendered on Intel GPU
2. Copied across PCIe bus to NVIDIA GPU
3. Displayed on external monitor

This cross-GPU frame copy introduced significant latency.

### How We Discovered It
```bash
cat /proc/$(pgrep -x Hyprland)/maps | grep -E "nvidia|i915"
```

**Before fix** showed:
```
anon_inode:i915.gem   # Intel GPU buffers - BAD
```

**After fix** showed:
```
/dev/nvidiactl        # NVIDIA GPU buffers - GOOD
```

## The Solution

### 1. Create Stable GPU Symlinks via udev Rules

**Problem**: `/dev/dri/cardN` numbers are dynamic and change between boots, causing login issues.

**Solution**: Create `/etc/udev/rules.d/99-gpu-symlinks.rules`:
```
# NVIDIA GeForce GTX 1650 Mobile (discrete GPU)
KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SYMLINK+="dri/nvidia-dgpu"

# Intel UHD Graphics 630 (integrated GPU)
KERNEL=="card*", KERNELS=="0000:00:02.0", SUBSYSTEM=="drm", SYMLINK+="dri/intel-igpu"
```

Apply rules:
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Verify:
```bash
ls -la /dev/dri/ | grep -E "nvidia-dgpu|intel-igpu"
# Should show: nvidia-dgpu -> card1, intel-igpu -> card2
```

### 2. Configure Hyprland to Use Stable Symlinks

In `~/.config/hypr/hyprland.conf`:
```conf
# Use stable GPU symlinks - each display uses its physically-wired GPU
# External (DP-2) → NVIDIA, Internal (eDP-1) → Intel (no cross-GPU copying)
env = AQ_DRM_DEVICES,/dev/dri/nvidia-dgpu:/dev/dri/intel-igpu
```

This configuration:
- Uses NVIDIA for external display (DP-2) - direct rendering
- Uses Intel for internal display (eDP-1) - direct rendering
- **Zero cross-GPU copying** because each display uses its own physically-wired GPU
- Stable across reboots (no more dynamic card numbers)

### 3. Additional NVIDIA Optimizations
```conf
# NVIDIA environment variables
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1

# NVIDIA latency reduction
env = __GL_MaxFramesAllowed,1
env = __GL_VRR_ALLOWED,0

# Multi-GPU latency fix
env = AQ_MGPU_NO_EXPLICIT,1
```

### 4. System-Level Fixes Applied
```bash
# Removed broken/conflicting packages
sudo pacman -R optimus-manager-git
sudo pacman -R xf86-video-nouveau

# Enabled NVIDIA persistence daemon
sudo systemctl enable --now nvidia-persistenced
```

### 5. Required Kernel Module Configuration
In `/etc/modprobe.d/nvidia.conf`:
```
options nvidia_drm modeset=1
options nvidia_drm fbdev=1
```

In `/etc/mkinitcpio.conf`:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Rebuild initramfs:
```bash
sudo mkinitcpio -P
```

## Important Notes

### GPU Mapping with Stable Symlinks
**Dynamic card numbers** (change on every boot):
- card1 = NVIDIA (vendor 0x10de, PCI 0000:01:00.0)
- card2 = Intel (vendor 0x8086, PCI 0000:00:02.0)

**Stable symlinks** (via udev rules):
- `/dev/dri/nvidia-dgpu` → always points to NVIDIA card
- `/dev/dri/intel-igpu` → always points to Intel card

Verify symlinks:
```bash
ls -la /dev/dri/ | grep -E "nvidia-dgpu|intel-igpu"
```

Verify PCI addresses:
```bash
for card in /dev/dri/card*; do
  echo -n "$card: "
  cat /sys/class/drm/$(basename $card)/device/vendor
done
```

### Using One Display at a Time (Recommended)
With the stable symlinks configuration, you can use one display at a time for zero lag:

**Internal display only**:
- Hyprland automatically uses Intel GPU (eDP-1 is wired to Intel)
- Direct rendering, zero lag

**External display only**:
- Hyprland automatically uses NVIDIA GPU (DP-2 is wired to NVIDIA)
- Direct rendering, zero lag

**Both displays simultaneously**:
- Also works with zero cross-GPU copying!
- Each display uses its own physically-wired GPU
- Internal (eDP-1) → Intel, External (DP-2) → NVIDIA

### BIOS Alternative
For permanent NVIDIA-only mode without software configuration:
1. Enter BIOS/UEFI (F1 on ThinkPads)
2. Find Graphics settings
3. Change from "Hybrid" to "Discrete Graphics"
4. This disables Intel GPU at hardware level

## Verification Commands

### Check which GPU Hyprland uses:
```bash
cat /proc/$(pgrep -x Hyprland)/maps | grep -E "nvidia|i915" | head -3
```

**Expected output**:
- When using **external monitor** (DP-2): Should show `nvidia` devices (e.g., `/dev/nvidiactl`, `/dev/nvidia0`)
- When using **internal monitor** (eDP-1): Should show `i915.gem` devices (Intel GPU)
- This confirms each display is using its physically-wired GPU without cross-GPU copying

### Check nvidia_drm is loaded:
```bash
lsmod | grep nvidia_drm
```

### Check NVIDIA persistence:
```bash
systemctl status nvidia-persistenced
```

### Monitor GPU usage:
```bash
nvidia-smi
# or
nvtop
```

## Multiple External Monitors

### Port Mapping (ThinkPad X1 Extreme 2nd Gen)
```
card0-DP-1      → NVIDIA
card0-DP-2      → NVIDIA
card0-HDMI-A-1  → NVIDIA
card1-eDP-1     → Intel (internal display only)
```

### Two External Monitors = No Lag
If using **two external monitors** (both on NVIDIA), there's **zero cross-GPU copying**:

```conf
# Dual external monitor setup (no lag)
monitor = eDP-1, disable
monitor = DP-1, 3840x2160@60, 0x0, 1.5
monitor = DP-2, 3840x2160@60, 2560x0, 1.5
env = AQ_DRM_DEVICES,/dev/dri/card0
```

### Why Internal + External Has Lag
```
Internal (eDP) → Intel GPU ─┐
                            ├─ Cross-GPU copy = LAG
External (DP)  → NVIDIA GPU ┘
```

### Why Dual External Has No Lag
```
External 1 (DP-1) → NVIDIA GPU ─┐
                                ├─ Same GPU = NO LAG
External 2 (DP-2) → NVIDIA GPU ─┘
```

### MacBooks Comparison
- **Intel MacBooks (2015-2020)**: Similar hybrid GPU issues, but macOS handled switching better
- **Apple Silicon (M1/M2/M3/M4)**: No issue - unified memory, single GPU

## Date Fixed
2026-02-03 (initial fix)
2026-02-05 (final solution with stable symlinks)

## Summary
**TL;DR**: On hybrid Intel+NVIDIA laptops, Hyprland defaults to Intel GPU for rendering. When using an external monitor connected through NVIDIA, this causes input lag due to cross-GPU frame copying.

**Final solution**:
1. Create stable GPU symlinks via udev rules (solves dynamic card number issues)
2. Configure `AQ_DRM_DEVICES=/dev/dri/nvidia-dgpu:/dev/dri/intel-igpu` in Hyprland
3. Each display automatically uses its physically-wired GPU (no cross-GPU copying)
4. Works reliably across reboots and with any display configuration