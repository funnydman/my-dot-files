#!/bin/bash
# Exclusive toggle: only one monitor active at a time

# Check if internal monitor is currently active
if hyprctl monitors | grep -q "Monitor eDP-1"; then
    # Internal is active - switch to external only
    hyprctl keyword monitor eDP-1,disable
    hyprctl keyword monitor DP-2,3840x2160@60,0x0,1.5
    notify-send "Monitor" "Switched to external display"
else
    # External is active - switch to internal only
    hyprctl keyword monitor DP-2,disable
    hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
    notify-send "Monitor" "Switched to internal display"
fi
