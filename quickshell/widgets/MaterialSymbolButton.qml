import qs.settings
import QtQuick

MaterialSymbol {
    id: root

    // Renamed signals (no collisions possible)
    signal buttonClicked
    signal buttonEntered
    signal buttonExited
    signal buttonPressAndHold
    signal buttonPressedChanged(bool pressed)

    // Expose mouse props
    property alias enabled: ma.enabled
    property alias hoverEnabled: ma.hoverEnabled
    property alias pressed: ma.pressed

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.buttonClicked()
        onEntered: root.buttonEntered()
        onExited: root.buttonExited()
        onPressAndHold: root.buttonPressAndHold()
        onPressedChanged: root.buttonPressedChanged(pressed)
    }
}
