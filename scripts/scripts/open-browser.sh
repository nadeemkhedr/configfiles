#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: open-browser <url-fragment>" >&2
  exit 1
fi

ADDRESS="$1"

osascript -e "
set address to \"${ADDRESS}\"

tell application \"Brave Browser\"
    activate
    if not (exists window 1) then reopen
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
    open location \"http://\" & address
end tell
"
