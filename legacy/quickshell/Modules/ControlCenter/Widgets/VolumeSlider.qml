import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Item {
  id: root

  Layout.fillWidth: true
  implicitHeight: volumeSlider.implicitHeight
  anchors.margins: Settings.style.margin

  RowLayout {
    id: volumeSlider
    spacing: Settings.style.margin
    anchors.fill: parent

    Rectangle {
      id: volumeSliderLabel

      implicitWidth: 55
      implicitHeight: volumeSliderLabelText.implicitHeight
      color: "transparent"

      Text {
        id: volumeSliderLabelText
        Accessible.role: Accessible.StaticText
        Accessible.name: "Volume level: " + Math.round(Volume.value * 100) + (Volume.isMuted ? ", muted" : "")

        anchors.verticalCenter: parent.verticalCenter
        text: Volume.getIcon() + " " + Math.round(Volume.value * 100) + "%"
        color: Colors.on_surface
        font: Settings.getFont()

        MouseArea {
          anchors.fill: parent
          onClicked: Volume.toggleMute()
        }
      }
    }

    Slider {
      id: volumeSliderControl
      Accessible.role: Accessible.Slider
      Accessible.name: "Volume control, current value: " + Math.round(Volume.value * 100) + (Volume.isMuted ? ", muted" : "")
      Layout.fillWidth: true

      from: 0
      to: 100
      stepSize: 1
      value: Volume.value * 100
      onMoved: Volume.set(value)

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => {
          const step = event.angleDelta.y > 0 ? 5 : -5
          const newValue = Math.max(volumeSliderControl.from, Math.min(volumeSliderControl.to, volumeSliderControl.value + step))
          Volume.set(Math.round(newValue))
        }
      }

      background: Rectangle {
        anchors.fill: parent
        color: Colors.on_secondary
        radius: height / 2
      }

      handle: Rectangle {
        x: volumeSliderControl.leftPadding + volumeSliderControl.visualPosition * (volumeSliderControl.availableWidth - width)
        y: volumeSliderControl.topPadding + volumeSliderControl.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: volumeSliderControl.pressed ? Colors.primary : Colors.on_surface
        border { color: Colors.on_secondary; width: 1 }
      }
    }
  }
}
