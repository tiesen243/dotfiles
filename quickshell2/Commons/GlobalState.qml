pragma Singleton

import Quickshell

Singleton {
  id: root

  property bool isControlCenterVisible: false

  function toggleControlCenter() {
    root.isControlCenterVisible = !root.isControlCenterVisible
  }
}
