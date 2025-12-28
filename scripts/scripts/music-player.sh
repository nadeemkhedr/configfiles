#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-}"
MUSIC_STEP="${MUSIC_VOL_STEP:-20}" # override: MUSIC_VOL_STEP=10 ./music-player.sh music_vol_up
SYS_STEP="${SYS_VOL_STEP:-20}"     # override: SYS_VOL_STEP=10 ./music-player.sh vol_up
MIN_VOL=0
MAX_VOL=100

usage() {
  cat <<'EOF'
Usage: music-player.sh <play-pause|next|prev|music_vol_up|music_vol_down|vol_up|vol_down>

Env:
  MUSIC_VOL_STEP   Music app volume step (0-100). Default: 20
  SYS_VOL_STEP     System volume step (0-100). Default: 5

Examples:
  ./music-player.sh play-pause
  ./music-player.sh next
  MUSIC_VOL_STEP=10 ./music-player.sh music_vol_down
  SYS_VOL_STEP=10 ./music-player.sh vol_up
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

music_vol_up | music-volume-up | music_volume_up)
  osascript_run "tell application \"Music\"
      set v to sound volume
      set nv to v + ${MUSIC_STEP}
      if nv > ${MAX_VOL} then set nv to ${MAX_VOL}
      set sound volume to nv
    end tell"
  ;;

music_vol_down | music-volume-down | music_volume_down)
  osascript_run "tell application \"Music\"
      set v to sound volume
      set nv to v - ${MUSIC_STEP}
      if nv < ${MIN_VOL} then set nv to ${MIN_VOL}
      set sound volume to nv
    end tell"
  ;;

vol_up | volume-up | volume_up)
  osascript_run "set v to output volume of (get volume settings)
    set nv to v + ${SYS_STEP}
    if nv > ${MAX_VOL} then set nv to ${MAX_VOL}
    set volume output volume nv"
  ;;

vol_down | volume-down | volume_down)
  osascript_run "set v to output volume of (get volume settings)
    set nv to v - ${SYS_STEP}
    if nv < ${MIN_VOL} then set nv to ${MIN_VOL}
    set volume output volume nv"
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
