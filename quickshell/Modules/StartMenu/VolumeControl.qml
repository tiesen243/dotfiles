import Quickshell.Services.Pipewire
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitHeight: volumeControl.implicitHeight

  property var audioSink: Pipewire.defaultAudioSink
  property int value: audioSink && audioSink.audio
    ? Math.round(audioSink.audio.volume * 100)
    : 0
  property bool isMuted: audioSink && audioSink.audio
    ? audioSink.audio.muted
    : false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  RowLayout {
    id: volumeControl

    anchors.fill: parent
    spacing: 12

    Text {
      id: volumeValue
      Accessible.role: Accessible.StaticText
      Accessible.name: "Volume Value: " + root.value + "%" + root.isMuted ? ", muted" : ""

      text: (root.isMuted ? "󰖁 " : "󰕾 ") + root.value
      color: colors.primary
      font: root.rootFont

      MouseArea {
        anchors.fill: parent
        onClicked: {
          if (!root.audioSink || !root.audioSink.audio) return

          root.isMuted = !root.isMuted
          root.audioSink.audio.muted = root.isMuted
        }
      }
    }

    Slider {
      id: volumeSlider
      Accessible.role: Accessible.Slider
      Accessible.name: "Volume Level"

      Layout.fillWidth: true
      from: 0
      to: 100
      value: root.value

      background: Rectangle {
        anchors.fill: parent
        color: colors.surface_variant
        radius: height / 2
      }

      handle: Rectangle {
        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: volumeSlider.pressed ? colors.primary_container : colors.primary
        border { color: colors.primary_fixed; width: 1 }
      }

      onMoved: {
        if (root.audioSink && root.audioSink.audio)
          root.audioSink.audio.volume = value / 100
      }
    }
  }
}
