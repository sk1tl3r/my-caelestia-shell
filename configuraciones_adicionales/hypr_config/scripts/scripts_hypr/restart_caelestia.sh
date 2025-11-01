#!/bin/sh

# Usar el comando nativo de Quickshell con su ruta absoluta para asegurar un cierre limpio
/usr/bin/quickshell kill -c caelestia

# Añadimos una pequeña pausa para extra seguridad contra condiciones de carrera
sleep 0.5

# Lanzar la nueva instancia usando su ruta absoluta
/usr/bin/caelestia shell -d