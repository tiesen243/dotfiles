import Quickshell.Io
import Quickshell
import QtQuick

import qs.Commons

Item {
  id: root

  property string time: Qt.formatTime(new Date(), "hh:mm")
  property bool isCalendarOpen: false

  implicitWidth: clock.implicitWidth
  implicitHeight: clock.implicitHeight

  Text {
    id: clock
    Accessible.role: Accessible.StaticText
    Accessible.name: "Current time: " + root.time

    text: root.time
    color: Colors.on_surface
    font: Settings.getFont()

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: root.isCalendarOpen = true
      onExited: root.isCalendarOpen = false
    }
  }

  PanelWindow {
    id: celendar
    visible: root.isCalendarOpen || 
      (Settings.isBarHorizontal ? celendarContainer.implicitHeight > 0 : celendarContainer.implicitWidth > 0)
    property string content: ""

    implicitWidth: 180
    implicitHeight: 140
    color: "transparent"

    anchors {
      top: Settings.bar.position === "top"
      left: Settings.bar.position === "left"
      right: Settings.bar.position !== "left"
      bottom: Settings.bar.position !== "top"
    }

    Rectangle {
      id: celendarContainer

      implicitWidth: Settings.isBarHorizontal 
        ? parent.width 
        : (root.isCalendarOpen ? parent.width : 0)
      implicitHeight: Settings.isBarHorizontal 
        ? (root.isCalendarOpen ? parent.height : 0) 
        : parent.height

      color: Colors.surface

      bottomLeftRadius: Settings.bar.position === "top" ? Settings.style.radius : 0
      topLeftRadius: (Settings.bar.position === "bottom" || Settings.bar.position === "right") ? Settings.style.radius : 0
      topRightRadius: Settings.bar.position === "left" ? Settings.style.radius : 0

      clip: true

      Behavior on implicitHeight {
        enabled: Settings.isBarHorizontal
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
      }

      Behavior on implicitWidth {
        enabled: !Settings.isBarHorizontal
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
      }

      Text {
        anchors.centerIn: parent
        text: celendar.content
        textFormat: Text.RichText
        color: Colors.on_surface
        font: Settings.getFont(12)
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
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        const today = new Date().getDate().toString()
        const regex = new RegExp("(\\b|\\s)" + today + "(\\b|\\s)")
        const formatted = lines.slice(1).map(line => {
          const styledLine = line.replace(regex, "$1<u><b><font color='" +
          Colors.primary + "'>" + today + "</font></b></u>$2")
          return "&nbsp;" + styledLine.replace(/ /g, "&nbsp;")
        }).join("<br>")
        celendar.content = `<pre>${formatted}</pre>`
      }
    }
  }

  Timer {
    interval: (60 - new Date().getSeconds()) * 1000
    running: true
    repeat: true
    onTriggered: {
      root.time = Qt.formatTime(new Date(), "hh:mm")
      interval = (60 - new Date().getSeconds()) * 1000
    }
  }
}
