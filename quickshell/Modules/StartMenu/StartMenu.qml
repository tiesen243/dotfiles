import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Notifications

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.Colors

Item {
  id: startMenu
  property string fontFamily
  property int fontSize
  property var anchor

  Colors { id: colors }

  anchors.verticalCenter: parent.verticalCenter
  anchors.left: parent.left
  anchors.margins: 8

  implicitWidth: startMenuTrigger.width
  implicitHeight: startMenuTrigger.height

  IpcHandler {
    target: "startMenu"

    function toggle(): void {
      startMenuContent.visible = !startMenuContent.visible
    }
  }

  property bool wifiEnable: true
  property bool bluetoothEnable: true
  property bool powerSavingEnable: true
  property string debug: ""

  Process {
    id: wifiProc
    command: ["nmcli", "radio", "wifi"]
    stdout: SplitParser {
      onRead: data => startMenu.wifiEnable = (data.trim() === 'enabled')
    }
    Component.onCompleted: running = true
  }

  Process {
    id: toggleWifiProc
    command: ["nmcli", "radio", "wifi", startMenu.wifiEnable ? "off" : "on"]
    stdout: StdioCollector {
      onStreamFinished: wifiProc.running = true
    }
  }

  Process {
    id: bluetoothProc
    command: ["bluetoothctl", "show"]
    stdout: SplitParser {
      onRead: data => {
        if (data.includes("Powered: yes")) startMenu.bluetoothEnable = true
        else if (data.includes("Powered: no")) startMenu.bluetoothEnable = false
      }
    }
  }

  Process {
    id: toggleBluetoothProc
    command: ["bluetoothctl", "power", startMenu.bluetoothEnable ? "off" : "on"]
    stdout: StdioCollector {
      onStreamFinished: bluetoothProc.running = true
    }
  }

  Process {
    id: powerSavingProc
    command: ["powerprofilesctl", "get"]
    stdout: SplitParser {
      onRead: data => startMenu.powerSavingEnable = (data.trim() === 'power-saver')
    }
    Component.onCompleted: running = true
  }

  Process {
    id: togglePowerSavingProc
    command: ["powerprofilesctl", "set", startMenu.powerSavingEnable ? "balanced" : "power-saver"]
    stdout: StdioCollector {
      onStreamFinished: powerSavingProc.running = true
    }
  }

  Text {
    id: startMenuTrigger

    text: "󰣇"
    color: colors.primary
    font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily }

    MouseArea {
      anchors.fill: parent
      onClicked: mouse => {
        startMenuContent.visible = !startMenuContent.visible
      }
    }
  }

  PopupWindow {
    id: startMenuContent
    visible: false

    anchor.window: startMenu.anchor
    anchor.rect.x: 0
    anchor.rect.y: parentWindow.implicitHeight + 4

    implicitWidth: 1920 / 4
    implicitHeight: 1080 / 2
    color: "transparent"

    HyprlandFocusGrab {
      active: startMenuContent.visible
      windows: [startMenuContent]
      onCleared: {
        startMenuContent.visible = false
      }
    }

    Rectangle {
      anchors.fill: parent
      color: colors.background
      radius: 8
      border { color: colors.primary; width: 1 }

      Text {
        id: clock
        anchors { top: parent.top; left: parent.left; margins: 12 }
        text: Qt.formatDateTime(new Date(), "hh:mm:ss")
        color: colors.primary
        font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily; bold: true }

        Timer {
          interval: 1000
          running: true
          repeat: true
          onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
      }

      GridLayout {
        id: toggleButtons

        anchors { top: parent.top; left: parent.left; margins: 12; topMargin: clock.height + 16 }
        columnSpacing: 12
        columns: 3
        rowSpacing: 12
        rows: 2

        Repeater {
          model: [
            { icon: '', isActive: startMenu.wifiEnable, toggle: toggleWifiProc },
            { icon: '󰂯', isActive: startMenu.bluetoothEnable, toggle: toggleBluetoothProc },
            { icon: '', isActive: startMenu.powerSavingEnable, toggle: togglePowerSavingProc }
          ]

          Rectangle {
            color: modelData.isActive ? colors.primary : colors.on_primary
            implicitWidth: (startMenuContent.width / 3) - 16
            implicitHeight: 40
            radius: 6

            Text {
              anchors.centerIn: parent
              text: modelData.icon
              color: modelData.isActive ? colors.on_primary : colors.primary
              font { pixelSize: startMenu.fontSize }
            }

            MouseArea {
              anchors.fill: parent
              onClicked: modelData.toggle.running = true
            }
          }
        }
      }

      ScrollView {
        id: notificationWrapper

        implicitWidth: availableWidth

        anchors { 
          fill: parent
          top: parent.top
          left: parent.left
          margins: 12
          topMargin: clock.height + toggleButtons.height + 16 * 2 
        }

        ListModel {
          id: notificationHistory
        }

        NotificationServer {
          id: notificationServer

          onNotification: notification => {
            notificationHistory.append({
              id: notification.id,
              urgency: notification.urgency,
              appName: notification.appName,
              summary: notification.summary.replace(/[^\x00-\x7F]/g, "").trim(),
              body: notification.body 
            })
          }
        }

        property var trackedNotifications: notificationServer.trackedNotifications

        ColumnLayout {
          id: notificationList

          width: notificationWrapper.availableWidth
          spacing: 12

          RowLayout {
            Layout.fillWidth: true

            Text {
              Layout.fillWidth: true
              text: "Notifications"
              color: colors.primary
              font { pixelSize: startMenu.fontSize; family: startMenu.fontFamily; bold: true }
            }

            Rectangle {
              id: clearButton

              Layout.alignment: Qt.AlignRight
              implicitWidth: 32
              implicitHeight: 32
              radius: 8
              color: clearButtonArea.pressed ? colors.on_secondary : colors.on_primary

              Text {
                anchors.centerIn: parent
                text: ""
                color: colors.primary
                font { pixelSize: startMenu.fontSize / 1.5; family: startMenu.fontFamily }
              }

              MouseArea {
                id: clearButtonArea

                anchors.fill: parent
                onClicked: {
                  notificationHistory.clear()
                }
              }
            }
          }

          Repeater {
            model: notificationHistory

            delegate: Rectangle {
              implicitWidth: startMenuContent.implicitWidth - (12 * 2)
              implicitHeight: contentColumn.implicitHeight + 16
              radius: 8
              color: model.urgency === NotificationUrgency.Critical ?
                colors.error_container : model.urgency === NotificationUrgency.Low ?
                colors.secondary_container : colors.primary_container
              border { 
                color: model.urgency === NotificationUrgency.Critical ?
                  colors.on_error : model.urgency === NotificationUrgency.Low ?
                  colors.on_secondary : colors.on_primary
                width: 2
              }

              Column {
                id: contentColumn
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
                spacing: 4

                Text {
                  text: model.body ? model.summary : model.appName
                  color: model.urgency === NotificationUrgency.Critical ?
                    colors.error : model.urgency === NotificationUrgency.Low ?
                    colors.secondary : colors.primary
                  font { pixelSize: startMenu.fontSize / 3; family: startMenu.fontFamily; bold: true }
                  width: parent.width
                  elide: Text.ElideRight
                }

                Text {
                  text: model.body ? model.body : model.summary
                  color: model.urgency === NotificationUrgency.Critical ?
                    colors.error : model.urgency === NotificationUrgency.Low ?
                    colors.secondary : colors.primary
                  font { pixelSize: startMenu.fontSize / 1.5; family: startMenu.fontFamily }
                  width: parent.width
                  wrapMode: Text.Wrap
                }
              }
            }
          }
        }
      }
    }
  }
}
