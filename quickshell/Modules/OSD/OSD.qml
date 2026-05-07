import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

import "../../Services"
import qs.Colors

Scope {
  id: root
  Colors { id: colors }
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  property bool showVolume: false
  property bool showBrightness: false

  property real volumeValue: 0
  property bool volumeMuted: false
  property bool _volumeReady: false

  property real brightnessValue: 0
  property real maxBrightness: 1
  property bool _brightnessReady: false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ?? null

    function onVolumeChanged() {
      root.volumeValue = Pipewire.defaultAudioSink.audio.volume;
      if (root._volumeReady && !GlobalState.isStartMenuOpen) {
        root.showVolume = true;
        volumeHideTimer.restart();
      }
      root._volumeReady = true;
    }

    function onMutedChanged() {
      root.volumeMuted = Pipewire.defaultAudioSink.audio.muted;
      if (root._volumeReady && !GlobalState.isStartMenuOpen) {
        root.showVolume = true;
        volumeHideTimer.restart();
      }
      root._volumeReady = true;
    }
  }

  Timer {
    id: volumeHideTimer
    interval: 1500
    onTriggered: root.showVolume = false
  }

  FileView {
    id: brightnessFile
    path: ""
    watchChanges: true
    onFileChanged: brightnessReadProc.running = true
  }

  Process {
    id: brightnessReadProc
    command: ["brightnessctl", "get"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseInt(text.trim());
        if (!isNaN(val) && root.maxBrightness > 0) {
          root.brightnessValue = val / root.maxBrightness;

          if (root._brightnessReady && !GlobalState.isStartMenuOpen) {
            root.showBrightness = true
            brightnessHideTimer.restart();
          }
          root._brightnessReady = true
        }
      }
    }
  }

  Process {
    id: backlightDiscovery
    command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo \"$p\" && cat \"${p%brightness}max_brightness\""]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        if (lines.length >= 2) {
          const max = parseInt(lines[1]);
          if (!isNaN(max) && max > 0) root.maxBrightness = max;
          brightnessFile.path = lines[0];
          brightnessReadProc.running = true;
        }
      }
    }
  }

  Timer {
    id: brightnessHideTimer
    interval: 1500
    onTriggered: root.showBrightness = false
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      visible: root.showVolume || root.showBrightness
      focusable: false
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.namespace: "quickshell-osd"

      exclusionMode: ExclusionMode.Ignore
      mask: Region {}

      anchors {
        right: true
        top: true
        bottom: true
      }

      implicitWidth: 70

      Column {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Volume {
          id: volumePill
          rootFont: root.rootFont

          showVolume: root.showVolume
          volumeValue: root.volumeValue
          volumeMuted: root.volumeMuted
        }

        Brightness {
          id: brightnessPill
          rootFont: root.rootFont

          showBrightness: root.showBrightness
          brightnessValue: root.brightnessValue
        }
      }
    }
  }
}
