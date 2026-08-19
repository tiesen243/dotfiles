pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

import qs.Commons

Singleton {
  id: root

  property string wallpapersDir: Settings.home + "/dotfiles/assets/wallpapers/"
  property string wallpaperDir: Settings.home + "/dotfiles/assets/_background.png"
  property int wallpaperVer: 0

  property list<string> wallpapers: []

  function setWallpaper(path) {
    setWallpaperProcess.command = ["sh", "-c", "ln -sf " + path + " " + root.wallpaperDir + " && matugen image " + root.wallpaperDir]
    setWallpaperProcess.running = true
  }

  Process {
    id: getWallpaperProcess
    command: ["sh", "-c", "ls " + root.wallpapersDir]
    stdout: StdioCollector {
      onStreamFinished: {
        if (!text) return root.wallpapers = []

        const files = text.trim().split("\n").filter(line => line.trim() !== "")
        const wallpapers = files.map(file => root.wallpapersDir + file)
        root.wallpapers = wallpapers
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: setWallpaperProcess
    onExited: code => {
      if (code === 0) root.wallpaperVer++
    }
  }
}
