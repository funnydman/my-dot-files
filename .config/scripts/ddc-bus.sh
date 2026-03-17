#!/bin/bash
# Auto-detect the DDC bus for the active external monitor.
# Caches result in /tmp/ddc-bus for fast repeated lookups.
# Cache is invalidated when the connected DP connector changes.

CACHE="/tmp/ddc-bus"

# Which DP connector is currently connected?
active_dp=""
for dp in /sys/class/drm/card*-DP-*; do
    if [ "$(cat "$dp/status" 2>/dev/null)" = "connected" ]; then
        active_dp=$(basename "$dp")
        break
    fi
done

# No external DP connected
if [ -z "$active_dp" ]; then
    rm -f "$CACHE"
    exit 1
fi

# Check cache: valid if same connector
if [ -f "$CACHE" ]; then
    cached_dp=$(sed -n '1p' "$CACHE")
    cached_bus=$(sed -n '2p' "$CACHE")
    if [ "$cached_dp" = "$active_dp" ] && [ -n "$cached_bus" ]; then
        echo "$cached_bus"
        exit 0
    fi
fi

# Detect bus via ddcutil (skip "Invalid display" entries, only use valid "Display N")
bus=$(ddcutil detect --brief 2>/dev/null | awk '/^Display [0-9]/{found=1} found && /I2C bus:/{match($0, /i2c-([0-9]+)/, m); print m[1]; exit}')
if [ -n "$bus" ]; then
    printf '%s\n%s\n' "$active_dp" "$bus" > "$CACHE"
    echo "$bus"
    exit 0
fi

rm -f "$CACHE"
exit 1
