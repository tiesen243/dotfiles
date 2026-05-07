pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import "../../Services"
import qs.Modules.StartMenu

Scope {
  id: root
  Colors { id: colors }
  property bool isOpen: true

  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: "bar"

    function toggle(): void {
      root.isOpen = !root.isOpen
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData
      visible: root.isOpen

      anchors { top: true; left: true; right: true }
      implicitHeight: 28
      color: "transparent"

      Rectangle {
        id: barContainer
        anchors.fill: parent
        color: colors.surface
        opacity: 0.8

        RowLayout {
          id: leftRow
          anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 8
          }
          spacing: 12

          StartMenu {
            id: startMenu
            rootFont: root.rootFont
            popupAnchor: bar
          }

          Workspace {
            id: workspace
            rootFont: root.rootFont
          }
        }

        WindowTitle {
          id: windowTitle
          rootFont: root.rootFont
          anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
          }
        }

        RowLayout {
          id: rightRow
          anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: 8
          }
          spacing: 12

          Tray {
            id: tray
            rootFont: root.rootFont
          }

          Time {
            id: time
            rootFont: root.rootFont
            popupAnchor: bar
          }

          Battery {
            id: battery
            rootFont: root.rootFont
          }
        }
      }
    }
  }
}
