#!/bin/bash
# Script para mostrar un icono de bandeja para el modo presentación usando yad

# Asegurarse de que no haya otra instancia corriendo
pkill -f "yad.*presentation_mode"

# Comando que se ejecuta al hacer clic en el icono
CLICK_ACTION="/home/sk1t/.config/hypr/scripts/scripts_hypr/toggle_presentation_mode.sh"

# Función para actualizar el icono
update_icon() {
    while true; do
        # Busca si el modo presentación está activo
        INHIBIT_PROCESS=$(pgrep -f "systemd-inhibit.*sleep infinity")

        if [ -n "$INHIBIT_PROCESS" ]; then
            # Modo ACTIVO: icono de "cancelar", tooltip informativo
            echo "icon:cancel"
            echo "tooltip:Modo Presentación: Activado (No se bloqueará)"
        else
            # Modo INACTIVO: icono de "display", tooltip informativo
            echo "icon:video-display"
            echo "tooltip:Modo Presentación: Desactivado (Bloqueo normal)"
        fi

        # Espera 2 segundos antes de volver a comprobar
        sleep 2
    done
}

# Iniciar el proceso que actualiza el icono en segundo plano
update_icon &

# Iniciar el icono de la bandeja con yad leyendo del proceso
# yad --notification-icon permite crear un icono en la bandeja del sistema
# --command ejecuta el script al hacer clic
# --listen actualiza el icono dinámicamente
yad --notification-icon="video-display" --command="$CLICK_ACTION" --listen < <(update_icon)

# Mantener el script corriendo para que el icono persista
wait
