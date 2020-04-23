#!/bin/sh
# https://www.reddit.com/r/i3wm/comments/g446yh/jumping_floating_windows_in_idea_with_i3/
i3-msg -t subscribe -m '[ "window" ]' | jq --unbuffered -r '.change,.container.window_type,.container.window_properties.class' |
while read -r event;read -r windowtype; read -r class; do
    if [ "$class" == "jetbrains-pycharm" ] && [ "$windowtype" == "dialog" ] && [ "$event" == "new" ]; then
      i3-msg '[class="jetbrains-pycharm"][window_type="dialog"] focus, floating enable, move position center'
    fi
done
