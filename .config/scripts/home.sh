#!/usr/bin/bash

echo "Enter to the home mode..."

pidof skype && killall skype &> /dev/null
pidof telegram-desktop && killall telegram-desktop &> /dev/null

