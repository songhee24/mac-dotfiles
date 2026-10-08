#!/usr/bin/env bash
# mac-dotfiles installer (2026-10-07): OmniWM (tiling) + AltTab (window switcher) + Stats (system monitor), from the
# official Homebrew casks. Raycast was part of it, off for now (see APPS). Idempotent.
#   - First run only: saves a snapshot of the Mac as it was (~/.mac-dotfiles-snapshot/) for restore.sh.
#   - Then installs the apps, copies the saved settings from config/ (if any), adds the OmniWM scratchpad helper
#     (LaunchAgent, 2026-10-08) and starts the apps.
# Undo everything: bash restore.sh      Save your tuned settings into this repo: bash save.sh
set -euo pipefail
REPO=$(cd "$(dirname "$0")" && pwd)
SNAP="$HOME/.mac-dotfiles-snapshot"
# 2026-10-07 ← was: (omniwm alt-tab stats raycast). Raycast is off for now (Akara: "seems raycast for now we can turn
# off"). Bring it back: add raycast here and Raycast to the "Start" loop below.
APPS=(omniwm alt-tab stats)
eval "$(/opt/homebrew/bin/brew shellenv)"
say() { printf '\033[36m==> %s\033[0m\n' "$*"; }

if [ ! -d "$SNAP" ]; then
  say "Snapshot of the Mac before the first install -> $SNAP (restore.sh puts this back)"
  mkdir -p "$SNAP"
  # Dock, Spaces/Mission Control, and the keyboard-shortcut table: the macOS settings these apps can touch.
  for domain in com.apple.dock com.apple.spaces com.apple.symbolichotkeys; do
    defaults export "$domain" "$SNAP/$domain.plist" 2>/dev/null || true
  done
  osascript -e 'tell application "System Events" to get autohide menu bar of dock preferences' > "$SNAP/menubar-autohide.txt" 2>/dev/null || true
  ls /Applications > "$SNAP/applications-before.txt"
  date '+%F %T' > "$SNAP/taken-at.txt"
else
  say "Snapshot already exists ($(cat "$SNAP/taken-at.txt" 2>/dev/null)) - kept, never overwritten"
fi

say "Apps: ${APPS[*]}"
brew install --cask "${APPS[@]}"

say "Settings from this repo (only what save.sh stored earlier)"
if [ -f "$REPO/config/omniwm/settings.toml" ]; then
  mkdir -p "$HOME/.config/omniwm"
  [ -f "$HOME/.config/omniwm/settings.toml" ] && cp -p "$HOME/.config/omniwm/settings.toml" "$HOME/.config/omniwm/settings.toml.before-install"
  cp "$REPO/config/omniwm/settings.toml" "$HOME/.config/omniwm/settings.toml" && echo "   OmniWM settings.toml"
fi
for pair in "alt-tab.plist:com.lwouis.alt-tab-macos" "stats.plist:eu.exelban.Stats"; do
  file=${pair%%:*} domain=${pair#*:}
  [ -f "$REPO/config/$file" ] && defaults import "$domain" "$REPO/config/$file" && echo "   $domain"
done

# 2026-10-08: the shortcut cheat sheet (OmniWM scratchpad 3, Option+A) and the helper that puts it - and Telegram, slot 1 -
# back into the scratchpads after a login or an OmniWM restart (OmniWM forgets scratchpad members when it quits).
mkdir -p "$HOME/.config/omniwm"
for file in shortcuts.txt restore-scratchpads.sh; do
  [ -f "$REPO/config/omniwm/$file" ] && cp "$REPO/config/omniwm/$file" "$HOME/.config/omniwm/$file" && echo "   OmniWM $file"
done

say "Scratchpad helper: a LaunchAgent that refills OmniWM's scratchpads after a login or an OmniWM restart"
AGENT_LABEL=com.mac-dotfiles.omniwm-scratchpads
AGENT="$HOME/Library/LaunchAgents/$AGENT_LABEL.plist"
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
# `watch --reconnect` survives OmniWM restarts; at login it exits while OmniWM is not up yet, and KeepAlive starts it again.
cat > "$AGENT" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$AGENT_LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/opt/homebrew/bin/omniwmctl</string><string>watch</string><string>display-changed</string>
    <string>--reconnect</string><string>--exec</string>
    <string>/bin/bash</string><string>$HOME/.config/omniwm/restore-scratchpads.sh</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>ThrottleInterval</key><integer>20</integer>
  <key>StandardOutPath</key><string>$HOME/Library/Logs/omniwm-scratchpads.log</string>
  <key>StandardErrorPath</key><string>$HOME/Library/Logs/omniwm-scratchpads.log</string>
</dict>
</plist>
EOF
launchctl bootout "gui/$(id -u)/$AGENT_LABEL" 2> /dev/null || true
launchctl bootstrap "gui/$(id -u)" "$AGENT" && echo "   $AGENT_LABEL (log: ~/Library/Logs/omniwm-scratchpads.log)"

say "Start"
# By path: right after brew moves an app in, LaunchServices may not know its name yet ("Unable to find application").
for app in OmniWM AltTab Stats; do open "/Applications/$app.app" || echo "   could not open $app"; done
cat <<'EOF'
Done. Allow the permissions macOS asks for (System Settings > Privacy & Security):
  OmniWM  - Device Control and Data Access + Input Monitoring (Screen Recording optional: Overview thumbnails)
  AltTab  - Device Control and Data Access + Screen Recording (window previews); then AltTab > Controls:
            Shortcut 1 hold key -> Command (free), delete Shortcut 2 (Pro-only, and its Option-` clashes with OmniWM)
Trackpad: System Settings > Trackpad > More Gestures - turn off "Swipe between full-screen applications", "Mission
  Control" and "App Expose", or macOS takes OmniWM's 3- and 4-finger swipes first.
EOF
