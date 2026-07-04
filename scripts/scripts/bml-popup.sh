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

# Center the popup on the screen the mouse is on (the old hardcoded
# 1300,315 only made sense on the main monitor). JXA because plain
# AppleScript can't read NSScreen geometry. Outputs top-left coords in
# System Events' flipped coordinate space.
POS=$(/usr/bin/osascript -l JavaScript <<'JXA'
ObjC.import('AppKit');
const W = 792, H = 576;
const loc = $.NSEvent.mouseLocation;
const screens = $.NSScreen.screens;
let target = screens.objectAtIndex(0);
for (let i = 0; i < screens.count; i++) {
  const s = screens.objectAtIndex(i), f = s.frame;
  if (loc.x >= f.origin.x && loc.x < f.origin.x + f.size.width &&
      loc.y >= f.origin.y && loc.y < f.origin.y + f.size.height) { target = s; break; }
}
const f = target.visibleFrame;
const x = Math.round(f.origin.x + Math.max(0, (f.size.width - W) / 2));
// window top sits 35% into the free vertical space, spotlight-ish
const topOffset = Math.max(0, (f.size.height - H) * 0.35);
const primaryH = screens.objectAtIndex(0).frame.size.height;
const y = Math.round(primaryH - (f.origin.y + f.size.height - topOffset));
`${x} ${y}`;
JXA
)
set -- $POS
POS_X=$1 POS_Y=$2

# Ghostty's AppleScript API has no window geometry, so size/position
# are set via System Events after creation.
WID=$(
  /usr/bin/osascript <<EOF
tell application "Ghostty"
  -- activate window (not app-level activate) so only the popup is raised,
  -- without bringing every other Ghostty window above the current app
  set winId to id of (new window with configuration ¬
    {command:"/Users/nadeem/scripts/bml-popup.sh", environment variables:{"GHOSTTY_BML_INNER=1"}})
  activate window (window id winId)
end tell
tell application "System Events" to tell process "Ghostty"
  set position of front window to {$POS_X, $POS_Y}
  set size of front window to {792, 576}
end tell
return winId
EOF
)

printf %s "$WID" >"$WID_FILE"
