#!/usr/bin/env bash
# Refill OmniWM's scratchpads after OmniWM starts (2026-10-08). OmniWM keeps scratchpad membership only while its process
# runs (its docs: "only the labels are persisted"), so after a login or an OmniWM restart the slots were empty and the
# show/hide keys did nothing.
#   slot 3 - the shortcut cheat sheet (~/.config/omniwm/shortcuts.txt in TextEdit, opened when no window shows it)
#   slot 1 - Telegram, when it has a window within a minute. Telegram is not a login item, so after a login it may come
#            later - then put it in with Option+Shift+S, as before.
# Run by the LaunchAgent that install.sh writes: `omniwmctl watch display-changed --reconnect --exec <this script>`.
# watch sends one display snapshot on every (re)connect, so this runs once per OmniWM start - and on a monitor change,
# which is harmless: a window already in a scratchpad is left alone. Needs `ipcEnabled = true` in settings.toml.
set -uo pipefail
CTL=/opt/homebrew/bin/omniwmctl
SHEET="$HOME/.config/omniwm/shortcuts.txt"
cat > /dev/null # the event line on stdin is not needed

# window_state <app> <title part>: "member" when such a window is already in a scratchpad, else the id of the first such
# window, else nothing.
window_state() {
  "$CTL" query windows --format json 2> /dev/null | /usr/bin/python3 -I -c '
import json, sys
app, part = sys.argv[1], sys.argv[2]
windows = json.load(sys.stdin)["result"]["payload"]["windows"]
mine = [w for w in windows if w["app"]["name"] == app and part in (w.get("title") or "")]
if any(w.get("isScratchpad") for w in mine): print("member")
elif mine: print(mine[0]["id"])' "$1" "$2"
}

focused_id() {
  "$CTL" query focused-window --format json 2> /dev/null | /usr/bin/python3 -I -c '
import json, sys
window = json.load(sys.stdin)["result"]["payload"].get("window")
print(window["id"] if window else "")'
}

# focus_on <id>: true once OmniWM reports that window focused (up to 3 s). `window focus` returns before focus moves,
# and `scratchpad assign` takes the FOCUSED window - without this wait a Ghostty window landed in slot 1 (2026-10-08).
focus_on() {
  local i
  "$CTL" window focus "$1" > /dev/null || return 1
  for ((i = 0; i < 30; i++)); do
    [ "$(focused_id)" = "$1" ] && return 0
    sleep 0.1
  done
  return 1
}

# fill <app> <title part> <slot> <seconds to wait for the window>. Assigning toggles, so it never runs on a member.
fill() {
  local state="" i
  for ((i = 0; i <= $4; i++)); do
    state=$(window_state "$1" "$2")
    [ -n "$state" ] && break
    sleep 1
  done
  case "$state" in
    "") echo "$(date '+%F %T') $1: no window, slot $3 left empty" ;;
    member) ;;
    *)
      if focus_on "$state" && "$CTL" command scratchpad assign "$3" > /dev/null; then
        echo "$(date '+%F %T') $1 -> scratchpad $3"
      else
        echo "$(date '+%F %T') $1: focus did not move to it, slot $3 left empty"
      fi
      ;;
  esac
}

# Focusing a window to assign it moves focus; give it back afterwards.
focused=$(focused_id)

[ -z "$(window_state TextEdit shortcuts.txt)" ] && open -g -a TextEdit "$SHEET"
fill TextEdit shortcuts.txt 3 15
fill Telegram "" 1 60
[ -n "$focused" ] && "$CTL" window focus "$focused" > /dev/null
exit 0
