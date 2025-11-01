pragma ComponentBehavior: Bound

import QtQuick
import qs.components
import qs.services
import qs.config
import "../../../services"

// El icono de la barra, vinculado directamente al servicio nativo de Caelestia.
Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    MaterialIcon {
        anchors.centerIn: parent
        text: "coffee"
        font.pointSize: 16
        
        // El color se basa directamente en la propiedad 'enabled' del servicio nativo.
        color: IdleInhibitor.enabled ? Colours.palette.m3primary : Colours.palette.m3outline
    }
}
