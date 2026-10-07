#!/usr/bin/env bash
# Back to the Mac as it was before install.sh (2026-10-07). Quits and uninstalls OmniWM, AltTab, Stats, Raycast with
# their data (brew --zap: their settings, caches, Raycast snippets/clipboard), clears their permissions, and puts back
# the Dock / Spaces / keyboard-shortcut settings saved in ~/.mac-dotfiles-snapshot/. Your windows and other apps are
# not touched. The repo (and its config/) stays, so install.sh can bring everything back.
set -uo pipefail
SNAP="$HOME/.mac-dotfiles-snapshot"
eval "$(/opt/homebrew/bin/brew shellenv)"
say() { printf '\033[36m==> %s\033[0m\n' "$*"; }

say "Quit the apps"
ids=()
for app in OmniWM AltTab Stats Raycast; do
  id=$(defaults read "/Applications/$app.app/Contents/Info.plist" CFBundleIdentifier 2>/dev/null) && ids+=("$id")
  osascript -e "quit app \"$app\"" 2>/dev/null
done
sleep 2

say "Uninstall with their data"
brew uninstall --cask --zap omniwm alt-tab stats raycast 2>&1 | grep -E "Uninstalling|Error|not installed" || true

say "Clear their permissions (Device Control, Input Monitoring, Screen Recording)"
for id in ${ids[@]+"${ids[@]}"}; do tccutil reset All "$id" >/dev/null 2>&1 && echo "   $id"; done

if [ -d "$SNAP" ]; then
  say "macOS settings from the snapshot ($(cat "$SNAP/taken-at.txt" 2>/dev/null))"
  for domain in com.apple.dock com.apple.spaces com.apple.symbolichotkeys; do
    [ -f "$SNAP/$domain.plist" ] && defaults import "$domain" "$SNAP/$domain.plist" && echo "   $domain"
  done
  if [ -f "$SNAP/menubar-autohide.txt" ]; then
    osascript -e "tell application \"System Events\" to set autohide menu bar of dock preferences to $(cat "$SNAP/menubar-autohide.txt")" 2>/dev/null
  fi
  killall Dock 2>/dev/null; killall SystemUIServer 2>/dev/null
else
  echo "No snapshot at $SNAP - apps removed, macOS settings left as they are."
fi
echo "Restored. (A log-out/in applies keyboard-shortcut changes everywhere.) Reinstall any time: bash install.sh"
