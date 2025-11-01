#!/bin/bash

# Detectar ventana activa
win=$(hyprctl activewindow -j | jq -r '.address')

# Saber si está en flotante
is_floating=$(hyprctl activewindow -j | jq '.floating')

if [ "$is_floating" = "true" ]; then
    # Volver a modo tile (forzar no flotante)
    hyprctl dispatch togglefloating address:$win
else
    # Poner en flotante y redimensionar a 1/4 de la pantalla (960x540)
    hyprctl dispatch togglefloating address:$win
    hyprctl dispatch resizewindowpixel exact 960 540,address:$win
fi
