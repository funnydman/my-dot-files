#!/usr/bin/bash

echo "Enter to the home mode..."

echo "Killing Teams..."
pkill teams-for-linux

echo "Killing gpclient..."
pkill gpclient

# pidof telegram-desktop && killall telegram-desktop &> /dev/null

