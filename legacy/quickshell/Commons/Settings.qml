pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  property bool isDebug: Quickshell.env("QS_DISABLE_FILE_WATCHER") === "1"

  property string wm: Quickshell.env("XDG_CURRENT_DESKTOP") || ""
  property bool isHyprland: wm === "Hyprland"
  property bool isNiri: wm === "Niri"

  // Directories
  property string home: Quickshell.env("HOME") || ""
  property string config: Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`
  property string cache: Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`
  property string data: Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`

  // Components
  property var style: {
    "margin": 8,
    "radius": 8
  }

  property var bar: {
    "position": "top",
    "size": 24
  }
  property bool isBarHorizontal: bar.position === "top" || bar.position === "bottom"

  function getFont(size = 14, isBold = false): font {
    return Qt.font({
      pixelSize: size,
      family: "GeistMono Nerd Font Propo",
      weight: isBold ? Font.Bold : Font.Normal
    })
  }
}
