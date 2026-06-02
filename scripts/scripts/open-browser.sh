#!/usr/bin/env bash
set -euo pipefail

# Accepts a URL and opens a new tab or focuses existing tab.
# Pass -n/--new-tab to always open a new tab instead of focusing an existing one.
#
NEW_TAB=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n | --new-tab)
      NEW_TAB=true
      shift
      ;;
    -*)
      echo "Unknown option: $1" >&2
      echo "Usage: open-browser [-n|--new-tab] <url-fragment>" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -ne 1 ]]; then
  echo "Usage: open-browser [-n|--new-tab] <url-fragment>" >&2
  exit 1
fi

ADDRESS="$1"

osascript -e "
set address to \"${ADDRESS}\"

tell application \"Brave Browser\"
    activate
    if not (exists window 1) then reopen
    if not ${NEW_TAB} then
        repeat with w in windows
            set i to 1
            repeat with t in tabs of w
                if URL of t contains address then
                    set active tab index of w to i
                    set index of w to 1
                    return
                end if
                set i to i + 1
            end repeat
        end repeat
    end if
    open location \"http://\" & address
end tell
"
