pragma Singleton

import Quickshell

Singleton {
  id: root

  property bool isBarVisible: true
  property bool isControlCenterVisible: false
  property bool isAppLauncherVisible: false
  property bool isClipboardVisible: false

  function toggleControlCenter() {
    root.isControlCenterVisible = !root.isControlCenterVisible
    root.isAppLauncherVisible = false
    root.isClipboardVisible = false
  }

  function toggleAppLauncher() {
    root.isAppLauncherVisible = !root.isAppLauncherVisible
    root.isControlCenterVisible = false
    root.isClipboardVisible = false
  }

  function toggleClipboard() {
    root.isClipboardVisible = !root.isClipboardVisible
    root.isControlCenterVisible = false
    root.isAppLauncherVisible = false
  }
}
