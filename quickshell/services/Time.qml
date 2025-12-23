pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property alias date: clock.date  // expose raw date/time
    readonly property SystemClock clock: clock

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Helper function if you still want formatting ability:
    function format(fmt) {
        return Qt.formatDateTime(clock.date, fmt)
    }
}
