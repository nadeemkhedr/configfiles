#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-}"
STEP="${MUSIC_VOL_STEP:-20}" # you can override: MUSIC_VOL_STEP=10 ./music-player.sh vol_up
MIN_VOL=0
MAX_VOL=100

usage() {
  cat <<'EOF'
Usage: music-player.sh <play-pause|next|prev|vol_up|vol_down>

Env:
  MUSIC_VOL_STEP   Volume step (0-100). Default: 5

Examples:
  ./music-player.sh play-pause
  ./music-player.sh next
  MUSIC_VOL_STEP=10 ./music-player.sh vol_down
EOF
}

osascript_run() {
  /usr/bin/osascript -e "$1"
}

case "$CMD" in
play-pause | playpause)
  osascript_run 'tell application "Music" to playpause'
  ;;

next | next-track | next_track)
  osascript_run 'tell application "Music" to next track'
  ;;

prev | previous | previous-track | previous_track)
  osascript_run 'tell application "Music" to previous track'
  ;;

vol_up | volume-up | volume_up)
  osascript_run "tell application \"Music\"
      set v to sound volume
      set nv to v + ${STEP}
      if nv > ${MAX_VOL} then set nv to ${MAX_VOL}
      set sound volume to nv
    end tell"
  ;;

vol_down | volume-down | volume_down)
  osascript_run "tell application \"Music\"
      set v to sound volume
      set nv to v - ${STEP}
      if nv < ${MIN_VOL} then set nv to ${MIN_VOL}
      set sound volume to nv
    end tell"
  ;;

-h | --help | help | "")
  usage
  exit 0
  ;;

*)
  echo "Unknown command: $CMD" >&2
  usage >&2
  exit 2
  ;;
esac
