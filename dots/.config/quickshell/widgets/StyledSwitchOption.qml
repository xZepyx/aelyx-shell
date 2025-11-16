import qs.config
import Quickshell
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: main
    property string title: "Title"
    property string description: "Description"
    property string prefField: ''

    ColumnLayout {
        StyledText { text: main.title; font.pixelSize: 16;  }
        StyledText { text: main.description; font.pixelSize: 12; }
    }
    Item { Layout.fillWidth: true }
    StyledSwitch {
        checked: Config.options[main.prefField.split('.')[0]][main.prefField.split('.')[1]]
        onToggled: {
            Config.setNestedValue(main.prefField, checked)
        }
    }
}