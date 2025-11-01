#!/bin/bash

# Dirección MAC de tus audífonos
DEVICE_MAC="6C:D3:EE:6C:EA:BB"
# Nombre del dispositivo para los mensajes (opcional)
DEVICE_NAME="Redmi Buds 4 Pro"

echo "Intentando conectar con $DEVICE_NAME ($DEVICE_MAC)..."

# Usamos un "here document" para pasar comandos a bluetoothctl
bluetoothctl <<EOF
power on
connect $DEVICE_MAC
quit
EOF

# Pequeña pausa para asegurar que el sistema de audio detecte el nuevo dispositivo
echo "Conexión enviada. Esperando a que el dispositivo de audio aparezca..."
sleep 2

# El nombre del "sink" de audio suele tener la MAC con guiones bajos
SINK_MAC_FORMAT=$(echo $DEVICE_MAC | tr ':' '_')

# Buscamos el nombre completo del sink de audio
SINK_NAME=$(pactl list sinks short | grep "$SINK_MAC_FORMAT" | awk '{print $2}')

if [ -n "$SINK_NAME" ]; then
    echo "Dispositivo de audio encontrado: $SINK_NAME"
    pactl set-default-sink "$SINK_NAME"
    echo "Salida de audio establecida como predeterminada."
else
    echo "ADVERTENCIA: No se pudo encontrar el dispositivo de audio (sink) automáticamente."
    echo "Es posible que necesites establecerlo manualmente con 'pactl set-default-sink <nombre>'."
fi

echo "Proceso finalizado."
