#!/bin/bash
# The app in front; SketchyBar passes its name as $INFO on front_app_switched.
[ "$SENDER" = "front_app_switched" ] && sketchybar --set "$NAME" label="$INFO"
