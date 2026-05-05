import Quickshell.Services.Notifications

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
  id: notifications

  anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 12 }

  ListModel {
    id: notificationHistory
  }

  NotificationServer {
    id: notificationServer

    onNotification: notification => {
      notificationHistory.insert(0, {
        id: notification.id,
        urgency: notification.urgency,
        appName: notification.appName,
        summary: notification.summary.replace(/[^\x00-\x7F]/g, "").trim(),
        body: notification.body 
      })
    }
  }

  RowLayout {
    id: notificationHeader

    anchors { left: parent.left; right: parent.right }

    Text {
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
        onClicked: notificationHistory.clear()
      }
    }
  }

  ScrollView {
    id: notificationWrapper

    anchors { 
      top: notificationHeader.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
      topMargin: 12
    }

    ColumnLayout {
      id: notificationList

      width: notificationWrapper.availableWidth
      spacing: 12

      Repeater {
        model: notificationHistory

        delegate: Rectangle {
          Layout.fillWidth: true
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

          ColumnLayout {
            id: contentColumn

            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 8 }
            spacing: 4

            Text {
              text: model.body ? model.summary : model.appName
              color: model.urgency === NotificationUrgency.Critical ?
                colors.error : model.urgency === NotificationUrgency.Low ?
                colors.secondary : colors.primary
              font { pixelSize: startMenu.fontSize / 2; family: startMenu.fontFamily; bold: true }
              Layout.fillWidth: true
              elide: Text.ElideRight
            }

            Text {
              text: model.body ? model.body : model.summary
              color: model.urgency === NotificationUrgency.Critical ?
                colors.error : model.urgency === NotificationUrgency.Low ?
                colors.secondary : colors.primary
              font { pixelSize: startMenu.fontSize / 1.5; family: startMenu.fontFamily }
              Layout.fillWidth: true
              wrapMode: Text.Wrap
            }
          }
        }
      }
    }
  }
}
