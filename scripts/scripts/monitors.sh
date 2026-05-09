#!/usr/bin/env bash
set -euo pipefail

# CLI to switch monitor inputs across mixed-protocol displays.
# Dell (DDC) -> m1ddc on macOS, ddcutil on Linux.
# MSI -> msigd (custom fork: https://github.com/nadeemkhedr/msigd).
#
# Config: $HOME/.config/monitors/monitors.json.

CONFIG="${MONITORS_CONFIG:-$HOME/.config/monitors/monitors.json}"
OS="$(uname -s)"

print_usage() {
  cat <<EOF
Usage:
  monitors                                    List monitors + show this help
  monitors <monitor-alias> <input>            Switch monitor input (e.g. monitors top hdmi1)
  monitors go <action-alias>                  Run an action defined under Aliases
  monitors shutdown <action-alias> [delay]    Run action, wait [delay]s (default 2), then power off
  monitors list                               List monitors and action aliases

Inputs (DDC tools): hdmi1, hdmi2, hdmi3, dp1, dp2, usbc, vga, or raw number.
Inputs (msigd): passed through as-is to 'msigd --input'.

Action steps support:
  { "monitor": "<alias>", "input": "<input>" }                  Switch monitor input
  { "monitor": "<msi-alias>", "kvm": "<value>" }                Set msigd KVM (e.g. type_c, auto)
  { "monitor": "<msi-alias>", "kvm": "<v>", "input": "<i>" }    Batched into one msigd call (recommended)
EOF
}

print_example_config() {
  cat <<'EOF'
{
  "Monitors": {
    "Dell": {
      "tool": "m1ddc",
      "id": "REPLACE-WITH-UUID-FROM-`m1ddc display list`",
      "idDdcutil": "REPLACE-WITH-SERIAL-FROM-`ddcutil detect`",
      "alias": ["bottom", "ultrawide"]
    },
    "MSI": {
      "tool": "msigd",
      "alias": ["top", "gaming"]
    }
  },
  "Aliases": {
    "switch": [
      { "monitor": "top", "input": "hdmi1" }
    ]
  }
}
EOF
}

print_list() {
  jq -r '
    "Monitors:",
    (.Monitors | to_entries[] |
      "  " + .key
      + " [" + .value.tool + "]"
      + " aliases: " + ([.value.alias] | flatten | join(", "))),
    "",
    "Action aliases:",
    ((.Aliases // {}) | to_entries[] |
      "  " + .key + ": " +
      (.value | map(
        if .kvm then "\(.monitor) kvm \(.kvm)"
        else "\(.monitor) -> \(.input)"
        end
      ) | join("; ")))
  ' "$CONFIG"
}

if [[ ! -f "$CONFIG" ]]; then
  print_usage
  echo
  echo "No config found at: $CONFIG"
  echo "Create it with the following template:"
  echo
  print_example_config
  exit 1
fi

# VCP 0x60 input source codes used by m1ddc and ddcutil.
ddc_input_code() {
  local in
  in="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  case "$in" in
    hdmi1)               echo 17 ;;
    hdmi2)               echo 18 ;;
    hdmi3)               echo 19 ;;
    dp|dp1)              echo 15 ;;
    dp2)                 echo 16 ;;
    usbc|tb|thunderbolt) echo 27 ;;
    vga|vga1)            echo 1 ;;
    [0-9]*)              echo "$1" ;;
    *) echo "Unknown DDC input '$1' (try hdmi1, hdmi2, dp1, dp2, usbc)" >&2; return 1 ;;
  esac
}

find_monitor() {
  local alias="$1"
  jq -r --arg a "$alias" '
    .Monitors
    | to_entries[]
    | select(
        ([.value.alias] | flatten | map(ascii_downcase) | index($a | ascii_downcase))
        or (.key | ascii_downcase) == ($a | ascii_downcase)
      )
    | .key
  ' "$CONFIG" | head -n 1
}

monitor_field() {
  jq -r --arg k "$1" --arg f "$2" '.Monitors[$k][$f] // empty' "$CONFIG"
}

set_input() {
  local monitor_alias="$1" input="$2"
  local key tool id id_ddcutil code
  key="$(find_monitor "$monitor_alias")"
  if [[ -z "$key" ]]; then
    echo "No monitor matches alias '$monitor_alias'" >&2
    return 1
  fi
  tool="$(monitor_field "$key" tool)"
  id="$(monitor_field "$key" id)"
  id_ddcutil="$(monitor_field "$key" idDdcutil)"

  case "$tool" in
    m1ddc|ddc|ddcutil)
      code="$(ddc_input_code "$input")"
      if [[ "$OS" == "Darwin" ]]; then
        if [[ -n "$id" ]]; then
          m1ddc display "$id" set input "$code"
        else
          m1ddc set input "$code"
        fi
      else
        if [[ -n "$id_ddcutil" ]]; then
          ddcutil --sn "$id_ddcutil" setvcp 60 "$code"
        else
          ddcutil setvcp 60 "$code"
        fi
      fi
      ;;
    msigd)
      msigd --input "$input"
      ;;
    *)
      echo "Unknown tool '$tool' for monitor '$key'" >&2
      return 1
      ;;
  esac
  echo "Switched $key ($monitor_alias) -> $input"
}

set_kvm() {
  local monitor_alias="$1" kvm="$2"
  local key tool
  key="$(find_monitor "$monitor_alias")"
  if [[ -z "$key" ]]; then
    echo "No monitor matches alias '$monitor_alias'" >&2
    return 1
  fi
  tool="$(monitor_field "$key" tool)"
  if [[ "$tool" != "msigd" ]]; then
    echo "KVM only supported on msigd monitors (got '$tool' for '$key')" >&2
    return 1
  fi
  msigd --kvm "$kvm"
  echo "Set $key ($monitor_alias) KVM -> $kvm"
}

apply_step() {
  local monitor_alias="$1" input="$2" kvm="$3"
  local key tool rc=0
  key="$(find_monitor "$monitor_alias")"
  if [[ -z "$key" ]]; then
    echo "No monitor matches alias '$monitor_alias'" >&2
    return 1
  fi
  tool="$(monitor_field "$key" tool)"

  # msigd is flaky if --kvm and --input are sent as separate invocations
  # (KVM switch transiently disrupts the USB control channel). Batch them.
  if [[ "$tool" == "msigd" && -n "$kvm" && -n "$input" ]]; then
    if msigd --kvm "$kvm" --input "$input"; then
      echo "Set $key ($monitor_alias) KVM -> $kvm"
      echo "Switched $key ($monitor_alias) -> $input"
      return 0
    fi
    return 1
  fi
  if [[ -n "$kvm" ]]; then
    set_kvm "$monitor_alias" "$kvm" || rc=$?
  fi
  if [[ -n "$input" ]]; then
    set_input "$monitor_alias" "$input" || rc=$?
  fi
  return $rc
}

run_action() {
  local action="$1"
  local steps
  steps="$(jq -c --arg a "$action" '.Aliases[$a] // empty' "$CONFIG")"
  if [[ -z "$steps" || "$steps" == "null" ]]; then
    echo "No action alias '$action'" >&2
    return 1
  fi
  local monitor input kvm step rc=0
  while read -r step; do
    monitor="$(echo "$step" | jq -r '.monitor')"
    input="$(echo "$step" | jq -r '.input // empty')"
    kvm="$(echo "$step" | jq -r '.kvm // empty')"
    if ! apply_step "$monitor" "$input" "$kvm" </dev/null; then
      echo "Step failed (continuing): $step" >&2
      rc=1
    fi
  done < <(echo "$steps" | jq -c '.[]')
  return $rc
}

force_poweroff() {
  case "$OS" in
    Linux)
      # --force skips the graceful service-stop sequence and inhibitor checks
      # but still syncs and unmounts. Falls back to sudo if polkit denies.
      systemctl poweroff --force 2>/dev/null \
        || sudo systemctl poweroff --force
      ;;
    Darwin)
      osascript -e 'tell application "System Events" to shut down'
      ;;
    *)
      echo "Don't know how to power off on '$OS'" >&2
      return 1
      ;;
  esac
}

run_shutdown() {
  local action="$1"
  local delay="${2:-2}"
  run_action "$action"
  sleep "$delay"
  force_poweroff
}

case "${1:-}" in
  "")
    print_list
    echo
    print_usage
    ;;
  -h|--help|help)
    print_usage
    ;;
  list)
    print_list
    ;;
  go)
    [[ $# -lt 2 ]] && { echo "Usage: monitors go <action-alias>" >&2; exit 1; }
    run_action "$2"
    ;;
  shutdown)
    [[ $# -lt 2 ]] && { echo "Usage: monitors shutdown <action-alias> [delay-seconds]" >&2; exit 1; }
    run_shutdown "$2" "${3:-}"
    ;;
  *)
    [[ $# -lt 2 ]] && { print_usage; exit 1; }
    set_input "$1" "$2"
    ;;
esac
