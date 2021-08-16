#!/usr/bin/env bash

if yabai -m query --windows --display 1 | jq -ec ' map(select(.visible == 1 and .floating == 0)) | length == 1' > /dev/null; then 
  yabai -m config left_padding 600
  yabai -m config right_padding 600
else
  yabai -m config left_padding 12
  yabai -m config right_padding 12
fi
