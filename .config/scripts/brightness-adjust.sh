#!/bin/bash
# Adjust brightness for active monitor (internal or external)
# Usage: brightness-adjust.sh [+5 or -5]

CHANGE=$1

# Check if any external display is active (anything other than eDP-1)
EXT_MON=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1" and .disabled == false) | .name' | head -1)

if [ -n "$EXT_MON" ]; then
    # External display active - use ddcutil with auto-detected bus
    BUS=$(~/.config/scripts/ddc-bus.sh)
    [ -z "$BUS" ] && exit 1
    if [[ "$CHANGE" == +* ]]; then
        ddcutil --noverify --sleep-multiplier 0.1 --bus "$BUS" setvcp 10 + "${CHANGE#+}" && pkill -RTMIN+8 waybar
    else
        ddcutil --noverify --sleep-multiplier 0.1 --bus "$BUS" setvcp 10 - "${CHANGE#-}" && pkill -RTMIN+8 waybar
    fi
else
    # Internal display active - use brightnessctl
    if [[ "$CHANGE" == +* ]]; then
        brightnessctl -d intel_backlight set "${CHANGE#+}%+"
    else
        brightnessctl -d intel_backlight set "${CHANGE#-}%-"
    fi
fi
