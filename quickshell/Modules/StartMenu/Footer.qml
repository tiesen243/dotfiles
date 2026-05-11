pragma ComponentBehavior: Bound

import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  property font rootFont
  property bool isOpen

  implicitHeight: footer.implicitHeight

  property string username

  RowLayout {
    id: footer
    spacing: 12
    anchors.fill: parent

    RowLayout {
      id: user
      spacing: 8

      ClippingRectangle {
        id: userAvatar

        implicitWidth: 28
        implicitHeight: implicitWidth
        radius: 8

        Image {
          id: userAvatarImage
          Accessible.role: Accessible.Graphic
          Accessible.name: root.username + "'s avatar"

          anchors.fill: parent
          source: "file:///usr/share/sddm/faces/" + root.username + ".face.icon"
          fillMode: Image.PreserveAspectCrop
        }
      }

      Text {
        id: userName
        Accessible.role: Accessible.StaticText
        Accessible.name: "Current user: " + root.username

        text: root.username
        color: Matugen.primary
        font {
          pixelSize: root.rootFont.pixelSize
          family: root.rootFont.family
          bold: true
        }
      }
    }

    Item { Layout.fillWidth: true }

    RowLayout {
      id: buttons

      Repeater {
        model: [
          { name: "Lock Session", icon: "", cmd: "loginctl lock-session", shortcut: "L" },
          { name: "Power Off", icon: "", cmd: "systemctl poweroff", shortcut: "S" },
          { name: "Reboot", icon: "", cmd: "systemctl reboot", shortcut: "R" },
          { name: "Log Out", icon: "󰍃", cmd: "hyprctl dispatch 'hl.dsp.exit()'", shortcut: "Q" }
        ]

        delegate: Rectangle {
          id: button
          required property var modelData
          Accessible.role: Accessible.Button
          Accessible.name: modelData.name
          Accessible.description: "Execute " + modelData.cmd

          implicitWidth: 28
          implicitHeight: implicitWidth
          color: buttonMouseArea.pressed ? Matugen.on_primary : Matugen.primary
          radius: 8

          Behavior on color {
            ColorAnimation { duration: 150 }
          }

          Text {
            id: buttonText
            Accessible.role: Accessible.StaticText
            Accessible.name: button.modelData.icon

            anchors.centerIn: parent
            text: button.modelData.icon
            color: buttonMouseArea.pressed ? Matugen.primary : Matugen.on_primary

            Behavior on color {
              ColorAnimation { duration: 150 }
            }
          }

          MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            onClicked: {
              if (button.modelData.cmd === "") return
              actionProc.command = ["sh", "-c", button.modelData.cmd + " && quickshell ipc call startMenu toggle"]
              actionProc.running = true
            }
          }

          Shortcut {
            enabled: button.modelData.shortcut !== "" && root.isOpen
            sequence: button.modelData.shortcut
            onActivated: {
              if (button.modelData.cmd === "") return
              actionProc.command = ["sh", "-c", button.modelData.cmd + " && quickshell ipc call startMenu toggle"]
              actionProc.running = true
            }
          }
        }
      }
    }
  }

  Process {
    id: userProc
    command: ["whoami"]
    stdout: SplitParser {
      onRead: data => root.username = data.trim()
    }
    Component.onCompleted: running = true
  }

  Process {
    id: actionProc
  }
}
