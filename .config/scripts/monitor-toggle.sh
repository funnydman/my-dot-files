#!/bin/bash
# Exclusive toggle: only one monitor active at a time
# Auto-detects external monitor from connected DP or HDMI connectors

# Find the connected external connector (DP or HDMI, not eDP)
EXT_NAME=""
for conn in /sys/class/drm/card*-{DP,HDMI-A}-*; do
    if [ "$(cat "$conn/status" 2>/dev/null)" = "connected" ]; then
        # Extract Hyprland monitor name (e.g., card1-DP-1 -> DP-1, card0-HDMI-A-1 -> HDMI-A-1)
        EXT_NAME=$(basename "$conn" | sed 's/card[0-9]*-//')
        break
    fi
done

if [ -z "$EXT_NAME" ]; then
    notify-send "Monitor" "No external display detected"
    exit 1
fi

# Check if internal monitor is currently active (not disabled)
if hyprctl monitors all -j | jq -e '.[] | select(.name == "eDP-1" and .disabled == false)' > /dev/null 2>&1; then
    # Internal is active - switch to external only
    hyprctl keyword monitor eDP-1,disable
    sleep 0.5
    hyprctl keyword monitor "$EXT_NAME",3840x2160@60,0x0,1.5
    rm -f /tmp/ddc-bus  # invalidate brightness cache
    notify-send "Monitor" "Switched to external display ($EXT_NAME)"
else
    # External is active - switch to internal only
    hyprctl keyword monitor "$EXT_NAME",disable
    sleep 0.5
    hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
    rm -f /tmp/ddc-bus  # invalidate brightness cache
    notify-send "Monitor" "Switched to internal display"
fi
