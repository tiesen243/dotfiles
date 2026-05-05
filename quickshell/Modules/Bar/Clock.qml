import Quickshell
import Quickshell.Io

import QtQuick
import Quickshell.Hyprland

Text {
  id: clock

  anchors { right: battery.left; verticalCenter: parent.verticalCenter; margins: 12 }
  text: Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm")
  color: colors.primary
  font { pixelSize: bar.fontSize; family: bar.fontFamily }

  MouseArea {
    anchors.fill: parent
    onClicked: celendar.visible = !celendar.visible
  }

  Timer {
    interval: 60 * 1000
    running: true
    repeat: true
    onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - hh:mm")
  }

  PopupWindow {
    id: celendar
    visible: false

    property string calContent: ""

    anchor.window: panel
    anchor.rect.x: parentWindow.width
    anchor.rect.y: parentWindow.height + 4

    implicitWidth: 200
    implicitHeight: 160
    color: "transparent"
    HyprlandWindow.opacity: 0.8

    HyprlandFocusGrab {
      active: celendar.visible
      windows: [celendar]
      onCleared: {
        celendar.visible = false
      }
    }

    onVisibleChanged: {
      if (visible) {
        celendar.calContent = ""
        calProc.running = true
      }
    }

    Rectangle {
      anchors.fill: parent
      color: colors.background
      
      radius: 8
      border { color: colors.primary; width: 2 }

      Text {
        anchors.centerIn: parent
        text: celendar.calContent
        color: colors.primary
        font { pixelSize: bar.fontSize; family: bar.fontFamily }
      }

      Process {
        id: calProc
        command: ['cal']
        stdout: SplitParser {
          onRead: data => {
            var today = new Date().getDate().toString();
            var regex = new RegExp("(\\b|\\s)" + today + "(\\b|\\s)");
            var styledLine = data.replace(regex, "$1<u><b><font color='" + colors.primary + "'>" + today + "</font></b></u>$2");
            celendar.calContent += "<br>" + styledLine.replace(/ /g, "&nbsp;") 
          }
        }
      }
    }
  }
}

