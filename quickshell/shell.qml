//@ pragma UseQApplication

import Quickshell
import QtQuick

import qs.Modules.Bar
import qs.Modules.Background
import qs.Modules.ControlCenter
import qs.Modules.AppLauncher
import qs.Modules.Lockscreen
import qs.Modules.OSD
import qs.Modules.ClipboardManager
import qs.Modules.NotificationPopup

ShellRoot {
  id: root

  Loader {
    id: bar
    sourceComponent: Bar {}
  }

  Loader {
    id: background
    sourceComponent: Background {}
  }

  Loader {
    id: controlCenter
    sourceComponent: ControlCenter {}
  }

  Loader {
    id: appLauncher
    sourceComponent: AppLauncher {}
  }

  Loader {
    id: clipboardManager
    sourceComponent: ClipboardManager {}
  }

  Loader {
    id: lockscreen
    sourceComponent: Lockscreen {}
  }

  Loader {
    id: osd
    sourceComponent: OSD {}
  }

  Loader {
    id: notificationPopup
    sourceComponent: NotificationPopup {}
  }
}
