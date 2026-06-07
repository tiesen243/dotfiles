pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property string wallpaperFolderDir: GlobalState.dotfiles + "/assets/wallpapers"
  readonly property string wallpaperDir: GlobalState.dotfiles + "/assets/_background.png"
  property list<string> wallpapers: []
  property int wallpaperVersion: 0

  function setWallpaper(path) {
    setWallpaperProc.command = [
      "sh", 
      "-c", 
      `cp "${path}" "${root.wallpaperDir}" && matugen image "${root.wallpaperDir}" --source-color-index 1`
    ]
    setWallpaperProc.running = true
  }

  Process {
    id: scanWallpapersProc
    command: ["sh", "-c", "ls " + root.wallpaperFolderDir]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        root.wallpapers = lines.map(line => root.wallpaperFolderDir + "/" + line)
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: setWallpaperProc
    command: []
    onExited: code => {
      if (code === 0) root.wallpaperVersion++
    }
  }
}
