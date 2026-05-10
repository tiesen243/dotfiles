import QtQuick
import Quickshell

import qs.Modules.ActivateLinux
import qs.Modules.AppLauncher
import qs.Modules.Background
import qs.Modules.Bar
import qs.Modules.ClipboardManager
import qs.Modules.Lockscreen
import qs.Modules.Notification
import qs.Modules.OSD
import qs.Modules.StartMenu

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
    sourceComponent: StartMenu { id: startMenu }
  }

  Loader {
    active: true
    sourceComponent: Notification { id: notification }
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
