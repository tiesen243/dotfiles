import QtQuick
import Quickshell

import qs.Modules.Background
import qs.Modules.Bar
import qs.Modules.Sidebar

ShellRoot {
  id: shellRoot

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
    sourceComponent: Background { id: background }
  }
}
