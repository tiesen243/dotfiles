pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell

Singleton {
  id: root

  readonly property string home: Quickshell.env("HOME")
  readonly property string pictures: Quickshell.env("XDG_PICTURES_DIR") || `${home}/Pictures`
  readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`
  readonly property string dotfiles: `${home}/dotfiles`

  property bool isStartMenuOpen: false
  property bool isAppLauncherOpen: false
  property bool isClipboardOpen: false
  property bool isBackgroundSelectorOpen: false

  property var popups: ({
    "startmenu": "isStartMenuOpen",
    "appLauncher": "isAppLauncherOpen",
    "clipboard": "isClipboardOpen",
    "backgroundSelector": "isBackgroundSelectorOpen"
  })
}
