pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import "../../Services"

Scope {
  id: root

  property bool isBorder: Quickshell.env("AROUND_BORDER") === "1"
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: "bar"

    function toggle(): void {
      GlobalState.isBarOpen = !GlobalState.isBarOpen
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData
      visible: GlobalState.isBarOpen

			WlrLayershell.layer: WlrLayer.Top
			WlrLayershell.namespace: "quickshell-bar"

      anchors { top: true; left: true; right: true }
      implicitHeight: 24
      color: Matugen.surface

      RowLayout {
        id: leftRow
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
          margins: root.isBorder ? 16 : 12
        }
        spacing: 12

        Text {
          id: logo

          text: "󰣇"
          color: Matugen.primary
          font: root.rootFont

          MouseArea {
            anchors.fill: parent
            onClicked: GlobalState.isStartMenuOpen = !GlobalState.isStartMenuOpen
          }
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
          margins: root.isBorder ? 16 : 12
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
