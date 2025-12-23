import qs.settings
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
        // Safely resolve nested key (e.g. "background.showClock" or "bar.modules.some.setting")
        checked: {
            if (!main.prefField) return false;
            var parts = main.prefField.split('.');
            var cur = Shell.flags;
            for (var i = 0; i < parts.length; ++i) {
                if (cur === undefined || cur === null) return false;
                cur = cur[parts[i]];
            }
            // If the config value is undefined, default to false
            return cur === undefined || cur === null ? false : cur;
        }

        onToggled: {
            // Persist change (setNestedValue will create missing objects)
            Shell.setNestedValue(main.prefField, checked);
        }
    }
}