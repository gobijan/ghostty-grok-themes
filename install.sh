#!/usr/bin/env bash
# Install Grok themes for Ghostty, Helix, and/or Sublime Text.
#
# Usage:
#   ./install.sh              # all targets found / all
#   ./install.sh ghostty
#   ./install.sh helix
#   ./install.sh sublime
#   ./install.sh all
#
# One-liner (after repo is on GitHub):
#   curl -fsSL https://raw.githubusercontent.com/gobijan/grok-themes/main/install.sh | bash

set -euo pipefail

REPO_RAW_BASE="${GROK_THEMES_RAW_BASE:-https://raw.githubusercontent.com/gobijan/grok-themes/main}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
TARGET="${1:-all}"

have_local() {
  [[ -d "${SCRIPT_DIR}/ghostty" && -d "${SCRIPT_DIR}/helix" && -d "${SCRIPT_DIR}/sublime" ]]
}

fetch_file() {
  local rel="$1" dest="$2"
  if have_local && [[ -f "${SCRIPT_DIR}/${rel}" ]]; then
    cp "${SCRIPT_DIR}/${rel}" "$dest"
  else
    curl -fsSL "${REPO_RAW_BASE}/${rel}" -o "$dest"
  fi
}

install_ghostty() {
  echo "→ Ghostty"
  local dirs=()
  dirs+=("${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes")
  if [[ "$(uname -s)" == "Darwin" ]]; then
    dirs+=("$HOME/Library/Application Support/com.mitchellh.ghostty/themes")
  fi
  for d in "${dirs[@]}"; do
    mkdir -p "$d"
    fetch_file ghostty/GrokDay "$d/GrokDay"
    fetch_file ghostty/GrokNight "$d/GrokNight"
    echo "    $d"
  done
  echo
  echo "  Config (add to Ghostty config):"
  echo "    theme = light:GrokDay,dark:GrokNight"
  echo "  macOS config: ~/Library/Application Support/com.mitchellh.ghostty/config"
  echo "  Linux config: \${XDG_CONFIG_HOME:-~/.config}/ghostty/config"
  echo "  Reload: Cmd+Shift+, (macOS) or open a new window"
}

install_helix() {
  echo "→ Helix"
  local d="${XDG_CONFIG_HOME:-$HOME/.config}/helix/themes"
  mkdir -p "$d"
  fetch_file helix/grok-day.toml "$d/grok-day.toml"
  fetch_file helix/grok-night.toml "$d/grok-night.toml"
  echo "    $d"
  echo
  echo "  Enable in ~/.config/helix/config.toml (follows system appearance):"
  echo "    [theme]"
  echo "    dark = \"grok-night\""
  echo "    light = \"grok-day\""
  echo "  Or fixed: theme = \"grok-night\""
  echo "  Or interactively: :theme grok-night / :theme grok-day"
}

install_sublime() {
  echo "→ Sublime Text"
  local candidates=()
  if [[ "$(uname -s)" == "Darwin" ]]; then
    candidates+=(
      "$HOME/Library/Application Support/Sublime Text/Packages/User"
      "$HOME/Library/Application Support/Sublime Text 3/Packages/User"
    )
  else
    candidates+=(
      "${XDG_CONFIG_HOME:-$HOME/.config}/sublime-text/Packages/User"
      "$HOME/.config/sublime-text-3/Packages/User"
    )
  fi

  local dest=""
  for c in "${candidates[@]}"; do
    if [[ -d "$(dirname "$c")" ]] || [[ -d "$c" ]]; then
      dest="$c"
      break
    fi
  done
  if [[ -z "$dest" ]]; then
    dest="${candidates[0]}"
  fi

  mkdir -p "$dest"
  fetch_file sublime/grok-day.tmTheme "$dest/grok-day.tmTheme"
  fetch_file sublime/grok-night.tmTheme "$dest/grok-night.tmTheme"
  fetch_file sublime/tokyo-night.tmTheme "$dest/tokyo-night.tmTheme"
  echo "    $dest"
  echo
  echo "  Enable: Preferences → Select Color Scheme →"
  echo "    grok-night  |  grok-day  |  tokyo-night"
  echo "  Or in Preferences.sublime-settings:"
  echo "    \"color_scheme\": \"Packages/User/grok-night.tmTheme\""
}

case "$TARGET" in
  all|"")
    install_ghostty
    echo
    install_helix
    echo
    install_sublime
    ;;
  ghostty) install_ghostty ;;
  helix) install_helix ;;
  sublime|tmtheme|tm) install_sublime ;;
  -h|--help|help)
    echo "Usage: $0 [all|ghostty|helix|sublime]"
    exit 0
    ;;
  *)
    echo "Unknown target: $TARGET" >&2
    echo "Usage: $0 [all|ghostty|helix|sublime]" >&2
    exit 1
    ;;
esac

echo
echo "Done. Mode: $(have_local && echo local-clone || echo remote-download)"
