import Quickshell.Io
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  property string info: ""
  property string type: ""
  property string icon: ""

  implicitWidth: wifi.width

  Text {
    id: wifi
    Accessible.role: Accessible.StaticText
    Accessible.name: {
      if (root.type === "ethernet") return "Connected to Ethernet"
      else if (root.type === "wifi") return "Connected to Wi-Fi network: " + root.info
      else return "Not connected to any network"
    }

    anchors.centerIn: parent
    text: root.icon
    color: colors.primary
    font: rootFont

    MouseArea {
      anchors.fill: parent
      onClicked: nmtuiProc.running = !nmtuiProc.running
    }
  }

  Process {
    id: wifiProc
    command: ["sh", "-c", "eth=$(nmcli -t -f type,state dev 2>/dev/null | grep '^ethernet:connected'); if [ -n \"$eth\" ]; then echo 'ethernet:Ethernet'; else wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2); if [ -n \"$wifi\" ]; then echo \"wifi:$wifi\"; else echo 'disconnected:'; fi; fi"]
    stdout: StdioCollector {
      onStreamFinished: {
        const output = text.trim()

        const colonIdx = output.indexOf(':')
        const type = output.substring(0, colonIdx)
        const info = output.substring(colonIdx + 1)

        root.type = type
        root.info = info || "Disconnected"
        root.icon = type === "ethernet" ? "󰈀" : type === "wifi" ? "󰖩" : "󰖪"
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: nmtuiProc
    command: ["kitty", "--class=nmtui", "-e", "nmtui"]
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: wifiProc.running = true
  }
}
