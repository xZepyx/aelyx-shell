import qs.settings
import QtQuick
import QtQuick.Layouts

Item {
    id: contentMenu
    Layout.fillWidth: true
    Layout.fillHeight: true


    opacity: visible ? 1 : 0
    scale: visible ? 1 : 0.95

    Behavior on opacity {
        NumberAnimation {
            duration: Appearance.animation.durations.normal
            easing.type: Appearance.animation.curves.standard[0] // using standard easing
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Appearance.animation.durations.normal
            easing.type: Appearance.animation.curves.standard[0]
        }
    }

    property string title: "Settings"
    property string description: ""
    default property alias content: stackedSections.data

    Item {
        id: headerArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: Appearance.margin.verylarge
        anchors.leftMargin: Appearance.margin.verylarge
        anchors.rightMargin: Appearance.margin.verylarge
        width: parent.width

        ColumnLayout {
            id: headerContent
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Appearance.margin.small

            ColumnLayout {
                StyledText {
                    text: contentMenu.title
                    font.pixelSize: Appearance.font.size.huge
                    font.bold: true
                    font.family: Appearance.font.family.title
                }
                StyledText {
                    text: contentMenu.description
                    font.pixelSize: Appearance.font.size.small
                }
            }

            Rectangle {
                id: hr
                Layout.alignment: Qt.AlignLeft | Qt.AlignRight
                implicitHeight: 1
            }
        }

        height: headerContent.implicitHeight
    }

    Flickable {
        id: mainScroll
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: Appearance.margin.verylarge
        anchors.rightMargin: Appearance.margin.verylarge
        anchors.topMargin: Appearance.margin.normal
        clip: true
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        contentHeight: mainContent.childrenRect.height + Appearance.margin.small
        contentWidth: width

        Item {
            id: mainContent
            width: mainScroll.width
            height: mainContent.childrenRect.height

            Column {
                id: stackedSections
                width: Math.min(mainScroll.width, 1000)
                x: (mainContent.width - width) / 2
                spacing: Appearance.margin.normal
            }
        }
    }
}