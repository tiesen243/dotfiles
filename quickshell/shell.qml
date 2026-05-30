import QtQuick
import Quickshell

import qs.Modules.Bar
import qs.Modules.Lockscreen
import qs.Modules.OSD
import qs.Modules.StartMenu

import "./Modules"

ShellRoot {
  id: root
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font Propo"
  })

  Loader {
    active: true
    sourceComponent: Lockscreen { id: lockscreen; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: Background { id: background }
  }

  Loader {
    active: true
    sourceComponent: Bar { id: bar; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: NotificationPopup { id: notificationPopup; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: StartMenu { id: startMenu; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: BackgroundSelector { id: backgroundSelector }
  }

  Loader {
    active: true
    sourceComponent: AppLauncher { id: appLauncher; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: ClipboardManager { id: clipboardManager; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: OSD { id: osd; rootFont: root.rootFont }
  }

  Loader {
    active: true
    sourceComponent: ActivateLinux { id: activateLinux }
  }
}
