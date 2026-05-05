import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import QtQuick

import qs.Colors

Item {
  id: startMenu
  property string fontFamily
  property int fontSize
  property var anchor

  Colors { id: colors }

  anchors.verticalCenter: parent.verticalCenter
  anchors.left: parent.left
  anchors.margins: 8

  implicitWidth: startMenuTrigger.width
  implicitHeight: startMenuTrigger.height

  IpcHandler {
    target: "startMenu"

    function toggle(): void {
      startMenuContent.visible = !startMenuContent.visible
    }
  }

  Text {
    id: startMenuTrigger

    text: "󰣇"
    color: colors.primary
    font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily }

    MouseArea {
      anchors.fill: parent
      onClicked: mouse => {
        startMenuContent.visible = !startMenuContent.visible
      }
    }
  }

  PopupWindow {
    id: startMenuContent
    visible: false

    anchor.window: startMenu.anchor
    anchor.rect.x: 0
    anchor.rect.y: parentWindow.implicitHeight + 4

    implicitWidth: 1920 / 4
    implicitHeight: 1080 / 2
    color: "transparent"

    HyprlandFocusGrab {
      active: startMenuContent.visible
      windows: [startMenuContent]
      onCleared: {
        startMenuContent.visible = false
      }
    }

    Rectangle {
      anchors.fill: parent
      color: colors.background
      radius: 8
      border { color: colors.primary; width: 1 }

      Text {
        id: clock
        anchors { top: parent.top; left: parent.left; margins: 12 }
        text: Qt.formatDateTime(new Date(), "hh:mm:ss")
        color: colors.primary
        font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily; bold: true }

        Timer {
          interval: 1000
          running: true
          repeat: true
          onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
      }

      ToggleButtons { 
        id: toggleButtons
        anchors.top: clock.bottom
      }

      VolumeControl {
        id: volumeControl
        anchors.top: toggleButtons.bottom
      }

      BrightnessControl {
        id: brightnessControl
        anchors.top: volumeControl.bottom
      }

      Player {
        id: player
        anchors.top: brightnessControl.bottom
      }

      Notifications {
        id: notifications
        anchors.top: player.bottom
      }
    }
  }
}
