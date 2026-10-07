# mac-dotfiles

Useful-first Mac setup (macOS 27, Apple Silicon) — the Mac counterpart of [dotfiles](https://github.com/songhee24/dotfiles) (Hyprland).
Terminal look (Ghostty + Starship) lives in [mac-terminal-glass](https://github.com/songhee24/mac-terminal-glass).

| App | What it does | Source |
|---|---|---|
| [OmniWM](https://omniwm.app) | Tiling: Niri-style scrolling or Hyprland-style dwindle, workspaces, Overview, Quake terminal | `brew install --cask omniwm` |
| [AltTab](https://alt-tab.app) | ⌘Tab with a preview of every window | `brew install --cask alt-tab` |
| [Stats](https://github.com/exelban/stats) | CPU / RAM / network in the menu bar | `brew install --cask stats` |
| [Raycast](https://raycast.com) | Launcher, clipboard history, snippets, extensions | `brew install --cask raycast` |

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
| ⌘Tab | AltTab: every window, with previews (set once in AltTab › Controls: hold **⌘**) |
| ⌥ 1…9 · ⌥⇧ 1…9 | OmniWM: go to workspace · send the window there |
| ⌥ arrows · ⌥⇧ arrows | focus · move a window |
| ⌥ Tab | previous window |
| ⌥ Return | fullscreen (OmniWM) |
| ⌥⇧ O | Overview of all windows |
| ⌥ ` | Quake drop-down terminal (Ghostty) |
| ⌃⌥ Space | OmniWM command palette |
| ⌥ Space | Raycast (set in its welcome window) |

Rules: never run a second window manager next to OmniWM (Rectangle, AeroSpace, Raycast's own window commands).
OmniWM needs "Displays have separate Spaces" on (macOS default).

`archive/aerospace-sketchybar-2026-10-06/` — the first attempt (AeroSpace + SketchyBar + JankyBorders), removed: the bar was decoration.
