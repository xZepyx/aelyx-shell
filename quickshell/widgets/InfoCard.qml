import qs.settings
import QtQuick
import QtQuick.Layouts

ContentRowCard {
    id: infoCard

    // --- Properties ---
    property string icon: "info"
    property color backgroundColor: Appearance.m3colors.darkMode ? Qt.lighter(Appearance.m3colors.m3error, 3.5) : Qt.lighter(Appearance.m3colors.m3error, 1)
    property color contentColor: Appearance.m3colors.m3onPrimary
    property string title: "Title"
    property string description: "Description"

    color: backgroundColor
    cardSpacing: 12   // nice spacing between elements

    RowLayout {
        id: mainLayout
        Layout.fillHeight: true 
        Layout.fillWidth: true
        
        spacing: 16
        Layout.alignment: Qt.AlignVCenter

        // --- Icon ---
        MaterialSymbol {
            id: infoIcon
            icon: infoCard.icon
            iconSize: 26
            color: contentColor
            Layout.alignment: Qt.AlignVCenter
        }

        // --- Text column ---
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            StyledText {
                text: infoCard.title
                font.bold: true
                color: contentColor
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            StyledText {
                text: infoCard.description
                color: contentColor
                font.pixelSize: 12
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }
    }
}
