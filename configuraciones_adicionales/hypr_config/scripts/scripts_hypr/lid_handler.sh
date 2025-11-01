#!/bin/bash

# Script para gestionar el evento de cierre de tapa con registro de depuración.
LOG_FILE="/tmp/lid_handler.log"

echo "--- Lid Handler Triggered: $(date) ---" >> $LOG_FILE

# Forzar la dirección del bus de sesión de DBUS. Este suele ser el culpable.
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
echo "DBUS_SESSION_BUS_ADDRESS is: $DBUS_SESSION_BUS_ADDRESS" >> $LOG_FILE

echo "Attempting to lock screen..." >> $LOG_FILE
quickshell ipc -c caelestia call lock lock
echo "Lock command sent. Waiting 2 seconds..." >> $LOG_FILE

sleep 2

echo "Attempting to suspend..." >> $LOG_FILE
systemctl suspend
echo "Suspend command sent. Script finished." >> $LOG_FILE
