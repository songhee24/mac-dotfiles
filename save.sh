#!/usr/bin/env bash
# Save the current settings of OmniWM, AltTab and Stats into config/, so install.sh restores them on a
# reinstall or a new Mac (2026-10-07). Raycast keeps its own settings (Raycast > Settings > Advanced > Export).
# The repo is public: app plists also hold telemetry and device IDs (AltTab: MSAppCenter install/device/session IDs;
# Stats: remote_id), so only real settings are kept, and the save is refused if an ID or IP still slips through.
set -euo pipefail
REPO=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$REPO/config/omniwm"

# filter_plist <file> <keep-regex> <drop-regex>: keep keys matching keep and not matching drop.
filter_plist() {
  python3 -I - "$@" <<'PY'
import plistlib, re, sys
path, keep, drop = sys.argv[1], re.compile(sys.argv[2]), re.compile(sys.argv[3])
with open(path, "rb") as f: d = plistlib.load(f)
kept = {k: v for k, v in d.items() if keep.fullmatch(k) and not drop.fullmatch(k)}
with open(path, "wb") as f: plistlib.dump(kept, f)
print(f"  {path.rsplit('/', 1)[-1]}: kept {len(kept)} of {len(d)} keys")
PY
}

[ -f "$HOME/.config/omniwm/settings.toml" ] && cp "$HOME/.config/omniwm/settings.toml" "$REPO/config/omniwm/settings.toml" && echo "saved OmniWM settings.toml"

defaults export com.lwouis.alt-tab-macos "$REPO/config/alt-tab.plist"
filter_plist "$REPO/config/alt-tab.plist" '.*' '(MSAppCenter.*|NSWindow Frame.*|SU.*|.*[Ll]icen[cs]e.*|.*[Uu]sage.*|.*[Tt]rial.*)'
echo "saved AltTab settings"

defaults export eu.exelban.Stats "$REPO/config/stats.plist"
filter_plist "$REPO/config/stats.plist" '(CPU|GPU|RAM|Disk|Sensors|Network|Battery|Bluetooth|Clock)_.*|setupProcess' '.*(_id|[Tt]oken.*|_ts|[Ii][Pp])'
echo "saved Stats settings"

# Guard: nothing that looks like a UUID or an IPv4 address may reach the public repo.
for f in "$REPO/config/alt-tab.plist" "$REPO/config/stats.plist" "$REPO/config/omniwm/settings.toml"; do
  case "$f" in *.plist) plutil -convert xml1 "$f" ;; esac
  # Allowed: OmniWM's own rule ids (`id = "<uuid>"` lines in [[appRules]]) - random per rule, not tied to a device.
  if grep -v -E '^id = "[0-9A-Fa-f-]{36}"$' "$f" \
     | grep -E -q '[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}|\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'; then
    echo "REFUSED: $f still holds an ID or IP - check it before committing" >&2; exit 1
  fi
done
git -C "$REPO" status --short config/
