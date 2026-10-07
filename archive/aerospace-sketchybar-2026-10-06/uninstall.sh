#!/usr/bin/env bash
# Back to the plain macOS look (2026-10-06): stops and removes AeroSpace, SketchyBar, JankyBorders, unlinks their
# configs, and gives the menu bar and Dock their macOS defaults again. Windows and apps are not touched.
set -uo pipefail
eval "$(/opt/homebrew/bin/brew shellenv)"
osascript -e 'quit app "AeroSpace"' 2>/dev/null
brew services stop sketchybar 2>/dev/null
brew services stop borders 2>/dev/null
brew uninstall --cask aerospace 2>/dev/null
brew uninstall sketchybar borders 2>/dev/null
for d in aerospace sketchybar borders; do
  [ -L "$HOME/.config/$d" ] && rm "$HOME/.config/$d"
  [ -e "$HOME/.config/$d.bak" ] && mv "$HOME/.config/$d.bak" "$HOME/.config/$d"
done
osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to false' 2>/dev/null \
  || defaults delete NSGlobalDomain _HIHideMenuBar 2>/dev/null
defaults delete com.apple.controlcenter AutoHideMenuBarOption 2>/dev/null
defaults delete com.apple.dock autohide 2>/dev/null
defaults delete com.apple.dock expose-group-apps 2>/dev/null
killall Dock 2>/dev/null; killall SystemUIServer 2>/dev/null
echo "Back to the plain macOS look. The configs stay in this repo; bash install.sh brings the rice back."
