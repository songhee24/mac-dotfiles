#!/bin/bash
# Online = the Wi-Fi interface has an address (macOS hides the network name from scripts without Location access).
if ipconfig getifaddr en0 >/dev/null 2>&1; then sketchybar --set "$NAME" icon="󰖩" label="on"
else sketchybar --set "$NAME" icon="󰖪" label="off"; fi
