#!/bin/bash
if ! pgrep -x "qalculate-gtk" > /dev/null; then
    qalculate-gtk &
    sleep 0.5
fi
hyprctl dispatch togglespecialworkspace calc