import Quickshell.Io
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  property int level: 0
  property bool isCharging: false
  property string icon: "󰁺"

  implicitWidth: battery.width

  Process {
    id: batteryProc
    command: ["sh", "-c", "printf '%s\\n%s' \"$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo '99')\" \"$(cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo 'Discharging')\""]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        const level = parseInt(lines[0]) || 0
        const status = (lines[1] || "Discharging").trim()

        root.level = level
        root.isCharging = status === "Charging"

        if (status === "Charging") root.icon = "󰂄"
        else if (level >= 90) root.icon = "󰁹"
        else if (level >= 80) root.icon = "󰂂"
        else if (level >= 70) root.icon = "󰂁"
        else if (level >= 60) root.icon = "󰂀"
        else if (level >= 50) root.icon = "󰁿"
        else if (level >= 40) root.icon = "󰁾"
        else if (level >= 30) root.icon = "󰁽"
        else if (level >= 20) root.icon = "󰁼"
        else if (level >= 10) root.icon = "󰁻"
        else root.icon = "󰁺"
      }
    }
    Component.onCompleted: running = true
  }

  Text {
    id: battery
    Accessible.role: Accessible.StaticText
    Accessible.name: "Battery level: " + root.level + (root.isCharging ? ", charging" : ", discharging")

    anchors.centerIn: parent
    text: root.icon + " " + root.level + "%"
    color: colors.primary
    font: rootFont
  }

  Timer {
    interval: 10 * 1000
    running: true
    repeat: true
    onTriggered: batteryProc.running = true
  }
}
