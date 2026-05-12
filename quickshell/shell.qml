import QtQuick
import Quickshell

import qs.Modules.Bar
import qs.Modules.Lockscreen
import qs.Modules.OSD
import qs.Modules.StartMenu

import "./Modules"

ShellRoot {
  id: root

  Loader {
    active: true
    sourceComponent: Lockscreen { id: lockscreen }
  }

  Loader {
    active: true
    sourceComponent: Background { id: background }
  }

  Loader {
    active: true
    sourceComponent: Bar { id: bar }
  }

  Loader {
    active: true
    sourceComponent: NotificationPopup { id: notificationPopup }
  }

  Loader {
    active: true
    sourceComponent: StartMenu { id: startMenu }
  }

  Loader {
    active: true
    sourceComponent: BackgroundSelector { id: backgroundSelector }
  }

  Loader {
    active: true
    sourceComponent: AppLauncher { id: appLauncher }
  }

  Loader {
    active: true
    sourceComponent: ClipboardManager { id: clipboardManager }
  }

  Loader {
    active: true
    sourceComponent: OSD { id: osd }
  }

  Loader {
    active: false
    sourceComponent: ActivateLinux { id: activateLinux }
  }
}
