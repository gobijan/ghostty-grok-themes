# Grok themes for Ghostty, Helix & Sublime Text

Terminal and editor themes based on **[Grok Build](https://github.com/xai-org/grok-build)** (open source, Apache-2.0).

| Theme | Mode | Background | Accent |
|-------|------|------------|--------|
| **GrokNight** | Dark | `#0a0a0a` | Magenta `#bb9af7` |
| **GrokDay** | Light | `#f5f5f5` | Purple `#7d4bc6` |
| **Tokyo Night** | Dark | (syntax only) | Upstream tmTheme |

**Upstream source of truth**

- TUI palettes: [`grokday.rs`](https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-pager-render/src/theme/grokday.rs) · [`groknight.rs`](https://github.com/xai-org/grok-build/blob/main/crates/codegen/xai-grok-pager-render/src/theme/groknight.rs)
- TextMate / Sublime syntax themes: [`pager-render/assets`](https://github.com/xai-org/grok-build/tree/main/crates/codegen/xai-grok-pager-render/assets)

This repo **syncs** the official `.tmTheme` files and ships **ports** for Ghostty (16-color ANSI) and Helix (tree-sitter + UI).

---

## Layout

```text
ghostty/          GrokDay, GrokNight          → Ghostty terminal
helix/            grok-day.toml, grok-night.toml
sublime/          *.tmTheme (synced from upstream)
scripts/sync-upstream.sh
install.sh
NOTICE            Apache attribution
```

---

## Quick install (copy-paste)

### Clone (recommended — easy updates)

```bash
git clone https://github.com/gobijan/ghostty-grok-themes.git ~/src/ghostty-grok-themes
~/src/ghostty-grok-themes/install.sh          # Ghostty + Helix + Sublime
# or:
~/src/ghostty-grok-themes/install.sh ghostty
~/src/ghostty-grok-themes/install.sh helix
~/src/ghostty-grok-themes/install.sh sublime
```

### One-liner (no clone)

```bash
curl -fsSL https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/install.sh | bash
# specific target:
curl -fsSL https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/install.sh | bash -s -- helix
```

### Update later

```bash
cd ~/src/ghostty-grok-themes
git pull
./scripts/sync-upstream.sh   # refresh Sublime tmThemes from xai-org/grok-build
./install.sh
```

---

## Enable

### Ghostty

```ini
theme = light:GrokDay,dark:GrokNight
```

| OS | Config |
|----|--------|
| macOS | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| Linux | `~/.config/ghostty/config` |

Reload with **Cmd+Shift+,** or a new window. Check: `ghostty +list-themes | grep -i grok`

**GrokDay note:** ANSI white (`palette 7` / `15`) is mapped to dark grays so tools that color braces with “white” (e.g. `bat --theme=base16`) stay visible on the light background.

### Helix

```toml
# ~/.config/helix/config.toml
theme = "grok-night"
# theme = "grok-day"
```

Or `:theme grok-night` / `:theme grok-day` interactively.

### Sublime Text

After install, **Preferences → Select Color Scheme** → `grok-night`, `grok-day`, or `tokyo-night`.

Or in `Preferences.sublime-settings`:

```json
{
  "color_scheme": "Packages/User/grok-night.tmTheme"
}
```

Files land in:

| OS | Path |
|----|------|
| macOS | `~/Library/Application Support/Sublime Text/Packages/User/` |
| Linux | `~/.config/sublime-text/Packages/User/` |

---

## Sync official tmThemes from Grok Build

```bash
./scripts/sync-upstream.sh
# pin a commit/tag:
GROK_BUILD_REF=main ./scripts/sync-upstream.sh
```

Writes `sublime/*.tmTheme` + `sublime/UPSTREAM.lock` (ref + sha256).  
Ghostty and Helix ports are **not** auto-overwritten (they are hand-mapped derivatives).

---

## Multi-machine

1. Clone this repo on each machine (or into your dotfiles).
2. Run `./install.sh` after `git pull`.
3. Keep only the `theme = …` / Helix `theme =` / Sublime `color_scheme` lines in your personal configs.

---

## License

Apache License 2.0. Color palettes and `.tmTheme` files originate from
[xai-org/grok-build](https://github.com/xai-org/grok-build) (Copyright SpaceXAI).
See [NOTICE](NOTICE) and [LICENSE](LICENSE).
