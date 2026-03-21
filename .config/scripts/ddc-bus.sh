#!/bin/bash
# Auto-detect the DDC bus for the active external monitor.
# Caches result in /tmp/ddc-bus for fast repeated lookups.
# Cache is invalidated when the connected connector changes.
# Supports both DP and HDMI connections (direct or via KVM).

CACHE="/tmp/ddc-bus"

# Which external connector is currently connected? (DP or HDMI, not eDP)
active_conn=""
for conn in /sys/class/drm/card*-{DP,HDMI-A}-*; do
    if [ "$(cat "$conn/status" 2>/dev/null)" = "connected" ]; then
        active_conn=$(basename "$conn")
        break
    fi
done

# No external monitor connected
if [ -z "$active_conn" ]; then
    rm -f "$CACHE"
    exit 1
fi

# Check cache: valid if same connector
if [ -f "$CACHE" ]; then
    cached_conn=$(sed -n '1p' "$CACHE")
    cached_bus=$(sed -n '2p' "$CACHE")
    if [ "$cached_conn" = "$active_conn" ] && [ -n "$cached_bus" ]; then
        echo "$cached_bus"
        exit 0
    fi
fi

# Detect bus via ddcutil (skip "Invalid display" entries, only use valid "Display N")
bus=$(ddcutil detect --brief 2>/dev/null | awk '/^Display [0-9]/{found=1} found && /I2C bus:/{match($0, /i2c-([0-9]+)/, m); print m[1]; exit}')
if [ -n "$bus" ]; then
    printf '%s\n%s\n' "$active_conn" "$bus" > "$CACHE"
    echo "$bus"
    exit 0
fi

rm -f "$CACHE"
exit 1
