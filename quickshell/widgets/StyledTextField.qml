pragma ComponentBehavior: Bound

import qs.settings
import QtQuick
import QtQuick.Controls

TextField {
  placeholderTextColor: Appearance.syntaxHighlightingTheme
  font.family: Appearance.font.family.main
  color: Appearance.syntaxHighlightingTheme

  // from github.com/yannpelletier/twinshell with modifications

  cursorDelegate: StyledRect {
    id: cursor

    property bool disableBlink

    implicitWidth: 2
    color: Appearance.m3colors.m3primary
    radius: Appearance.rounding.normal
    onXChanged: {
      opacity = 1;
      disableBlink = true;
      enableBlink.start();
    }

    Timer {
      id: enableBlink

      interval: 100
      onTriggered: cursor.disableBlink = false
    }

    Behavior on opacity {
      NumberAnimation {
        duration: Appearance.animation.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
      }
    }
  }

  Behavior on color {
    ColorAnimation {
      duration: Appearance.animation.durations.normal
      easing.type: Easing.BezierSpline
      easing.bezierCurve: Appearance.animation.curves.standard
    }
  }

  Behavior on placeholderTextColor {
    ColorAnimation {
      duration: Appearance.animation.durations.normal
      easing.type: Easing.BezierSpline
      easing.bezierCurve: Appearance.animation.curves.standard
    }
  }
}