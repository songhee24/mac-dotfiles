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
`install.sh` also adds a LaunchAgent (`com.mac-dotfiles.omniwm-scratchpads`, 2026-10-08): OmniWM forgets which windows
sit in its scratchpads when it quits, so after a login or an OmniWM restart the helper puts the cheat sheet (slot 3) and
Telegram (slot 1, if it has a window within a minute) back. It needs `ipcEnabled = true` in OmniWM's settings.
Log: `~/Library/Logs/omniwm-scratchpads.log`.

## Shortcuts (⌥ = Option)
Every OmniWM key is in [`config/omniwm/shortcuts.txt`](config/omniwm/shortcuts.txt) — ⌥ A shows it as a pop-up.

| Keys | Action |
|---|---|
| ⌘Tab | AltTab: every window, with previews (set once in AltTab › Controls: Shortcut 1 hold **⌘**; delete Shortcut 2) |
| ⌥ A · ⌥⇧ A | show / hide the cheat sheet (scratchpad 3) · put a window there |
| ⌥ ← / → · 3 fingers ← / → | next window — the row slides sideways and loops |
| ⌥ 1…9 · ⌥⇧ 1…9 · 3 fingers ↑ / ↓ | go to workspace · send the window there · next / previous workspace |
| ⌥⇧ ← / → | stack the window into the next column (that is how tiles are built) · pull it out again |
| ⌃⌥⇧ ← / → | move the whole column |
| ⌥ . · ⌥⇧ F · ⌥⇧ B | column width ⅓ → ½ → ⅔ · full width · equal sizes |
| ⌥ S / ⌥ D · ⌥⇧ S / ⌥⇧ D | show / hide scratchpad 1 / 2 (Telegram lives in 1) · put a window there |
| ⌥⇧ O · 4 fingers ↑ | Overview of all windows |
| ⌥ Return · ⌥ Tab | fullscreen (OmniWM) · previous window |
| ⌥⇧ L | switch this workspace between Niri and Dwindle (Hyprland-style splits) |
| ⌃⌥ Space | OmniWM command palette |
| ⌥ ` | Quake drop-down terminal — OmniWM's default; the ` key is missing on this Russian/ISO keyboard |

Layout (2026-10-08): **Niri** on every workspace — one long row of columns, two per screen, looping. Tiles are windows
stacked inside a column. Changing workspace always slides up/down (hard-coded in OmniWM 0.7.5), so the sideways slide is
the row. In Ghostty open terminals as windows (⌘N): tabs stay inside one window and do not tile.
← 2026-10-07 to 10-08 it was Dwindle everywhere, with ⌥ / flip split, ⌥ = / ⌥ − resize and the Quake terminal on ⌥ Esc;
dropped for the sideways row. Any workspace goes back to Dwindle with ⌥⇧ L.

Rules: never run a second window manager next to OmniWM (Rectangle, AeroSpace, Raycast's own window commands).
OmniWM needs "Displays have separate Spaces" on (macOS default) and one macOS desktop per display — a window on a
second desktop pulls you over there.
Trackpad: turn off macOS's 3- and 4-finger swipes (System Settings › Trackpad › More Gestures: Swipe between full-screen
applications, Mission Control, App Exposé), or macOS takes them before OmniWM.
OmniWM drops the whole `settings.toml` when one value is invalid (it runs its defaults, without a message), so check
that an edit took effect.

`archive/aerospace-sketchybar-2026-10-06/` — the first attempt (AeroSpace + SketchyBar + JankyBorders), removed: the bar was decoration.
