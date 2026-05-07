pragma ComponentBehavior: Bound

import Quickshell.Services.Notifications
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  ListModel {
    id: notificationList
  }

  NotificationServer {
    id: notificationServer
    onNotification: notification => {
      notificationList.insert(0, {
        id: notification.id,
        urgency: notification.urgency,
        appName: notification.appName,
        summary: notification.summary.replace(/[^\x00-\x7F]/g, "").trim(),
        body: notification.body 
      })
    }
  } 

  ColumnLayout {
    id: notification
    spacing: 12

    anchors.fill: parent

    RowLayout {
      id: notificationHeader

      Text {
        id: notificationTitle
        Accessible.role: Accessible.StaticText
        Accessible.name: "Notification Title"

        Layout.fillWidth: true
        text: " Notifications"
        color: colors.primary
        font {
          pixelSize: root.rootFont.pixelSize * 1.5
          family: root.rootFont.family
          bold: true
        }
      }

      Rectangle {
        id: notificationClear
        Accessible.role: Accessible.Button
        Accessible.name: "Clear Notifications"

        implicitWidth: root.rootFont.pixelSize * 1.5
        implicitHeight: root.rootFont.pixelSize * 1.5
        color: notificationClearMouse.pressed ? colors.on_primary : colors.primary
        radius: 6

        Text {
          id: notificationClearContent
          Accessible.role: Accessible.StaticText
          Accessible.name: "Clear Notifications Icon"

          anchors.centerIn: parent
          text: "󰎟"
          color: notificationClearMouse.pressed ? colors.primary : colors.on_primary
          font: root.rootFont
        }

        MouseArea {
          id: notificationClearMouse
          anchors.fill: parent
          onClicked: notificationList.clear()
        }
      }
    }

    ListView {
      id: notificationContent
      Accessible.role: Accessible.List
      Accessible.name: "Notification List"
      model: notificationList
      spacing: 12

      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true

      delegate: Rectangle {
        id: notificationItem
        required property var modelData

        implicitWidth: ListView.view.width
        implicitHeight: notificationItemContent.implicitHeight + 16
        color: colors.on_primary
        radius: 8

        ColumnLayout {
          id: notificationItemContent

          anchors.fill: parent
          anchors.margins: 8

          Text {
            id: notificationContentTitle
            text: {
              const icon = " "
              if (notificationItem.modelData.urgency === NotificationUrgency.Critical) icon = " "
              else if (notificationItem.modelData.urgency === NotificationUrgency.Low) icon = " "
              return icon + notificationItem.modelData.summary
            }
            color: colors.primary
            font {
              pixelSize: root.rootFont.pixelSize / 1.5
              family: root.rootFont.family
            }
          }

          Text {
            id: notificationContentDescription

            Layout.fillWidth: true
            text: notificationItem.modelData.body
            color: colors.primary
            font: root.rootFont
            wrapMode: Text.Wrap
          }
        }
      }
    }
  }
}
