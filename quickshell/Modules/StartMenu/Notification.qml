pragma ComponentBehavior: Bound

import Quickshell.Services.Notifications
import Quickshell.Widgets
import Quickshell
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
  Colors { id: colors }
  property font rootFont

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
          onClicked: NotificationService.clearAll()
        }
      }
    }

    ListView {
      id: notificationContent
      Accessible.role: Accessible.List
      Accessible.name: "Notification List"
      model: ScriptModel {
        values: NotificationService.notificationHistory
        objectProp: "seqId"
      }
      spacing: 12

      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true

      delegate: Rectangle {
        id: notificationItem
        required property var modelData

        implicitWidth: ListView.view.width
        implicitHeight: notificationItemContent.implicitHeight + 16
        color: colors.surface_bright
        radius: 8

        Accessible.role: Accessible.StaticText
        Accessible.name: (modelData.urgency === NotificationUrgency.Critical 
          ? "[Critical] " : modelData.urgency === NotificationUrgency.Low      
          ? "[Low] " : "") + (modelData.appName || "Notification") + ": " + modelData.summary


        ColumnLayout {
          id: notificationItemContent

          anchors { fill: parent; margins: 8; leftMargin: 12 }

          RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Item {
              Layout.preferredWidth: root.rootFont.pixelSize * 0.8
              Layout.preferredHeight: root.rootFont.pixelSize * 0.8
              Layout.alignment: Qt.AlignVCenter

              IconImage {
                anchors.centerIn: parent
                source: Quickshell.iconPath(notificationItem.modelData.appIcon, true)
                implicitSize: root.rootFont.pixelSize * 0.8
                visible: notificationItem.modelData.appIcon !== ""
              }

              Text {
                anchors.centerIn: parent
                text: notificationItem.modelData.getIcon()
                color: colors.primary
                font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family }
                visible: notificationItem.modelData.appIcon === ""
              }
            }

            Text {
              text: notificationItem.modelData.appName || "Notification"
              color: colors.primary
              font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family; bold: true }
              Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Rectangle {
              id: notificationItemDismiss

              implicitWidth: root.rootFont.pixelSize * 1.5
              implicitHeight: root.rootFont.pixelSize * 1.5
              color: notificationItemDismissMouseArea.containsMouse ? colors.surface_bright : colors.surface
              radius: root.rootFont.pixelSize / 2

              Text {
                anchors.centerIn: parent
                text: ""
                color: notificationItemDismissMouseArea.containsMouse ? colors.primary_fixed : colors.primary
                font: root.rootFont
              }

              MouseArea {
                id: notificationItemDismissMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: NotificationService.clear(notificationItem.modelData)
              }
            }
          }

          Text {
            Layout.fillWidth: true
            text: notificationItem.modelData.summary.replace(/[^\x00-\x7F]/g, "").trim() 
            color: colors.primary
            font: root.rootFont
            elide: Text.ElideRight
            visible: text !== ""
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: notificationItem.modelData.body !== "" || notificationItem.modelData.image !== ""

            Text {
              id: notificationItemBody
              Layout.fillWidth: true
              text: notificationItem.modelData.body.replace(/[^\x00-\x7F]/g, "").trim() 
              color: colors.secondary
              font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family }
              wrapMode: Text.Wrap
              elide: Text.ElideRight
              maximumLineCount: 2
              visible: text !== ""
            }

            ClippingRectangle {
              Layout.preferredWidth: notificationItemBody.implicitHeight ?? 24
              Layout.preferredHeight: notificationItemBody.implicitHeight ?? 24
              radius: 4
              color: "transparent"
              clip: true
              visible: notificationItem.modelData.image !== ""

              Image {
                anchors.fill: parent
                source: notificationItem.modelData.image
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(notificationItemBody.implicitHeight ?? 24, notificationItemBody.implicitHeight ?? 24)
              }
            }
          }
        }
      }
    }
  }
}
