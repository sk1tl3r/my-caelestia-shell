#!/bin/sh
hyprctl keyword monitor HDMI-A-1,preferred,0x0,1 && \
sleep 1 && \
hyprctl keyword monitor HDMI-A-1,preferred,0x0,1
