import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitHeight: lockscreenClock.implicitHeight

	property var date: new Date()

  ColumnLayout {
    id: lockscreenClock
    anchors.horizontalCenter: parent.horizontalCenter

	  Label {
		  id: time

      Layout.alignment: Qt.AlignHCenter
		  text: Qt.formatTime(root.date, "hh:mm")
		  font.pointSize: root.rootFont.pointSize * 8
		  font.family: root.rootFont.family
		  color: colors.on_primary
	  }

	  Label {
	    id: date

      Layout.alignment: Qt.AlignHCenter
	    text: Qt.formatDate(root.date, "dddd, MMMM dd yyyy")
	    color: colors.on_secondary
	    font: root.rootFont
	  }
	}

  Timer {
    id: clockTimer
    interval: (60 - new Date().getSeconds()) * 1000
    running: true
    repeat: true
    onTriggered: {
      root.date = new Date()
      clockTimer.interval = (60 - new Date().getSeconds()) * 1000
    } 
  }
}
