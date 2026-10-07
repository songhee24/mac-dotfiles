# mac-dotfiles

Useful-first Mac setup (macOS 27, Apple Silicon) — the Mac counterpart of [dotfiles](https://github.com/songhee24/dotfiles) (Hyprland).
Terminal look (Ghostty + Starship) lives in [mac-terminal-glass](https://github.com/songhee24/mac-terminal-glass).

| App | What it does | Source |
|---|---|---|
| [OmniWM](https://omniwm.app) | Tiling: Niri-style scrolling or Hyprland-style dwindle, workspaces, Overview, Quake terminal | `brew install --cask omniwm` |
| [AltTab](https://alt-tab.app) | ⌘Tab with a preview of every window | `brew install --cask alt-tab` |
| [Stats](https://github.com/exelban/stats) | CPU / RAM / network in the menu bar | `brew install --cask stats` |
| ~~[Raycast](https://raycast.com)~~ | Off for now (2026-10-07). Launcher, clipboard history, snippets; free plan, Pro $8–10/mo | `brew install --cask raycast` |

Prices: OmniWM and Stats are fully free (open source). AltTab's core is free (switcher, previews, Shortcut 1 = ⌘Tab);
AltTab Pro (search, styles, auto-size, Shortcut 2+) is paid with a 14-day trial that simply ends — not needed here.

## Install · restore · save
```sh
bash install.sh   # first run saves a snapshot of the Mac, then installs + starts the four apps
bash restore.sh   # back to exactly before: apps + their data + permissions removed, Dock/Spaces/shortcuts restored
bash save.sh      # copy your tuned OmniWM / AltTab / Stats settings into config/ (commit them)
```
The snapshot lives in `~/.mac-dotfiles-snapshot/` (taken once, never overwritten).

## Shortcuts (⌥ = Option)
| Keys | Action |
|---|---|
| ⌘Tab | AltTab: every window, with previews (set once in AltTab › Controls: Shortcut 1 hold **⌘**; delete Shortcut 2) |
| ⌥ 1…9 · ⌥⇧ 1…9 | OmniWM: go to workspace · send the window there |
| ⌃⌥⇧ ↓ / ↑ | send the window to the next / previous workspace |
| ⌥ arrows · ⌥⇧ arrows | focus · move a window |
| ⌥ / · ⌥⇧ / | Dwindle: flip the split (side by side ⇄ stacked) · swap the two sides |
| ⌥ = / ⌥ − | Dwindle: grow / shrink the focused window (⌥ + right-drag does it with the mouse) |
| ⌥⇧ B | make all windows equal again |
| ⌥⇧ L | switch this workspace between Dwindle (Hyprland-style) and Niri (scrolling columns) |
| ⌥ Tab | previous window |
| ⌥ Return | fullscreen (OmniWM) |
| ⌥⇧ O | Overview of all windows |
| ⌥ Esc | Quake drop-down terminal (Ghostty) — moved from ⌥ `: on a Russian/ISO keyboard that key is not left of 1 |
| ⌃⌥ Space | OmniWM command palette |

Layout: every workspace uses **Dwindle** (Hyprland-style — each new window splits the focused one). OmniWM's
default is Niri with one full-width column per screen, which feels like "windows never share the screen".
In Dwindle ⌥ = / ⌥ − resize windows; Niri's column-width keys moved off them (Niri keeps ⌥ . / ⌥ , ).

Rules: never run a second window manager next to OmniWM (Rectangle, AeroSpace, Raycast's own window commands).
Dragging a tiled window's edge does not stick (OmniWM restores its layout) — use the keys or ⌥ + right-drag.
OmniWM needs "Displays have separate Spaces" on (macOS default).

`archive/aerospace-sketchybar-2026-10-06/` — the first attempt (AeroSpace + SketchyBar + JankyBorders), removed: the bar was decoration.
