pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

import qs.Commons

Singleton {
  id: root

  property int value: 0
  property int maxValue: 1
  property bool isReady: false
  property bool isShow: false

  function getIcon() {
    if (root.value >= 66) return "󰃠"
    else if (root.value >= 33) return "󰃟"
    else if (root.value > 0) return "󰃞"
    else return "󰃝"
  }

  function set(percent: int): void {
    if (isNaN(percent) || percent < 0 || percent > 100 || root.maxValue <= 0) return

    const val = Math.round((percent / 100) * root.maxValue)
    brightnessSetProc.command = ["brightnessctl", "set", "-n2", String(val)]
    brightnessSetProc.running = true
  }

  FileView {
    id: brightnessFile
    path: ""
    watchChanges: true
    onFileChanged: brightnessGetProc.running = true
  }

  Process {
    id: brightnessGetProc
    command: ["brightnessctl", "get"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseInt(text.trim())
        if (!isNaN(val) && root.maxValue > 0)
          root.value = (val / root.maxValue) * 100

        if (root.isReady && !GlobalState.isStartMenuOpen) {
          root.isShow = true
          brightnessHideTimer.restart()
        }
        root.isReady = true
      }
    }
  }

  Process {
    id: brightnessSetProc
    command: []
  }

  Process {
    id: backlightDiscoveryProc
    command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo $p && cat ${p%brightness}max_brightness"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        if (lines.length >= 2) {
          const max = parseInt(lines[1])
          if (!isNaN(max) && max > 0) root.maxValue = max
          brightnessFile.path = lines[0]
          brightnessGetProc.running = true
        }
      }
    }
    Component.onCompleted: running = true
  }

  Timer {
    id: brightnessHideTimer
    interval: 1500
    onTriggered: root.isShow = false
  }
}
