import qs.settings
import QtQuick

Rectangle {
  id: root

  Behavior on color {
    ColorAnimation {
      duration: 600
      easing.type: Easing.BezierSpline
      easing.bezierCurve: Appearance.animation.curves.standard
    }
  }
}