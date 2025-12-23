import qs.settings
import QtQuick
import QtQuick.Effects

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: 20
    blur: 0.9 * 10
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: Appearance.colors.colShadow
    cached: true
}
