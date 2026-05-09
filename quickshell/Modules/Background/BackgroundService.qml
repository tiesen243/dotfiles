pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

import "../../Services"

Singleton {
  id: root

  readonly property string wallpaperDir: GlobalState.dotfiles + "/assets/wallpapers"
  property list<string> wallpapers: []
  property int wallpaperVersion: 0
  property bool isOpen: false

  function setWallpaper(path) {
    const dest = GlobalState.dotfiles + "/assets/_background.png"

    setWallpaperProc.command = ["sh", "-c", `cp "${path}" "${dest}" && matugen image "${dest}" --prefer saturation`]
    setWallpaperProc.running = true
  }

  Process {
    id: scanWallpapersProc
    command: ["sh", "-c", "ls " + root.wallpaperDir]
    running: root.isOpen
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        root.wallpapers = lines.map(line => root.wallpaperDir + "/" + line)
      }
    }
  }

  Process {
    id: setWallpaperProc
    command: []
    onExited: code => {
      if (code === 0) root.wallpaperVersion++
    }
  }
}
