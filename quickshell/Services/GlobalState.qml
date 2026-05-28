pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell

Singleton {
  id: root

  readonly property string home: Quickshell.env("HOME")
  readonly property string pictures: Quickshell.env("XDG_PICTURES_DIR") || `${home}/Pictures`
  readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`
  readonly property string dotfiles: `${home}/dotfiles`

  property bool isBarOpen: true
  property bool isStartMenuOpen: false
  property bool isAppLauncherOpen: false
  property bool isClipboardOpen: false
  property bool isBackgroundSelectorOpen: false

  function closeAllPanels(
    except = {
      startMenu: false,
      appLauncher: false,
      clipboard: false,
      backgroundSelector: false
    }
  ): void {
    if (!except.startMenu) root.isStartMenuOpen = false
    if (!except.appLauncher) root.isAppLauncherOpen = false
    if (!except.clipboard) root.isClipboardOpen = false
    if (!except.backgroundSelector) root.isBackgroundSelectorOpen = false
  }
}
