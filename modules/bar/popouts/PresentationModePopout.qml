pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.components
import qs.components.controls
import qs.services
import qs.config
import "../../../services"

// El panel flotante, vinculado directamente al servicio nativo de Caelestia.
Item {
    id: root

    // Add padding around the layout to make the popout larger
    implicitWidth: layout.implicitWidth + (Appearance.padding.large * 2)
    implicitHeight: layout.implicitHeight + (Appearance.padding.large * 2)

    RowLayout {
        id: layout
        // Center the content within the newly padded space
        anchors.centerIn: parent
        spacing: Appearance.spacing.normal

        StyledText {
            text: "Presentation Mode"
            font.pointSize: Appearance.font.size.normal
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        StyledSwitch {
            id: modeSwitch
            
            // El estado del interruptor está vinculado directamente a la propiedad del servicio nativo.
            checked: IdleInhibitor.enabled

            // Al hacer clic, se alterna directamente el estado del servicio nativo.
            onClicked: {
                IdleInhibitor.enabled = !IdleInhibitor.enabled;
            }
        }
    }
}
