import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitHeight: brightnessControl.implicitHeight

  property int value: 0
  property int maxBrightness: 1

  RowLayout {
    id: brightnessControl

    anchors.fill: parent
    spacing: 12

    Text {
      id: brightnessValue
      Accessible.role: Accessible.StaticText
      Accessible.name: "Brightness Value: " + root.value + "%"

      text: "󰃟 " + root.value
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
      value: root.value

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

      onMoved: {
        brightnessSetProc.command = ["brightnessctl", "set", Math.round(value) + "%"]
        brightnessSetProc.running = true
      }
    }
  }

  FileView {
    id: brightnessFile
    path: ""
    watchChanges: true
    onFileChanged: brightnessGetProc.running = true
  }

  Process {
    id: brightnessGetProc
    command: ["brightnessctl", "get"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseInt(text.trim())
        if (!isNaN(val) && root.maxBrightness > 0)
          root.value = (val / root.maxBrightness) * 100
      }
    }
  }

  Process {
    id: brightnessSetProc
    command: []
  }

  Process {
    id: backlightDiscovery
    command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo $p && cat ${p%brightness}max_brightness"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        if (lines.length >= 2) {
          const max = parseInt(lines[1])
          if (!isNaN(max) && max > 0) root.maxBrightness = max
          brightnessFile.path = lines[0]
          brightnessGetProc.running = true
        }
      }
    }
  }
}
