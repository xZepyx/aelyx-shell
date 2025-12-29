import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.services
import qs.settings
import qs.widgets

BarModule {
    id: clockContainer

    property string format: "hh:mm • dd/MM"

    Layout.alignment: Qt.AlignVCenter
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    // Let the layout compute size automatically

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        // Padding around the text
        implicitWidth: textItem.implicitWidth + Appearance.margin.large
        implicitHeight: textItem.implicitHeight + Appearance.margin.small
    }

    StyledText {
        id: textItem

        anchors.centerIn: parent
        animate: false
        text: Time.format(clockContainer.format)
    }

}
