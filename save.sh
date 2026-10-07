#!/usr/bin/env bash
# Save the current settings of OmniWM, AltTab and Stats into config/, so install.sh restores them on a
# reinstall or a new Mac (2026-10-07). Raycast keeps its own settings (Raycast > Settings > Advanced > Export).
set -euo pipefail
REPO=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$REPO/config/omniwm"
[ -f "$HOME/.config/omniwm/settings.toml" ] && cp "$HOME/.config/omniwm/settings.toml" "$REPO/config/omniwm/settings.toml" && echo "saved OmniWM settings.toml"
defaults export com.lwouis.alt-tab-macos "$REPO/config/alt-tab.plist" 2>/dev/null && plutil -convert xml1 "$REPO/config/alt-tab.plist" && echo "saved AltTab settings"
defaults export eu.exelban.Stats "$REPO/config/stats.plist" 2>/dev/null && plutil -convert xml1 "$REPO/config/stats.plist" && echo "saved Stats settings"
git -C "$REPO" status --short config/
