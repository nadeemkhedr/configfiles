#!/bin/sh

# Opens bml in a new Ghostty instance. Slower than bml-popup.sh (spawns a
# new ghostty process) but has fewer focus quirks.
#
# Standalone so it can be triggered from anywhere (karabiner, BetterMouse,
# leaderkey). Uses absolute paths since those launchers don't get the
# Homebrew/Ghostty PATH.

exec /Applications/Ghostty.app/Contents/MacOS/ghostty \
  --initial-command=/usr/local/bin/bml \
  --window-width=100 \
  --window-height=24 \
  --window-position-x=1300 \
  --window-position-y=285
