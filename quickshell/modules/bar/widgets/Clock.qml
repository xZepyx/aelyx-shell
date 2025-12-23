import qs.settings
import qs.widgets
import qs.modules.bar
import qs.services
import QtQuick
import QtQuick.Layouts

BarModule {
    id: clockContainer
    Layout.alignment: Qt.AlignVCenter

    property string format: "hh:mm AP"


    // Let the layout compute size automatically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

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
