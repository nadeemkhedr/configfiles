#!/usr/bin/env bash
set -euo pipefail

echo "===== $(date) ====="

STAND_POS=1040
SIT_POS=683

# Use FULL PATH to linak-controller (from `which linak-controller`)
LINAK="/Users/nadeem/.local/bin/linak-controller"

if [[ ! -x "$LINAK" ]]; then
  echo "ERROR: linak-controller not found or not executable at: $LINAK"
  exit 1
fi

echo "Using: $LINAK"

OUT="$("$LINAK" 2>&1)" || {
  echo "ERROR running linak-controller:"
  echo "$OUT"
  exit 1
}

echo "linak-controller output:"
echo "$OUT"

CUR=$(echo "$OUT" | grep "Height" | grep -oE '[0-9]+')

if [[ -z "${CUR:-}" ]]; then
  echo "ERROR: Could not detect desk height!"
  exit 1
fi

echo "Current height: $CUR"

MID=$(((STAND_POS + SIT_POS) / 2))

if [[ "$CUR" -lt "$MID" ]]; then
  echo "Moving to standing..."
  "$LINAK" --move-to stand
else
  echo "Moving to sitting..."
  "$LINAK" --move-to sit
fi

echo "Done."
