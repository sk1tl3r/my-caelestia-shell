#!/bin/bash
if ! pgrep -x "elisa" > /dev/null; then
    elisa &
    sleep 0.5
fi
hyprctl dispatch togglespecialworkspace music