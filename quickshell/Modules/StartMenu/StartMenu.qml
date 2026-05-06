pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont
  property var popupAnchor
  property bool isOpen: false

  implicitWidth: startMenuTrigger.width
  implicitHeight: startMenuTrigger.height

  IpcHandler {
    target: "startMenu"

    function toggle(): void {
      root.isOpen = !root.isOpen
    }
  }

  Text {
    id: startMenuTrigger

    text: "󰣇"
    color: colors.primary
    font: root.rootFont

    MouseArea {
      anchors.fill: parent
      onClicked: root.isOpen = !root.isOpen
    }
  }

  PopupWindow {
    id: startMenuContainer
    visible: root.isOpen

    anchor.window: root.popupAnchor
    anchor.rect.x: 0
    anchor.rect.y: parentWindow.implicitHeight + 4
    implicitWidth: 1920 / 4
    implicitHeight: 1080 / 1.5
    color: "transparent"
    HyprlandWindow.opacity: 0.9

    HyprlandFocusGrab {
      active: startMenuContainer.visible
      windows: [startMenuContainer]
      onCleared: root.isOpen = false
    }

    Rectangle {
      id: startMenuContent

      anchors.fill: parent
      color: colors.surface
      radius: 8
      border { color: colors.on_primary; width: 2 }
      clip: true

      ColumnLayout {
        id: startMenuLayout
        anchors { fill: parent; margins: 16 }
        spacing: 12

        Clock {
          id: clock
          rootFont: root.rootFont
          isOpen: root.isOpen

          Layout.fillWidth: true
        }

        Buttons {
          id: buttons
          rootFont: root.rootFont

          Layout.fillWidth: true
        }

        PlayerControl {
          id: playerControl
          rootFont: root.rootFont

          Layout.fillWidth: true
        }

        VolumeControl {
          id: volumeControl
          rootFont: root.rootFont

          Layout.fillWidth: true
        }

        BrightnessControl {
          id: brightnessControl
          rootFont: root.rootFont

          Layout.fillWidth: true
        }

        Notification {
          id: notification
          rootFont: root.rootFont

          Layout.fillWidth: true
          Layout.fillHeight: true
        }

        Footer {
          id: footer
          rootFont: root.rootFont

          Layout.fillWidth: true
        }
      }
    }
  }
}
