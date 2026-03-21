# Brightness Auto-Detection

External monitor brightness controls auto-detect the DDC bus and connector (DP or HDMI),
so switching USB-C ports or using a KVM switch doesn't require config changes.

## Problem

The ASUS PA279CV connects via USB-C (direct, maps to DP-1/DP-2) or HDMI
(via UGREEN KVM 2-in-2-out switch, maps to HDMI-A-1). Different ports map to
different connectors and i2c buses. Previously, all configs hardcoded
`DP-2` and `--bus 9`, breaking brightness when using a different port or KVM.

## Solution

### `scripts/ddc-bus.sh`

Central helper that auto-detects the DDC i2c bus for the active external monitor.

- Checks `/sys/class/drm/card*-{DP,HDMI-A}-*/status` to find the connected external connector
- Runs `ddcutil detect --brief` to find the bus number for valid (non-laptop) displays
- Caches result in `/tmp/ddc-bus` keyed by connector name (e.g. `card1-DP-1`)
- Cache invalidates automatically when the connector changes (different USB-C port)
- Cold lookup: ~600ms | Cached: ~6ms

### `scripts/brightness-adjust.sh`

Handles F5/F6 keypresses. Detects external monitor as "any active monitor that isn't eDP-1"
rather than checking for a specific DP name. Uses `ddc-bus.sh` for the bus number.

### `scripts/monitor-toggle.sh`

Handles Super+P toggle. Reads connected DP or HDMI connector from sysfs instead of hardcoding.
Invalidates `/tmp/ddc-bus` cache on toggle.

### `waybar/config` — `custom/brightness-external`

- `exec-if`: checks for any non-eDP active monitor (not a specific DP name)
- `exec`, `on-scroll-up`, `on-scroll-down`: all call `ddc-bus.sh` to get the bus dynamically

## File dependencies

```
F5/F6 keys (hyprland.conf)
  └─> scripts/brightness-adjust.sh
        └─> scripts/ddc-bus.sh  ──> /tmp/ddc-bus (cache)

waybar brightness widget
  └─> scripts/ddc-bus.sh  ──> /tmp/ddc-bus (cache)

Super+P (hyprland.conf)
  └─> scripts/monitor-toggle.sh
        └─> invalidates /tmp/ddc-bus
```

## Relevant hardware

- **Laptop panel**: eDP-1 (Intel UHD 630) — uses `brightnessctl`, no DDC
- **External**: ASUS PA279CV (NVIDIA GTX 1650) — uses `ddcutil` over DDC/CI
  - Via USB-C direct: maps to DP-1 or DP-2
  - Via HDMI (UGREEN KVM): maps to HDMI-A-1
- NVIDIA adapter i2c buses: 6-10 (bus number depends on connection type and port)
