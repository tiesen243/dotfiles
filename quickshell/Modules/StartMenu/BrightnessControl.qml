import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitHeight: brightnessControl.implicitHeight

  RowLayout {
    id: brightnessControl

    anchors.fill: parent
    spacing: 12

    Text {
      id: brightnessValue
      Accessible.role: Accessible.StaticText
      Accessible.name: "Brightness Value: " + BrightnessService.value + "%"

      text: BrightnessService.getIcon() + " " + BrightnessService.value.toString().padStart(2, '0')
      color: colors.primary
      font: root.rootFont
    }

    Slider {
      id: brightnessSlider
      Accessible.role: Accessible.Slider
      Accessible.name: "Brightness Level"

      Layout.fillWidth: true
      from: 0
      to: 100
      value: BrightnessService.value

      background: Rectangle {
        anchors.fill: parent
        color: colors.surface_variant
        radius: height / 2
      }

      handle: Rectangle {
        x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: brightnessSlider.pressed ? colors.primary_container : colors.primary
        border { color: colors.primary_fixed; width: 1 }
      }

      onMoved: BrightnessService.set(value)
    }
  }
}
