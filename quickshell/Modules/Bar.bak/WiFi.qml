import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import QtQuick

Item {
  id: wifi

  property string stat: ""
  Process {
    id: wifiProc
    command: ["/bin/bash", "-c", "nmcli -t -f active,rate,bars dev wifi | grep '^yes' | cut -d: -f2-"]
    stdout: SplitParser {
      onRead: data => {
        var parts = data.trim().split(':')
        var speed = parts[0] ? parts[0] : "Not Connected"
        var str = parts.length > 1 ? parts[1] : ""

        var icon = "󰤟 "
        if (str.includes("▂▄▆█")) icon = "󰤨 "
        else if (str.includes("▂▄▆")) icon = "󰤥 "
        else if (str.includes("▂▄")) icon = "󰤢 "

        wifi.stat = icon + speed
      }
    }
    Component.onCompleted: running = true
  }

  Text {
    id: wifiContent

    anchors { right: parent.right; verticalCenter: parent.verticalCenter }
    text: wifi.stat
    color: colors.primary
    font { pixelSize: bar.fontSize; family: bar.fontFamily }

    Timer {
      interval: 10 * 1000
      running: true
      repeat: true
      onTriggered: wifiContent.text = wifi.stat
    }

    MouseArea {
      anchors.fill: parent
      onClicked: Hyprland.dispatch("exec kitty --class=nmtui -e nmtui")
    }
  }
}
