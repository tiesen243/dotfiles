import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont
  property var popupAnchor

  implicitWidth: clock.width

  Text {
    id: clock
    Accessible.role: Accessible.StaticText
    Accessible.name: "Current time: " + clock.text

    anchors.centerIn: parent
    text: Qt.formatTime(new Date(), "hh:mm")
    color: colors.primary
    font: rootFont

    MouseArea {
      anchors.fill: parent
      onClicked: celendar.visible = !celendar.visible
    }
  }

  PopupWindow {
    id: celendar
    visible: false
    property string content: ""

    anchor.window: root.popupAnchor
    anchor.rect.x: parentWindow.width
    anchor.rect.y: parentWindow.height + 4

    implicitWidth: 200
    implicitHeight: 160
    color: "transparent"
    HyprlandWindow.opacity: 0.8

    Rectangle {
      anchors.fill: parent
      color: colors.surface
      border { color: colors.on_primary; width: 1 }
      radius: 8
      Text {
        anchors.centerIn: parent
        text: celendar.content
        textFormat: Text.RichText
        color: colors.primary
        font: rootFont
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
        const styledLine = data.replace(regex, "$1<u><b><font color='" + colors.primary + "'>" + today + "</font></b></u>$2")
        celendar.content += "<br>" + styledLine.replace(/ /g, "&nbsp;")
      }
    }
  }

  Timer {
    interval: (60 - new Date().getSeconds()) * 1000
    running: true
    repeat: true
    onTriggered: {
      clock.text = Qt.formatTime(new Date(), "hh:mm")
      clockTimer.interval = (60 - new Date().getSeconds()) * 1000
    } 
  }
}
