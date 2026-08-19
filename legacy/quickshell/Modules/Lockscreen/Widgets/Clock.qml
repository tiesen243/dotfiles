import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick

import qs.Commons

Item {
  id: root

  implicitHeight: lockscreenClock.implicitHeight

	property var date: new Date()

  ColumnLayout {
    id: lockscreenClock
    anchors.horizontalCenter: parent.horizontalCenter

	  Label {
		  id: time

      Layout.alignment: Qt.AlignHCenter
		  text: Qt.formatTime(root.date, "hh:mm")
		  font: Settings.getFont(112, true)
		  color: Colors.primary
	  }

	  Label {
	    id: date

      Layout.alignment: Qt.AlignHCenter
	    text: Qt.formatDate(root.date, "dddd, MMMM dd yyyy")
	    color: Colors.secondary
	    font: Settings.getFont()
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
