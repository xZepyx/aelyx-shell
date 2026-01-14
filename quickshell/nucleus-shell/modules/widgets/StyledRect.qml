import qs.config
import QtQuick

Rectangle {
  id: root

  Behavior on color {
    enabled: Config.runtime.appearance.animations.enabled
    ColorAnimation {
      duration: 600
      easing.type: Easing.BezierSpline
      easing.bezierCurve: Appearance.animation.curves.standard
    }
  }
}