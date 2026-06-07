//@ pragma UseQApplication

import Quickshell
import QtQuick

import qs.Modules.Bar
import qs.Modules.Background
import qs.Modules.ControlCenter

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
}
