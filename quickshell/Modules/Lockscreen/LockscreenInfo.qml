import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  property font rootFont

  implicitHeight: lockscreenInfo.implicitHeight

  property string username
  property string hostname

  RowLayout {
    id: lockscreenInfo
    spacing: 16

    ClippingRectangle {
      id: userAvatar

      implicitWidth: 128
      implicitHeight: implicitWidth
      border { color: Matugen.on_primary; width: 1 }
      radius: 16

      Image {
        id: userAvatarImage
        Accessible.role: Accessible.Graphic
        Accessible.name: root.username + "'s avatar"

        anchors.fill: parent
        source: "file:///usr/share/sddm/faces/" + root.username + ".face.icon"
        fillMode: Image.PreserveAspectCrop
      }
    }

    ColumnLayout {
      Text {
        id: userName
        Accessible.role: Accessible.StaticText
        Accessible.name: "Current user: " + root.username

        anchors.margins: 0
        text: root.username
        color: Matugen.on_primary
        font {
          pixelSize: root.rootFont.pixelSize * 4
          family: root.rootFont.family
          bold: true
        }
      }

      Text {
        id: hostName
        Accessible.role: Accessible.StaticText
        Accessible.name: "Current host: " + root.hostname

        text: root.hostname
        color: Matugen.on_primary
        font {
          pixelSize: root.rootFont.pixelSize * 2
          family: root.rootFont.family
          bold: true
        }
      }
    }
  }

    Process {
    id: usernameProc
    command: ["whoami"]
    stdout: SplitParser {
      onRead: data => root.username = data.trim()
    }
    Component.onCompleted: running = true
  }

  Process {
    id: hostnameProc
    command: ["hostnamectl"]
    stdout: SplitParser {
      onRead: data => {
        const match = data.match(/Static hostname:\s*(\S+)/)
        if (match) root.hostname = match[1]
      }
    }
    Component.onCompleted: running = true
  }
}
