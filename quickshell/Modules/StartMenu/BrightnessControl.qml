import Quickshell.Io

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
  id: brightnessControl

  anchors { left: parent.left; right: parent.right; margins: 12 }
  spacing: 8

  property int brightnessValue: 0
  Process {
    id: brightnessProc
    command: ["brightnessctl", "get"]
    stdout: SplitParser {
      onRead: data => brightnessControl.brightnessValue = parseInt(data.trim())
    }
    Component.onCompleted: running = true
  }

  Process { id: setBrightnessProc }

  Text {
    text: "󰃠 " + Math.round(brightnessControl.brightnessValue / 192)
    color: colors.primary
    font { pixelSize: startMenu.fontSize / 1.5; family: startMenu.fontFamily }
  }

  Slider {
    id: brightnessSlider
    Layout.fillWidth: true
    handle: Rectangle {
      x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
      y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
      width: 16
      height: 16
      radius: 8
      color: colors.primary
      border { color: colors.on_primary; width: 2 }
    }

    from: 0
    to: 100
    value: brightnessControl.brightnessValue / 192

    onValueChanged: {
      brightnessControl.brightnessValue = Math.round(brightnessSlider.value * 192)
      setBrightnessProc.command = ["brightnessctl", "set", brightnessControl.brightnessValue.toString()]
      setBrightnessProc.running = true
    }
  }
}
