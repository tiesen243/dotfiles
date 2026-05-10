import Quickshell.Io
import Quickshell
import QtQuick

import "../../Services"

Item {
  id: root
  property font rootFont
  property var popupAnchor

  implicitWidth: clock.implicitWidth
  implicitHeight: clock.implicitHeight

  property bool isOpen: false

  Text {
    id: clock
    Accessible.role: Accessible.StaticText
    Accessible.name: "Current time: " + clock.text

    text: Qt.formatTime(new Date(), "hh:mm")
    color: Matugen.primary
    font: root.rootFont

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: root.isOpen = true
      onExited: root.isOpen = false
    }
  }

  PopupWindow {
    id: celendar
    visible: root.isOpen || celendarContainer.opacity > 0
    property string content: ""

    anchor.window: root.popupAnchor
    anchor.rect.x: root.popupAnchor.width
    anchor.rect.y: parentWindow.height

    implicitWidth: 200
    implicitHeight: 160
    color: "transparent"

    Rectangle {
      id: celendarContainer

      implicitWidth: parent.width
      implicitHeight: parent.height
      color: Matugen.surface
      bottomLeftRadius: 12

      opacity: root.isOpen ? 1 : 0
      Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
      }
      y: root.isOpen ? 0 : -implicitHeight
      Behavior on y {
        NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
      }

      Text {
        anchors.centerIn: parent
        text: celendar.content
        textFormat: Text.RichText
        color: Matugen.primary
        font: root.rootFont
      }
    }

    onVisibleChanged: {
      if (visible) {
        celendar.content = ""
        celendarProc.running = true
      }
    }
  }

  Process {
    id: celendarProc
    command: ["cal"]
    stdout: SplitParser {
      onRead: data => {
        const today = new Date().getDate().toString()
        const regex = new RegExp("(\\b|\\s)" + today + "(\\b|\\s)")
        const styledLine = data.replace(regex, "$1<u><b><font color='" + Matugen.primary + "'>" + today + "</font></b></u>$2")
        celendar.content += "<br>" + styledLine.replace(/ /g, "&nbsp;")
      }
    }
  }

  Timer {
    id: clockTimer
    interval: (60 - new Date().getSeconds()) * 1000
    running: root.visible
    repeat: true
    onTriggered: {
      clock.text = Qt.formatTime(new Date(), "hh:mm")
      clockTimer.interval = (60 - new Date().getSeconds()) * 1000
    } 
  }
}
