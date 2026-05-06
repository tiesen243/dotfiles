import Quickshell.Hyprland
import Quickshell
import QtQuick.Layouts
import QtQuick

import qs.Colors

Scope {
  id: root
  Colors { id: colors }

  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true }
      implicitHeight: 28
      color: colors.surface
      HyprlandWindow.opacity: 0.8

      RowLayout {
        id: leftRow
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
          margins: 8
        }
        spacing: 12

        Workspace {
          id: workspace
          rootFont: root.rootFont
          anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
          }
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

        WiFi {
          id: wifi
          rootFont: root.rootFont
        }

        Clock {
          id: clock
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
