#!/bin/bash
# Wrapper for swappy to send a notification after it closes.

/usr/bin/swappy -f "$1"

# After swappy closes, send a notification.
# The body contains a file URL, which many notification daemons
# (including mako, hopefully) will make clickable.
notify-send "CAPTURA PROCESADA" -a "screenshot-tool" -i "camera-photo"