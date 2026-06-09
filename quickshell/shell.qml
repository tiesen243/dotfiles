//@ pragma UseQApplication

import Quickshell
import QtQuick

// --- 1. System & Background Layer ---
import qs.Modules.Background
import qs.Modules.WallpaperSelector

// --- 2. Desktop UI Layer ---
import qs.Modules.Bar
import qs.Modules.Lockscreen

// --- 3. Windows & Popups Layer ---
import qs.Modules.AppLauncher
import qs.Modules.ControlCenter
import qs.Modules.ClipboardManager

// --- 4. System Overlays & Notifications ---
import qs.Modules.NotificationPopup
import qs.Modules.OSD

ShellRoot {
  id: root

  // ==========================================
  // 1. SYSTEM & BACKGROUND LAYER
  // ==========================================
  Loader {
    id: background
    sourceComponent: Background {}
  }

  Loader {
    id: wallpaperSelector
    sourceComponent: WallpaperSelector {}
  }

  // ==========================================
  // 2. DESKTOP UI LAYER
  // ==========================================
  Loader {
    id: bar
    sourceComponent: Bar {}
  }

  Loader {
    id: lockscreen
    sourceComponent: Lockscreen {}
  }


  // ==========================================
  // 3. WINDOWS & POPUPS LAYER
  // ==========================================
  Loader {
    id: appLauncher
    sourceComponent: AppLauncher {}
  }

  Loader {
    id: controlCenter
    sourceComponent: ControlCenter {}
  }

  Loader {
    id: clipboardManager
    sourceComponent: ClipboardManager {}
  }

  // ==========================================
  // 4. SYSTEM OVERLAYS & NOTIFICATIONS
  // ==========================================
  Loader {
    id: osd
    sourceComponent: OSD {}
  }

  Loader {
    id: notificationPopup
    sourceComponent: NotificationPopup {}
  }
}
