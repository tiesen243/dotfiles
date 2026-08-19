pragma Singleton

import Quickshell.Services.Pipewire
import Quickshell
import QtQuick

import qs.Commons

Singleton {
  id: root

  property var defaultSink: Pipewire.defaultAudioSink

  property real value: 0
  property bool isMuted: false
  property bool isReady: false
  property bool isShow: false

  Binding {
    target: root
    property: "value"
    value: root.defaultSink?.audio?.volume ?? 0
    restoreMode: Binding.RestoreNone
  }

  Binding {
    target: root
    property: "isMuted"
    value: root.defaultSink?.audio?.muted ?? false
    restoreMode: Binding.RestoreNone
  }

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
      if (root.isReady && !GlobalState.isControlCenterVisible) {
        root.isShow = true
        volumeHideTimer.restart()
      }
      root.isReady = true
    }

    function onMutedChanged() {
      if (root.isReady && !GlobalState.isControlCenterVisible) {
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
