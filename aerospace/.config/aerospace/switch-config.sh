#!/bin/bash

conf_dst="$HOME/.config/aerospace/aerospace.toml"
conf_gaps="$HOME/.config/aerospace/aerospace-gaps.toml"
conf_nogaps="$HOME/.config/aerospace/aerospace-nogaps.toml"

if [ "$1" = "gaps" ]; then
  cp "$conf_gaps" "$conf_dst"
elif [ "$1" = "nogaps" ]; then
  cp "$conf_nogaps" "$conf_dst"
else
  echo "Usage: $0 {gaps|nogaps}"
  exit 1
fi

aerospace reload-config
