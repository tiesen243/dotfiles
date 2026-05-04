import QtQuick

import Quickshell
import Quickshell.Hyprland

import qs.Colors

Scope {
  id: sidebar

  property string fontFamily: "GeistMono Nerd Font"
  property int fontSize: 14
  Colors { id: colors }

  PanelWindow {
    id: sidePanel
    anchors.left: true
    anchors.top: true
    anchors.bottom: true
    implicitWidth: 64
    color: colors.background
    HyprlandWindow.opacity: 0.8

    Column {
      anchors.fill: parent
      spacing: 12
      anchors.margins: 28

      Repeater {
        model: [
          { icon: "", cmd: "kitty" },
          { icon: "", cmd: "zen-browser" },
          { icon: "", cmd: "thunar" },
          { icon: "", cmd: "kitty --class=btop -e btop" },
          { icon: "󰈪", cmd: "localsend" },
          { icon: "󰍘", cmd: "obs" },
          { icon: "", cmd: "code" }
        ]

        Rectangle {
          implicitWidth: 40
          implicitHeight: 40
          anchors.horizontalCenter: parent.horizontalCenter
          color: colors.on_primary
          radius: 8
          
          Text {
            anchors.centerIn: parent
            text: modelData.icon
            font { pixelSize: sidebar.fontSize; family: sidebar.fontFamily }
            color: colors.primary
          }

          MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("exec " + modelData.cmd)
          }
        }
      }
    }
  }
}
