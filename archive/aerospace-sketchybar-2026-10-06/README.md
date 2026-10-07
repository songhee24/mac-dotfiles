# mac-dotfiles

Linux-style desktop for macOS — the Mac counterpart of [dotfiles](https://github.com/songhee24/dotfiles) (Hyprland):

| Piece | Tool | Config |
|---|---|---|
| Tiling + workspaces | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | `.config/aerospace/aerospace.toml` |
| Top bar | [SketchyBar](https://github.com/FelixKratz/SketchyBar) | `.config/sketchybar/` |
| Window borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) | `.config/borders/bordersrc` |

Catppuccin Mocha + JetBrainsMono Nerd Font, same as the terminal from
[mac-terminal-glass](https://github.com/songhee24/mac-terminal-glass) (Ghostty + Starship).

## Install / undo
```sh
git clone https://github.com/songhee24/mac-dotfiles ~/Projects/personal/mac-dotfiles
bash ~/Projects/personal/mac-dotfiles/install.sh     # then allow AeroSpace in Privacy & Security > Accessibility
bash ~/Projects/personal/mac-dotfiles/uninstall.sh   # back to the plain macOS look
```
`~/.config/{aerospace,sketchybar,borders}` are links into this repo: edit here, then reload.

## Keys (⌥ = Option)
| Keys | Action |
|---|---|
| ⌥ H J K L | focus left / down / up / right |
| ⌥⇧ H J K L | move the window |
| ⌥ 1…9 · ⌥⇧ 1…9 | go to workspace · send the window there |
| ⌥ Tab | previous workspace |
| ⌥ F | fullscreen |
| ⌥ / · ⌥ , | tiles ⇄ direction · accordion |
| ⌥⇧ Space | float / tile the window |
| ⌥ − / = | shrink / grow |
| ⌥ Enter | Ghostty |
| ⌥⇧ ; then Esc | reload AeroSpace config |

Reload the bar: `sketchybar --reload`. Quit tiling for a moment: AeroSpace menu-bar icon → Quit.
