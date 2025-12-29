import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.services
import qs.settings
import qs.widgets

BarModule {
    id: clockContainer

    visible: SystemDetails.hasBattery
    Layout.alignment: Qt.AlignVCenter
    // Let the layout compute size automatically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect

        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius
        // Padding around the text
        implicitWidth: child.implicitWidth + Appearance.margin.large
        implicitHeight: child.implicitHeight + Appearance.margin.verysmall - 2
    }

    RowLayout {
        id: child

        anchors.centerIn: parent
        spacing: 8

        StyledText {
            animate: false
            text: SystemDetails.batteryPercent + "%"
        }

        CircularProgressBar {
            value: SystemDetails.batteryPercent / 100
            icon: {
                const b = SystemDetails.batteryPercent;
                if (b > 80)
                    return "battery_6_bar";

                if (b > 60)
                    return "battery_5_bar";

                if (b > 50)
                    return "battery_4_bar";

                if (b > 40)
                    return "battery_3_bar";

                if (b > 30)
                    return "battery_2_bar";

                if (b > 20)
                    return "battery_1_bar";

                if (b > 10)
                    return "battery_alert";

                return "battery_0_bar";
            }
            iconSize: 14
            Layout.bottomMargin: 2
        }

    }

}
