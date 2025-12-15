#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-}"

find_sources() {
  if [[ -n "$TARGET" ]]; then
    # Allow passing a module directory or a direct data_source.txt path
    if [[ -f "$TARGET" && "$(basename "$TARGET")" == "data_source.txt" ]]; then
      printf "%s\n" "$TARGET"
    else
      find "$ROOT/$TARGET" -type f -name "data_source.txt"
    fi
  else
    find "$ROOT/modules" -type f -name "data_source.txt"
  fi
}

echo "🔎 Locating data_source.txt..."
SOURCES="$(find_sources || true)"

if [[ -z "$SOURCES" ]]; then
  echo "No data_source.txt found for target: ${TARGET:-<repo-wide>}"
  exit 0
fi

while read -r SOURCE_FILE; do
  DATA_DIR="$(dirname "$SOURCE_FILE")"
  echo
  echo "📂 Processing: $DATA_DIR"

  while IFS=',' read -r URL OUTFILE; do
    URL="$(echo "${URL:-}" | xargs)"
    OUTFILE="$(echo "${OUTFILE:-}" | xargs)"

    [[ -z "$URL" ]] && continue
    [[ "$URL" == \#* ]] && continue

    DEST="$DATA_DIR/$OUTFILE"

    if [[ -f "$DEST" ]]; then
      echo "  ✔ Exists: $OUTFILE"
    else
      echo "  ⬇ Downloading: $OUTFILE"
      wget -q "$URL" -O "$DEST"
    fi
  done < "$SOURCE_FILE"

done <<< "$SOURCES"

echo
echo "✅ Done."
