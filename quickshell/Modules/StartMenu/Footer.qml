pragma ComponentBehavior: Bound

import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

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
          Accessible.role: Accessible.Item
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
        color: colors.primary
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
          { name: "Lock Session", icon: "", cmd: "loginctl lock-session" },
          { name: "Power Off", icon: "", cmd: "systemctl poweroff" },
          { name: "Reboot", icon: "", cmd: "systemctl reboot" },
          { name: "Log Out", icon: "󰍃", cmd: "hyprctl dispatch exit 0" }
        ]

        delegate: Rectangle {
          id: button
          required property var modelData
          Accessible.role: Accessible.Button
          Accessible.name: modelData.name
          Accessible.description: "Execute " + modelData.cmd

          implicitWidth: 28
          implicitHeight: implicitWidth
          color: buttonMouse.pressed ? colors.on_primary : colors.primary
          radius: 8

          Behavior on color {
            ColorAnimation { duration: 150 }
          }

          Text {
            id: buttonText
            Accessible.role: Accessible.StaticText
            Accessible.name: modelData.icon

            anchors.centerIn: parent
            text: button.modelData.icon
            color: buttonMouse.pressed ? colors.primary : colors.on_primary

            Behavior on color {
              ColorAnimation { duration: 150 }
            }
          }

          MouseArea {
            id: buttonMouse
            anchors.fill: parent
            onClicked: {
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
