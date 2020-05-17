#!/bin/bash
current_level=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )
if [[ $current_level -lt 100 ]]
then
    pactl set-sink-volume 0 "$1"
fi
