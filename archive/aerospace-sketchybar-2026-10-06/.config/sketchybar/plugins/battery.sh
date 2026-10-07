#!/bin/bash
source "$CONFIG_DIR/colors.sh"
info=$(pmset -g batt)
pct=$(echo "$info" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -n "$pct" ] || exit 0
case $pct in 9[0-9]|100) icon="󰁹";; [7-8][0-9]) icon="󰂀";; [4-6][0-9]) icon="󰁾";; [1-3][0-9]) icon="󰁻";; *) icon="󰂃";; esac
color=$GREEN; [ "$pct" -le 20 ] && color=$RED
echo "$info" | grep -q "AC Power" && icon="󰂄"
sketchybar --set "$NAME" icon="$icon" icon.color=$color label="${pct}%"
