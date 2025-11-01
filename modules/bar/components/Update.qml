
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell // Para usar Quickshell.execDetached
import qs.components
import qs.config
import qs.services

// Versión final y simplificada. Icono estático con acción de clic.
Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    MaterialIcon {
        anchors.centerIn: parent
        text: "sync" // Icono 󰊵
        font.pointSize: 16
        color: Colours.palette.m3primary
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // Llama al script interactivo en una nueva terminal
            const command = "/home/sk1t/.config/hypr/scripts/scripts_hypr/caelestia-update-check.sh"
            Quickshell.execDetached(["kitty", "--title", "System Update", command])
        }
    }
}
