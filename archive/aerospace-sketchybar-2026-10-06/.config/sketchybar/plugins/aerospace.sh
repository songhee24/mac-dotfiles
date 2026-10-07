#!/bin/bash
# One workspace pill. $1 = workspace id. Drawn when focused (lavender) or holding windows (dim); hidden when empty.
export PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/colors.sh"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
count=$(aerospace list-windows --workspace "$1" --count 2>/dev/null || echo 0)
if [ "$1" = "$focused" ]; then
  sketchybar --set "$NAME" drawing=on background.drawing=on label.color=$CRUST
elif [ "${count:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on background.drawing=off label.color=$SUBTEXT
else
  sketchybar --set "$NAME" drawing=off
fi
