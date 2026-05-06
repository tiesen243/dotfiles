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

  implicitWidth: clock.implicitWidth
  implicitHeight: clock.implicitHeight

  Text {
    id: clock
    Accessible.role: Accessible.StaticText
    Accessible.name: "Current time: " + clock.text

    text: Qt.formatTime(new Date(), "hh:mm")
    color: colors.primary
    font: root.rootFont

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: celendar.visible = true
      onExited: celendar.visible = false
    }
  }

  PopupWindow {
    id: celendar
    visible: false
    property string content: ""

    anchor.window: root.popupAnchor
    anchor.rect.x: root.popupAnchor.width
    anchor.rect.y: parentWindow.implicitHeight + 4

    implicitWidth: 200
    implicitHeight: 160
    color: "transparent"
    HyprlandWindow.opacity: 0.8

    Rectangle {
      anchors.fill: parent
      color: colors.surface
      border { color: colors.on_primary; width: 2 }
      radius: 12
      Text {
        anchors.centerIn: parent
        text: celendar.content
        textFormat: Text.RichText
        color: colors.primary
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
        const styledLine = data.replace(regex, "$1<u><b><font color='" + colors.primary + "'>" + today + "</font></b></u>$2")
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
