#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: send-keys <combo>"
  echo "Example: send-keys hyper+c"
  exit 1
fi

combo="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
key="${combo##*+}"
mods="${combo%+*}"

# If no modifiers were provided
if [[ "$mods" == "$key" ]]; then
  mods=""
fi

declare -a applescript_mods=()

add_mod() {
  applescript_mods+=("$1 down")
}

IFS='+' read -ra parts <<<"$mods"

for m in "${parts[@]}"; do
  case "$m" in
  cmd | command) add_mod "command" ;;
  ctrl | control) add_mod "control" ;;
  opt | option | alt) add_mod "option" ;;
  shift) add_mod "shift" ;;
  hyper)
    add_mod "control"
    add_mod "option"
    add_mod "shift"
    add_mod "command"
    ;;
  "") ;;
  *)
    echo "Unknown modifier: $m" >&2
    exit 2
    ;;
  esac
done

if [[ "${#applescript_mods[@]}" -eq 0 ]]; then
  using_clause=""
else
  using_clause="using {$(
    IFS=,
    echo "${applescript_mods[*]}"
  )}"
fi

osascript -e "tell application \"System Events\" to keystroke \"$key\" $using_clause"
