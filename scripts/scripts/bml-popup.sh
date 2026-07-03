#!/bin/sh

# Pops up bml in a new window of the already-running Ghostty instance
# (~150ms vs ~500ms for spawning a new ghostty process).
#
# Runs bml directly as the surface command so there's no shell-startup
# flash, but Ghostty 1.3.1 never auto-closes AppleScript-created command
# surfaces when the process exits (it shows "process exited, press any
# key" even with wait after command:false). Workaround: the script
# re-enters itself inside the window (GHOSTTY_BML_INNER) and closes its
# own window via AppleScript once bml exits — scripted `close window`
# bypasses both the exited screen and the close confirmation.
# Issue is here: https://github.com/ghostty-org/ghostty/discussions/13167

WID_FILE="/tmp/ghostty-bml-wid"

if [ -n "$GHOSTTY_BML_INNER" ]; then
  /usr/local/bin/bml
  WID=$(cat "$WID_FILE" 2>/dev/null)
  if [ -n "$WID" ]; then
    exec /usr/bin/osascript -e "tell application \"Ghostty\" to close window (window id \"$WID\")"
  fi
  exit 0
fi

# Ghostty's AppleScript API has no window geometry, so size/position
# (matching the old --window-width=72 --window-height=24 at 1300,285)
# are set via System Events after creation.
WID=$(
  /usr/bin/osascript <<'EOF'
tell application "Ghostty"
  activate
  set winId to id of (new window with configuration ¬
    {command:"/Users/nadeem/scripts/bml-popup.sh", environment variables:{"GHOSTTY_BML_INNER=1"}})
end tell
tell application "System Events" to tell process "Ghostty"
  set position of front window to {1300, 315}
  set size of front window to {792, 576}
end tell
return winId
EOF
)

printf %s "$WID" >"$WID_FILE"
