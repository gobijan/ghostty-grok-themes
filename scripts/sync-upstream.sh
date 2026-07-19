#!/usr/bin/env bash
# Pull official TextMate themes from xai-org/grok-build into sublime/.
# Does not overwrite ghostty/ or helix/ ports (those are derivative mappings).
#
# Usage:
#   ./scripts/sync-upstream.sh
#   GROK_BUILD_REF=v1.2.3 ./scripts/sync-upstream.sh   # pin a tag/commit

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF="${GROK_BUILD_REF:-main}"
BASE="https://raw.githubusercontent.com/xai-org/grok-build/${REF}/crates/codegen/xai-grok-pager-render/assets"
DEST="${ROOT}/sublime"

mkdir -p "$DEST"

echo "Syncing tmThemes from xai-org/grok-build@${REF} …"

for name in grok-day.tmTheme grok-night.tmTheme tokyo-night.tmTheme; do
  url="${BASE}/${name}"
  out="${DEST}/${name}"
  echo "  $name"
  curl -fsSL "$url" -o "$out"
done

# Record pin for reproducibility
{
  echo "ref=${REF}"
  echo "synced_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "source=https://github.com/xai-org/grok-build/tree/${REF}/crates/codegen/xai-grok-pager-render/assets"
  if command -v shasum >/dev/null 2>&1; then
    echo
    echo "# sha256"
    (cd "$DEST" && shasum -a 256 grok-day.tmTheme grok-night.tmTheme tokyo-night.tmTheme)
  fi
} > "${DEST}/UPSTREAM.lock"

echo
echo "Wrote:"
echo "  sublime/grok-day.tmTheme"
echo "  sublime/grok-night.tmTheme"
echo "  sublime/tokyo-night.tmTheme"
echo "  sublime/UPSTREAM.lock"
echo
echo "Commit when ready:"
echo "  git add sublime && git commit -m \"Sync tmThemes from grok-build@${REF}\""
