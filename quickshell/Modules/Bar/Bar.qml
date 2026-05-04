import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import qs.Colors
import qs.Modules.Widgets.Player
import qs.Modules.Widgets.Volume

Scope {
  id: bar

  property string fontFamily: "GeistMono Nerd Font"
  property int fontSize: 14
  Colors { id: colors }

  property string wifiStat: ""
  Process {
    id: wifiProc
    command: ["/bin/bash", "-c", "nmcli -t -f active,ssid,bars dev wifi | grep '^yes' | cut -d: -f2-"]
    stdout: SplitParser {
      onRead: data => {
        var parts = data.trim().split(':')
        var ssid = parts[0] ? parts[0] : "Not Connected"
        var str = parts.length > 1 ? parts[1] : ""

        var icon = "󰤟 "
        if (str.includes("▂▄▆█")) icon = "󰤨 "
        else if (str.includes("▂▄▆")) icon = "󰤥 "
        else if (str.includes("▂▄")) icon = "󰤢 "

        bar.wifiStat = icon + ssid
      }
    }
    Component.onCompleted: running = true
  }

  property string batteryStat: ""
  Process {
    id: batteryProc
    command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n 1) $(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n 1)"]
    stdout: SplitParser {
      onRead: data => {
        var parts = data.trim().split(" ");
        if (parts.length === 0 || parts[0] === "") return;

        var level = parseInt(parts[0]);
        var status = parts.length > 1 ? parts[1] : "";

        var icon = "󰁻 "
        if (status === "Charging") icon = "󰂄 "
        else if (level == 100) icon = "󰁹 "
        else if (level >= 80) icon = "󰂁 "
        else if (level >= 60) icon = "󰁿 "
        else if (level >= 40) icon = "󰁽 "

        bar.batteryStat = icon + level + "%";
      }
    }
    Component.onCompleted: running = true
  }

  PanelWindow {
    id: panel

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 24
    color: colors.background
    HyprlandWindow.opacity: 0.86

    // Menu button
    Text {
      id: menu

      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: 8
      text: "󰣇"
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily; bold: true }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
          if (mouse.button === Qt.LeftButton)
            rofiDrunProc.running = !rofiDrunProc.running
          else if (mouse.button === Qt.RightButton)
            rofiMenuProc.running = !rofiMenuProc.running
        } 
      }

      Process {
        id: rofiDrunProc
        command: ['sh', '-c', '~/dotfiles/scripts/rofilaunch.sh --drun']
      }

      Process {
        id: rofiMenuProc
        command: ['sh', '-c', '~/dotfiles/scripts/rofilaunch.sh --menu']
      }
    }

    // Workspace Switcher
    RowLayout {
      id: workspaceSwitcher

      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: menu.width + 16

      Repeater {
        model: 9

        Text {
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
          text: index + 1
          color: isActive ? colors.primary : colors.secondary
          font { pixelSize: bar.fontSize; family: bar.fontFamily; bold: isActive }

          MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("workspace " + (index + 1))
          }
        }
      }
    }

    // Music (Playerctl)
    Player {
      id: player

      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: menu.width + workspaceSwitcher.width + 32
    }

    // Window Title
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }
    }

    // Volume
    Volume { 
      id: volume 

      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: battery.width + clock.width + wifi.width + 48
    }

    // WiFi
    Text {
      id: wifi

      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: battery.width + clock.width + 32
      text: bar.wifiStat
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }

      Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifi.text = bar.wifiStat
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("exec kitty --class=nmtui -e nmtui")
      }
    }

    // Clock
    Text {
      id: clock

      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: battery.width + 16
      text: Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm:ss")
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }

      MouseArea {
        anchors.fill: parent
        onClicked: celendar.visible = !celendar.visible
      }

      PopupWindow {
        id: celendar
        property string calContent: ""

        anchor.window: panel
        anchor.rect.x: parentWindow.width
        anchor.rect.y: parentWindow.height + 4

        visible: false
        implicitWidth: 200
        implicitHeight: 160
        color: "transparent"
        HyprlandWindow.opacity: 0.86

        HyprlandFocusGrab {
          active: celendar.visible
          windows: [celendar]
          onCleared: {
            celendar.visible = false
          }
        }

        onVisibleChanged: {
          if (visible) {
            celendar.calContent = ""
            calProc.running = true
          }
        }

        Rectangle {
          anchors.fill: parent
          color: colors.background
          
          radius: 8
          border { color: colors.primary; width: 2 }

          Text {
            anchors.centerIn: parent
            text: celendar.calContent
            color: colors.primary
            font { pixelSize: bar.fontSize; family: bar.fontFamily }
          }

          Process {
            id: calProc
            command: ['cal']
            stdout: SplitParser {
              onRead: data => {
                var today = new Date().getDate().toString();
                var regex = new RegExp("(\\b|\\s)" + today + "(\\b|\\s)");
                var styledLine = data.replace(regex, "$1<u><b><font color='" + colors.primary + "'>" + today + "</font></b></u>$2");
                celendar.calContent += "<br>" + styledLine.replace(/ /g, "&nbsp;") 
              }
            }
          }
        }
      }
    }

    // Battery
    Text {
      id: battery

      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: 8
      text: bar.batteryStat
      color: colors.primary
      font { pixelSize: bar.fontSize; family: bar.fontFamily }

      Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: battery.text = bar.batteryStat
      }
    }
  }
}
