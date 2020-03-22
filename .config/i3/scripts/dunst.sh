#!/bin/bash

echo "Hello"

pidof dunst && killall -q dunst
dunst &

notify-send "Message one"
