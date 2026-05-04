import QtQuick
import Quickshell

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
}
