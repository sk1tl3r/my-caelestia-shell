#!/bin/bash
# Script para mover ventanas flotantes en Hyprland con el cursor.
# Solo ejecuta 'movewindow' si la ventana activa es flotante.

if hyprctl activewindow -j | jq -e '.floating == true'; then
    hyprctl dispatch movewindow
fi
