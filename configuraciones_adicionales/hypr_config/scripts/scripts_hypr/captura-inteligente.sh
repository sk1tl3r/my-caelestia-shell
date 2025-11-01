#!/bin/bash
# SCRIPT DE CAPTURA "TODO EN UNO" (v10 - Final Definitivo)
# Usa swappy como visor temporal para el modo con retraso.

# --- Requisitos ---
# jq, grim, slurp, wofi, swappy

# --- Configuración ---
SAVE_DIR="$HOME/Imágenes/screenshots"
WOFI_STYLE="$HOME/.config/rofi/screenshot-menu.css"
BORDER_COLOR="cba6f7ff"
SELECTION_COLOR="00000000"
BORDER_SIZE=3

# --- Lógica del Script ---

# Crear archivos temporales y programar su borrado al salir.
TMP_FULL=$(mktemp /tmp/capture_full.XXXXXX.png)
TMP_CROP=$(mktemp /tmp/capture_crop.XXXXXX.png)
trap 'rm -f "$TMP_FULL" "$TMP_CROP"' EXIT

# 1. MENÚ PRINCIPAL: Elegir el MODO de captura.
CAPTURE_MODE=$(printf "Capturar Región o Ventana\nCapturar Pantalla Completa\nCapturar con Retraso (3s)" | wofi --dmenu --style "$WOFI_STYLE" --prompt="Selecciona el modo de captura:")

if [ -z "$CAPTURE_MODE" ]; then
    exit 0
fi

CAPTURE_SUCCESSFUL=false

# 2. Actuar según el modo elegido.
case "$CAPTURE_MODE" in
    "Capturar con Retraso (3s)")
        notify-send -t 2500 "Iniciando captura en 3 segundos..." "Prepara el menú que quieres capturar."
        sleep 3
        FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
        if [ -z "$FOCUSED_MONITOR" ]; then notify-send -u critical "Error" "No se pudo detectar el monitor."; exit 1; fi

        if ! grim -o "$FOCUSED_MONITOR" "$TMP_FULL"; then notify-send -u critical "Error" "Falló la captura con grim."; exit 1; fi

        # Usar swappy como visor temporal en segundo plano.
        swappy -f "$TMP_FULL" &
        VIEWER_PID=$!
        # Usar slurp para seleccionar una región sobre el visor.
        CROP_GEOMETRY=$(slurp)
        # Matar el visor una vez se ha hecho la selección.
        kill $VIEWER_PID

        if [ -z "$CROP_GEOMETRY" ]; then exit 0; fi

        # Usar grim para recortar la imagen original y guardarla en el archivo de recorte temporal.
        if cat "$TMP_FULL" | grim -g "$CROP_GEOMETRY" - > "$TMP_CROP"; then
            CAPTURE_SUCCESSFUL=true
        else
            notify-send -u critical "Error" "Falló el recorte de la imagen."
            exit 1
        fi
        ;; 

    "Capturar Región o Ventana")
        GEOMETRY=$(hyprctl clients -j | jq -r '.[] | select(.size[0] > 0 and .size[1] > 0 and .title != "") | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp -b $BORDER_COLOR -c $SELECTION_COLOR -w $BORDER_SIZE)
        if [ -n "$GEOMETRY" ] && grim -g "$GEOMETRY" "$TMP_CROP"; then CAPTURE_SUCCESSFUL=true; fi
        ;; 

    "Capturar Pantalla Completa")
        sleep 1 # Añadir un retraso de 1 segundo
        GEOMETRY=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.x),\(.y) \(.width)x\(.height)"')
        if [ -n "$GEOMETRY" ] && grim -g "$GEOMETRY" "$TMP_CROP"; then CAPTURE_SUCCESSFUL=true; fi
        ;; 
esac

# 3. Si la captura (de cualquier modo) fue exitosa, mostrar menú de destino.
if [ "$CAPTURE_SUCCESSFUL" = true ]; then
    CHOICE=$(printf "Copiar al portapapeles\nGuardar en archivo\nCopiar y Guardar" | wofi --dmenu --style "$WOFI_STYLE" --prompt="¿Qué hacer con la captura?")

    case "$CHOICE" in
        "Copiar al portapapeles")
            wl-copy < "$TMP_CROP"
            notify-send "Captura Inteligente" "Copiado al portapapeles." -i flameshot
            ;; 
        "Guardar en archivo")
            mkdir -p "$SAVE_DIR"
            FINAL_PATH="$SAVE_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"
            mv "$TMP_CROP" "$FINAL_PATH"
            notify-send -a "screenshot-tool" -h string:desktop-entry:gemini-open-screenshots "Captura Guardada" "Haz clic para abrir la carpeta." -i flameshot
            ;; 
        "Copiar y Guardar")
            mkdir -p "$SAVE_DIR"
            FINAL_PATH="$SAVE_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"
            cp "$TMP_CROP" "$FINAL_PATH"
            wl-copy < "$TMP_CROP"
            notify-send -a "screenshot-tool" -h string:desktop-entry:gemini-open-screenshots "Copiado y Guardado" "Haz clic para abrir la carpeta." -i flameshot
            ;; 
    esac
fi