import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Widgets

import qs.Colors

Scope {
  id: notification

  IpcHandler {
    target: "notification"

    function dismissAll(): void {
      NotificationService.dismissAll();
    }

    function dndToggle(): void {
      NotificationService.doNotDisturb = !NotificationService.doNotDisturb
    }
  }
}
