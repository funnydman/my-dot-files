#!/bin/bash
# i3-like scratchpad toggle for Hyprland
# Source: https://github.com/hyprwm/Hyprland/discussions/3097
#
# Usage: scratchpad-toggle.sh <workspace_name> <command>
# - If no windows in scratchpad → launches command
# - If windows exist → toggles visibility
# - Empty scratchpad = nothing happens (no overlay)

windows_in(){
    hyprctl clients -j | jq ".[] | select(.workspace.name == \"special:$1\")"
}

toggle_scratchpad(){
    workspace_name="$1"
    cmd="$2"

    if [ -n "$(windows_in "$workspace_name")" ]; then
        hyprctl dispatch togglespecialworkspace "$workspace_name"
    fi
}

toggle_scratchpad "${1:-scratchpad}"
