#!/usr/bin/env bash
# Install GrokDay + GrokNight Ghostty themes.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main/install.sh | bash
#   # or from a clone:
#   ./install.sh

set -euo pipefail

REPO_RAW_BASE="${GROK_GHOSTTY_RAW_BASE:-https://raw.githubusercontent.com/gobijan/ghostty-grok-themes/main}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"

# Resolve theme sources: local clone wins, otherwise download from GitHub.
if [[ -f "${SCRIPT_DIR}/themes/GrokDay" && -f "${SCRIPT_DIR}/themes/GrokNight" ]]; then
  SRC_DAY="${SCRIPT_DIR}/themes/GrokDay"
  SRC_NIGHT="${SCRIPT_DIR}/themes/GrokNight"
  MODE="local"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  curl -fsSL "${REPO_RAW_BASE}/themes/GrokDay" -o "${TMP}/GrokDay"
  curl -fsSL "${REPO_RAW_BASE}/themes/GrokNight" -o "${TMP}/GrokNight"
  SRC_DAY="${TMP}/GrokDay"
  SRC_NIGHT="${TMP}/GrokNight"
  MODE="remote"
fi

install_into() {
  local dest="$1"
  mkdir -p "$dest"
  cp "$SRC_DAY" "$dest/GrokDay"
  cp "$SRC_NIGHT" "$dest/GrokNight"
  echo "  → $dest"
}

echo "Installing Grok Ghostty themes ($MODE)…"

# XDG path (Linux + macOS; Ghostty looks here by name)
XDG_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes"
install_into "$XDG_THEMES"

# macOS Application Support path (where many mac configs live)
if [[ "$(uname -s)" == "Darwin" ]]; then
  MACOS_THEMES="$HOME/Library/Application Support/com.mitchellh.ghostty/themes"
  install_into "$MACOS_THEMES"
fi

echo
echo "Done. Add this to your Ghostty config:"
echo
echo "  theme = light:GrokDay,dark:GrokNight"
echo
echo "Then reload the config (macOS: Cmd+Shift+,) or open a new window."
echo
echo "Config locations:"
echo "  macOS:  ~/Library/Application Support/com.mitchellh.ghostty/config"
echo "  Linux:  \${XDG_CONFIG_HOME:-~/.config}/ghostty/config"
