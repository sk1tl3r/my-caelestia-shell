#!/usr/bin/env bash

# caelestia-update-check.sh (versión final, con lista de paquetes)

# --- Comandos ---
CHECKUPDATES_CMD="/usr/bin/checkupdates"
YAY_CMD="/usr/bin/yay"

echo "Buscando actualizaciones..."

# --- Obtener listas de paquetes ---
official_list=$($CHECKUPDATES_CMD)
aur_list=$($YAY_CMD -Qua)

if pacman -Qi flatpak &>/dev/null; then
  flatpak_list=$(flatpak remote-ls --updates)
else
  flatpak_list=""
fi

# --- Obtener contadores desde las listas ---
official_updates=$(echo "$official_list" | grep -c '^')
aur_updates=$(echo "$aur_list" | grep -c '^')
flatpak_updates=$(echo "$flatpak_list" | grep -c '^')

total_updates=$((official_updates + aur_updates + flatpak_updates))

# --- Lógica de Terminal ---
printf "\n--- RESUMEN ---
"
printf "Repositorios Oficiales: %s\n" "$official_updates"
printf "AUR (yay):              %s\n" "$aur_updates"
printf "Flatpak:                %s\n" "$flatpak_updates"
printf "%s\n" "------------------------------------"
printf "Total:                  %s\n" "$total_updates"

if [ "$total_updates" -gt 0 ]; then
    printf "\n--- DETALLES DE PAQUETES ---
"
    if [ "$official_updates" -gt 0 ]; then
        printf "\n[ Oficiales ]\n%s\n" "$official_list"
    fi
    if [ "$aur_updates" -gt 0 ]; then
        printf "\n[ AUR ]\n%s\n" "$aur_list"
    fi
    if [ "$flatpak_updates" -gt 0 ]; then
        printf "\n[ Flatpak ]\n%s\n" "$flatpak_list"
    fi
    
    printf "\n"
    read -p "¿Proceder con la actualización? (s/N) " choice
    printf "\n"
    case "$choice" in
      s|S|y|Y )
        printf "Iniciando actualización...\n"
        $YAY_CMD -Syu && flatpak update
        ;;
      * )
        printf "Actualización cancelada.\n"
        ;;
    esac
else
    printf "\nEl sistema ya está actualizado.\n"
fi

# --- Bucle para mantener la ventana abierta ---
printf "\n"
read -n 1 -s -r -p "Presiona cualquier tecla para cerrar la ventana..."