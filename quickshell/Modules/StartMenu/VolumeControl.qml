import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
  id: volumeControl

  anchors { left: parent.left; right: parent.right; margins: 12 }
  spacing: 8

  Text {
    text: "󰕾 " + Math.round(volumeSlider.value)
    color: colors.primary
    font { pixelSize: startMenu.fontSize / 1.5; family: startMenu.fontFamily }
  }

  Slider {
    id: volumeSlider
    Layout.fillWidth: true

    handle: Rectangle {
      x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
      y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
      width: 16
      height: 16
      radius: 8
      color: colors.primary
      border { color: colors.on_primary; width: 2 }
    }

    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volumeValue: defaultAudioSink && defaultAudioSink.audio
      ? Math.round(defaultAudioSink.audio.volume * 100)
      : 0
    PwObjectTracker {
          objects: [Pipewire.defaultAudioSink]
        }

        from: 0
        to: 100
        value: volumeValue

        onValueChanged: {
          if (!volumeSlider.defaultAudioSink || !volumeSlider.defaultAudioSink.audio) 
            return

          volumeSlider.defaultAudioSink.audio.volume = Math.max(0.0, Math.min(1.0, volumeSlider.value / 100));
        }
      }
    }
