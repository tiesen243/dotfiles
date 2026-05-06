import QtQuick
import Quickshell

import qs.Modules.Background
import qs.Modules.Bar
import qs.Modules.Lockscreen
import qs.Modules.Notification
import qs.Modules.Sidebar

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
    active: false
    sourceComponent: Sidebar { id: sidebar }
  }

  Loader {
    active: true
    sourceComponent: Notification { id: notification }
  }
}
