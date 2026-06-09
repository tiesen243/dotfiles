import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services

Item {
  id: root

  Layout.fillWidth: true
  implicitHeight: brightnessSlider.implicitHeight
  anchors.margins: Settings.style.margin

  RowLayout {
    id: brightnessSlider
    spacing: Settings.style.margin
    anchors.fill: parent

    Rectangle {
      id: brightnessSliderLabel

      implicitWidth: 55
      implicitHeight: volumeSliderLabelText.implicitHeight
      color: "transparent"

      Text {
        id: volumeSliderLabelText
        Accessible.role: Accessible.StaticText
        Accessible.name: "Brightness level: " + Math.round(Brightness.value * 100) + (Brightness.isMuted ? ", muted" : "")

        anchors.verticalCenter: parent.verticalCenter
        text: Brightness.getIcon() + " " + Brightness.value + "%"
        color: Colors.on_surface
        font: Settings.getFont()

        MouseArea {
          anchors.fill: parent
          onClicked: Brightness.toggleMute()
        }
      }
    }

    Slider {
      id: brightnessSliderControl
      Accessible.role: Accessible.Slider
      Accessible.name: "Brightness control, current value: " + Brightness.value
      Layout.fillWidth: true

      from: 0
      to: 100
      stepSize: 1
      value: Brightness.value
      onMoved: Brightness.set(value)

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => {
          const step = event.angleDelta.y > 0 ? 5 : -5
          const newValue = Math.max(brightnessSliderControl.from, Math.min(brightnessSliderControl.to, brightnessSliderControl.value + step))
          Brightness.set(Math.round(newValue))
        }
      }

      background: Rectangle {
        anchors.fill: parent
        color: Colors.on_secondary
        radius: height / 2
      }

      handle: Rectangle {
        x: brightnessSliderControl.leftPadding + brightnessSliderControl.visualPosition * (brightnessSliderControl.availableWidth - width)
        y: brightnessSliderControl.topPadding + brightnessSliderControl.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: brightnessSliderControl.pressed ? Colors.primary : Colors.on_surface
        border { color: Colors.on_secondary; width: 1 }
      }
    }
  }
}
