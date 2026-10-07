#!/bin/bash
# $INFO = the new volume on volume_change.
vol="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"
case $vol in 0) icon="󰖁";; [0-9]|[1-2][0-9]) icon="󰕿";; [3-6][0-9]) icon="󰖀";; *) icon="󰕾";; esac
sketchybar --set "$NAME" icon="$icon" label="${vol}%"
