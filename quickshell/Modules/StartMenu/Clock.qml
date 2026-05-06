import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont
  property bool isOpen: false

  implicitHeight: clock.implicitHeight

  Text {
    id: clock
    Accessible.role: Accessible.StaticText
    Accessible.name: "Current time: " + clock.text

    text: Qt.formatDateTime(new Date(), "dddd, MMM dd yyyy, hh:mm:ss")
    color: colors.primary
    font {
      pixelSize: root.rootFont.pixelSize * 1.5
      family: root.rootFont.family
      bold: true
    }
  }

  Timer {
    id: clockTimer
    interval: 1000
    running: root.isOpen
    repeat: root.isOpen
    onTriggered: clock.text = Qt.formatDateTime(new Date(), "dddd, MMM dd yyyy, hh:mm:ss")
  }
}
