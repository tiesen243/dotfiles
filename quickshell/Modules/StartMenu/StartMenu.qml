pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import '../../Services'

Scope {
  id: root

  readonly property bool isOpen: GlobalState.isStartMenuOpen && startMenuContent.implicitHeight > 0
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: "startMenu"

    function toggle(): void {
      GlobalState.isStartMenuOpen = !GlobalState.isStartMenuOpen
    }
  }

  PanelWindow {
    id: startMenuContainer
    visible: GlobalState.isStartMenuOpen || startMenuContent.implicitHeight > 0

	  WlrLayershell.layer: WlrLayer.Overlay
    anchors.top: true
    anchors.left: true
    implicitWidth: 1920 / 4
    implicitHeight: 1080 / 2
    color: "transparent"

    Shortcut {
      sequence: "Escape"
      enabled: GlobalState.isStartMenuOpen && startMenuContent.implicitHeight > 0
      onActivated: GlobalState.isStartMenuOpen = false
    }

    Rectangle {
      id: startMenuContent

      anchors.top: parent.top
      implicitWidth: parent.width
      implicitHeight: GlobalState.isStartMenuOpen ? parent.height : 0
      color: Matugen.surface
      bottomRightRadius: 12
      clip: true

      Behavior on implicitHeight {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
      }

      ColumnLayout {
        id: startMenuLayout
        anchors { fill: parent; margins: 16 }
        spacing: 12

        Buttons {
          id: buttons
          rootFont: root.rootFont
          isOpen: GlobalState.isStartMenuOpen && startMenuContent.implicitHeight > 0

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

        Loader {
          active: GlobalState.isStartMenuOpen
          Layout.fillWidth: true
          Layout.fillHeight: true

          sourceComponent: Notification {
            id: notification
            rootFont: root.rootFont
          }
        }

        Footer {
          id: footer
          rootFont: root.rootFont
          isOpen: GlobalState.isStartMenuOpen && startMenuContent.implicitHeight > 0

          Layout.fillWidth: true
        }
      }
    }
  }
}
