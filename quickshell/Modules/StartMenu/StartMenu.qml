pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import '../../Services'

Item {
  id: root
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
    color: Matugen.primary
    font: root.rootFont

    MouseArea {
      anchors.fill: parent
      onClicked: GlobalState.isStartMenuOpen = !GlobalState.isStartMenuOpen
    }
  }

  PopupWindow {
    id: startMenuContainer
    visible: GlobalState.isStartMenuOpen || startMenuContent.opacity > 0

    anchor.window: root.popupAnchor
    anchor.rect.x: 8
    anchor.rect.y: parentWindow.implicitHeight
    implicitWidth: 1920 / 4
    implicitHeight: 1080 / 2
    color: "transparent"

    HyprlandFocusGrab {
      active: startMenuContainer.visible && !BackgroundService.isOpen
      windows: [startMenuContainer]
      onCleared: GlobalState.isStartMenuOpen = false
    }

    Shortcut {
      sequence: "Escape"
      onActivated: GlobalState.isStartMenuOpen = false
    }

    Rectangle {
      id: startMenuContent

      implicitWidth: parent.width
      implicitHeight: parent.height
      color: Matugen.surface
      bottomRightRadius: 12
      clip: true

      opacity: GlobalState.isStartMenuOpen ? 1 : 0
      Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
      }
      y: GlobalState.isStartMenuOpen ? 0 : -implicitHeight
      Behavior on y {
        NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
      }

      ColumnLayout {
        id: startMenuLayout
        anchors { fill: parent; margins: 16 }
        spacing: 12

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
