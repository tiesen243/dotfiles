pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import qs.Colors
import '../../Services'

Item {
  id: root
  Colors { id: colors }
  property font rootFont
  property var popupAnchor

  implicitWidth: startMenuTrigger.width
  implicitHeight: startMenuTrigger.height

  IpcHandler {
    target: "startMenu"

    function toggle(): void {
      GlobalState.closeAllPopups("startmenu")
      GlobalState.isStartMenuOpen = !GlobalState.isStartMenuOpen
    }
  }

  Text {
    id: startMenuTrigger

    text: "󰣇"
    color: colors.primary
    font: root.rootFont

    MouseArea {
      anchors.fill: parent
      onClicked: GlobalState.isStartMenuOpen = !GlobalState.isStartMenuOpen
    }
  }

  PopupWindow {
    id: startMenuContainer
    visible: GlobalState.isStartMenuOpen

    anchor.window: root.popupAnchor
    anchor.rect.x: 0
    anchor.rect.y: parentWindow.implicitHeight + 4
    implicitWidth: 1920 / 4
    implicitHeight: 1080 / 2
    color: "transparent"

    HyprlandFocusGrab {
      active: startMenuContainer.visible
      windows: [startMenuContainer]
      onCleared: root.isOpen = false
    }

    Shortcut {
      sequence: "Escape"
      onActivated: root.isOpen = false
    }

    Rectangle {
      id: startMenuContent

      anchors.fill: parent
      color: colors.surface
      radius: 12
      border { color: colors.on_primary; width: 2 }
      clip: true

      ColumnLayout {
        id: startMenuLayout
        anchors { fill: parent; margins: 16 }
        spacing: 12

        Buttons {
          id: buttons
          rootFont: root.rootFont
          isOpen: GlobalState.isStartMenuOpen

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
