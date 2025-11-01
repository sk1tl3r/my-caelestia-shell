#!/bin/bash

MODE=$1 # Acepta "extend" o "external_only" como argumento

if [ "$MODE" == "extend" ]; then
    # ACCIÓN: Activar modo extendido
    hyprctl keyword monitor "eDP-1,preferred,1920x0,1"
    hyprctl keyword monitor "HDMI-A-1,preferred,0x0,1"
    
    # Reiniciar UI para modo extendido
   # sleep 1
   # killall -w waybar
   # killall nwg-dock-hyprland &>/dev/null
   #waybar &
    # Iniciar dock en el monitor interno (ID 0)
    #nwg-dock-hyprland -i 20 -w 5 -mt 0 -x -c "nwg-drawer" &

elif [ "$MODE" == "external_only" ]; then
    # ACCIÓN: Activar modo solo externo
    hyprctl keyword monitor "eDP-1,disable"
    
    # Reiniciar UI para modo solo externo
   # sleep 1
   # killall -w waybar
   # killall nwg-dock-hyprland &>/dev/null
    #waybar &
    # Iniciar dock en el monitor externo (ID 1)
    #nwg-dock-hyprland -i 20 -w 5 -mt 1 -x -c "nwg-drawer" &
fi
