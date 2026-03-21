#!/bin/bash
# Lock screen wrapper that auto-restarts hyprlock on crash.
#
# Problem: hyprlock crashes (SIGABRT) when a KVM switch triggers HDMI hotplug.
# The monitor disconnect/reconnect invalidates the EGL surface, causing
# eglSwapBuffers to fail. This is a known NVIDIA bug tracked upstream:
#   - github.com/hyprwm/hyprlock/issues/695 (21+ affected, still open)
#   - github.com/hyprwm/hyprlock/issues/861 (KVM-specific)
#   - Fix: PR #845 (merged Sep 2025, not yet in stable release 0.9.2)
#
# Why this wrapper instead of hyprlock-git:
#   hyprlock-git pulls in the entire hypr ecosystem as -git packages
#   (hyprgraphics-git, hyprlang-git, hyprutils-git, hyprwayland-scanner-git)
#   which conflicts with stable packages and risks breaking Hyprland itself.
#
# How it works:
#   1. Runs hyprlock in a loop
#   2. Normal unlock (exit 0) → stops the loop
#   3. Crash (exit != 0) → waits 1s for monitor to stabilize, re-locks
#   Requires misc:allow_session_lock_restore = true in hyprland.conf
#   so the new hyprlock instance can re-establish the lock surface.

hyprctl switchxkblayout all 0

# Don't start if already running
pidof hyprlock && exit 0

# Run hyprlock in a loop — if it exits non-zero (crash), restart it
while true; do
    hyprlock
    exit_code=$?
    # Exit 0 = normal unlock, stop looping
    [ "$exit_code" -eq 0 ] && break
    # Crashed — wait briefly for monitor to stabilize, then re-lock
    sleep 1
done
