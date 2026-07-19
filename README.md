# Ghostty Grok Themes

**GrokDay** and **GrokNight** — terminal color themes matching [Grok Build](https://grok.x.ai/) TUI palettes, for [Ghostty](https://ghostty.org/).

| Theme | Mode | Background | Accent |
|-------|------|------------|--------|
| **GrokNight** | Dark | `#0a0a0a` | Magenta `#bb9af7` |
| **GrokDay** | Light | `#f5f5f5` | Purple `#7d4bc6` |

GrokDay sets ANSI white / bright-white to dark readable grays so tools that color braces and punctuation with “white” (e.g. `bat --theme=base16`, many `rustc`/`cargo` paths) stay visible on a light background.

---

## Quick install (copy-paste)

### One-liner (no clone)

Replace `OWNER` with the GitHub user/org that hosts this repo:

```bash
curl -fsSL https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/install.sh | bash
```

### Clone + install (best for updates)

```bash
git clone https://github.com/gobijan/ghostty-grok-themes.git ~/src/ghostty-grok-themes
~/src/ghostty-grok-themes/install.sh
```

### Manual copy

```bash
# XDG (Linux + macOS)
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes"
curl -fsSL -o "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes/GrokDay" \
  https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/themes/GrokDay
curl -fsSL -o "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes/GrokNight" \
  https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/themes/GrokNight

# Also on macOS (optional but recommended if you keep config under Application Support)
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty/themes"
cp "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes/GrokDay" \
   "$HOME/Library/Application Support/com.mitchellh.ghostty/themes/"
cp "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes/GrokNight" \
   "$HOME/Library/Application Support/com.mitchellh.ghostty/themes/"
```

---

## Enable the themes

Edit your Ghostty config and set:

```ini
theme = light:GrokDay,dark:GrokNight
```

Ghostty will follow system light/dark appearance.

**Single theme only:**

```ini
theme = GrokNight
# theme = GrokDay
```

**Config file locations**

| OS | Path |
|----|------|
| macOS | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| Linux | `~/.config/ghostty/config` |

Reload: **Cmd+Shift+,** (macOS) / your Ghostty “reload config” binding, or open a new window.

Verify:

```bash
ghostty +list-themes | grep -i grok
```

---

## Update on other machines

If you installed via clone:

```bash
cd ~/src/ghostty-grok-themes
git pull
./install.sh
```

If you used the one-liner, run it again — it overwrites the theme files in place:

```bash
curl -fsSL https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/install.sh | bash
```

---

## Sync strategy

Recommended layout for multi-machine setups:

1. Clone this repo on each machine (or once into a synced dotfiles tree).
2. Run `./install.sh` after `git pull`.
3. Keep only `theme = light:GrokDay,dark:GrokNight` in your Ghostty `config` (dotfiles or manual).

Theme files are plain text; versioning lives in this git repo.

---

## Files

```text
themes/GrokDay      # light
themes/GrokNight    # dark
install.sh          # installs into Ghostty theme dirs
```

Ghostty looks up themes by name under:

1. `${XDG_CONFIG_HOME:-~/.config}/ghostty/themes`
2. Ghostty’s prefix `share/ghostty/themes` (built-ins)

On macOS the installer also copies into  
`~/Library/Application Support/com.mitchellh.ghostty/themes`.

---

## License

Colors are derived from Grok Build TUI palettes for personal/terminal theming.  
This repo’s theme files and installer are provided as-is under [MIT](LICENSE).
