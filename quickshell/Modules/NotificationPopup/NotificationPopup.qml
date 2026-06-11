pragma ComponentBehavior: Bound

import Quickshell.Wayland
import Quickshell.Io
import Quickshell
import QtQuick

import qs.Commons
import qs.Services.NotificationService

Scope {
  id: root

  IpcHandler {
    target: 'notification'

    function clear(): void {
      NotificationService.clear()
    }

    function is_dnd(): bool {
      return !!NotificationService.isDoNotDisturb
    }

    function toggle_dnd(): void {
      NotificationService.isDoNotDisturb = !NotificationService.isDoNotDisturb
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: notificationPanel
      required property var modelData
      screen: modelData
      visible: NotificationService.notifications.length > 0

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "quickshell-notification-popup"
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.exclusiveZone: -1

      anchors { top: true; right: true; }
      focusable: false
      color: "transparent"
      implicitWidth: 1920 / 5
      implicitHeight: popupContent.implicitHeight + (GlobalState.isBarVisible ? Settings.bar.size + 4 : 4)

      NotificationPopupContent {
        id: popupContent
      }
    }
  }
}
