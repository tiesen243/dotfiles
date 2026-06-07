pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell.Services.Pipewire
import Quickshell
import QtQuick

Singleton {
  id: root

  property var defaultSink: Pipewire.defaultAudioSink
  property real value: 0
  property bool isMuted: false
  property bool isReady: false
  property bool isShow: false

  function getIcon(): string {
    if (root.isMuted || root.value <= 0) return "󰖁"
    if (root.value < 0.33) return "󰕿"
    if (root.value < 0.66) return "󰖀"
    return "󰕾"
  }

  function set(percent: int): void {
    if (isNaN(percent) || percent < 0 || percent > 100) return
    if (!root.defaultSink || !root.defaultSink.audio) return

    const val = percent / 100
    root.defaultSink.audio.volume = val
    root.defaultSink.audio.muted = false
  }

  function toggleMute(): void {
    if (!root.defaultSink || !root.defaultSink.audio) return

    root.defaultSink.audio.muted = !root.isMuted
  }

  PwObjectTracker {
    objects: [root.defaultSink]
  }

  Connections {
    target: root.defaultSink?.audio ?? null

    function onVolumeChanged() {
      root.value = root.defaultSink.audio.volume
      if (root.isReady && !GlobalState.isStartMenuOpen) {
        root.isShow = true
        volumeHideTimer.restart()
      }
      root.isReady = true
    }

    function onMutedChanged() {
      root.isMuted = root.defaultSink.audio.muted
      if (root.isReady && !GlobalState.isStartMenuOpen) {
        root.isShow = true
        volumeHideTimer.restart()
      }
      root.isReady = true
    }
  }

  Timer {
    id: volumeHideTimer
    interval: 1500
    onTriggered: root.isShow = false
  }
}

