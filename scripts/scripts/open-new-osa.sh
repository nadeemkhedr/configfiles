#!/usr/bin/env bash

# Accepts an app name and opens a new window in the same instance
# This is needed mainly for ghostty on macos
# https://github.com/ghostty-org/ghostty/discussions/3563

APP_NAME="$1"

if [ -z "$APP_NAME" ]; then
  echo "Usage: $0 <Application Name>"
  exit 1
fi

osascript <<EOF
tell application "$APP_NAME"
  if it is running then
    activate
    tell application "System Events" to keystroke "n" using {command down}
  else
    activate
  end if
end tell
EOF
