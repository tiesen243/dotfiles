import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import '../../Services'

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitHeight: volumeControl.implicitHeight

  RowLayout {
    id: volumeControl

    anchors.fill: parent
    spacing: 12

    Text {
      id: volumeValue
      Accessible.role: Accessible.StaticText
      Accessible.name: "Volume Value: " + VolumeService.value + "%" + VolumeService.isMuted ? ", muted" : ""

      text: VolumeService.getIcon() + " " + Math.round(VolumeService.value * 100).toString().padStart(2, '0')
      color: colors.primary
      font: root.rootFont

      MouseArea {
        anchors.fill: parent
        onClicked: VolumeService.toggleMute()
      }
    }

    Slider {
      id: volumeSlider
      Accessible.role: Accessible.Slider
      Accessible.name: "Volume Level"

      Layout.fillWidth: true
      from: 0
      to: 100
      value: VolumeService.value * 100

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

      onMoved: VolumeService.set(value)
    }
  }
}
