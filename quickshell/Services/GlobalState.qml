pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell

Singleton {
  id: root

  property bool isStartMenuOpen: false
  property bool isAppLauncherOpen: false
  property bool isClipboardOpen: false

  property var popups: ({
    "startmenu": "isStartMenuOpen",
    "appLauncher": "isAppLauncherOpen",
    "clipboard": "isClipboardOpen"
  })

  function closeAllPopups(except: string): void {
    for (let key in popups) {
      if (key !== except)
        root[popups[key]] = false
    }  
  }
}
