#!/usr/bin/env bash
# mac-dotfiles installer (2026-10-06): AeroSpace tiling + SketchyBar glass bar + JankyBorders, Catppuccin Mocha -
# the Mac counterpart of songhee24/dotfiles (Hyprland). Terminal look lives in songhee24/mac-terminal-glass.
# Idempotent. Undo everything: bash uninstall.sh
set -euo pipefail
REPO=$(cd "$(dirname "$0")" && pwd)
eval "$(/opt/homebrew/bin/brew shellenv)"
say() { printf '\033[36m==> %s\033[0m\n' "$*"; }

say "Apps (Homebrew 7 needs the SketchyBar tap trusted once)"
brew tap FelixKratz/formulae >/dev/null
brew trust felixkratz/formulae >/dev/null 2>&1 || true
brew install --cask nikitabobko/tap/aerospace font-jetbrains-mono-nerd-font
brew install sketchybar borders

say "Link configs into ~/.config (a real folder already there is kept as <name>.bak)"
mkdir -p "$HOME/.config"
for d in aerospace sketchybar borders; do
  dst="$HOME/.config/$d"
  [ -e "$dst" ] && [ ! -L "$dst" ] && mv "$dst" "$dst.bak" && echo "   kept old $dst as $dst.bak"
  ln -sfn "$REPO/.config/$d" "$dst" && echo "   linked $dst"
done

say "macOS: auto-hide the menu bar and the Dock; group windows by app in Mission Control (AeroSpace's advice)"
# The menu bar: through System Events, which also tells running apps (a bare `defaults write NSGlobalDomain
# _HIHideMenuBar` waits for the next login). macOS asks once to let the terminal control System Events.
osascript -e 'tell application "System Events" to set autohide menu bar of dock preferences to true' \
  || defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock expose-group-apps -bool true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

say "Start (all three also start at login)"
brew services restart sketchybar
brew services restart borders
open -a AeroSpace
echo "Done. First launch: allow AeroSpace in System Settings > Privacy & Security > Accessibility."
