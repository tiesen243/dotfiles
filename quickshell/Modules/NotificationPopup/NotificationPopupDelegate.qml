pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.Commons

Rectangle {
  id: notificationItem
  
  required property var modelData

  Layout.fillWidth: true
  Layout.preferredHeight: notificationItemContent.implicitHeight + Settings.style.margin * 2 + 4
  color: Colors.surface
  border { color: Colors.primary; width: 1 }
  radius: Settings.style.radius

  x: 1920 / 5
  Component.onCompleted: x = 0
  Behavior on x { 
    NumberAnimation { duration: 250; easing.type: Easing.OutCubic } 
  }

  Accessible.role: Accessible.StaticText
  Accessible.name: (modelData.urgency === NotificationUrgency.Critical 
    ? "[Critical] " : modelData.urgency === NotificationUrgency.Low      
    ? "[Low] " : "") + (modelData.appName || "NotificationService") + ": " + modelData.summary

  HoverHandler {
    id: cardHover
    onHoveredChanged: notificationItem.modelData.hovered = hovered
  }

  ColumnLayout {
    id: notificationItemContent
    anchors { fill: parent; margins: Settings.style.margin; leftMargin: Settings.style.margin * 1.5 }
    spacing: Settings.style.margin

    RowLayout {
      Layout.fillWidth: true
      spacing: Settings.style.margin / 1.5

      Item {
        Layout.preferredWidth: 12
        Layout.preferredHeight: 12
        Layout.alignment: Qt.AlignVCenter

        IconImage {
          anchors.centerIn: parent
          source: Quickshell.iconPath(notificationItem.modelData.appIcon, true)
          implicitSize: 12
          visible: notificationItem.modelData.appIcon !== ""
        }

        Text {
          anchors.centerIn: parent
          text: notificationItem.modelData.getIcon()
          color: Colors.primary
          font: Settings.getFont(12)
          visible: notificationItem.modelData.appIcon === ""
        }
      }

      Text {
        text: notificationItem.modelData.appName || "NotificationService"
        color: Colors.primary
        font: Settings.getFont(12, true)
        Layout.alignment: Qt.AlignVCenter
      }

      Item { Layout.fillWidth: true }

      Rectangle {
        id: notificationItemDismiss
        implicitWidth: 21
        implicitHeight: 21
        color: notificationItemDismissMouseArea.containsMouse ? Colors.surface_bright : Colors.surface
        radius: Settings.style.radius

        Text {
          anchors.centerIn: parent
          text: ""
          color: notificationItemDismissMouseArea.containsMouse ? Colors.primary : Colors.secondary
          font: Settings.getFont()
        }

        MouseArea {
          id: notificationItemDismissMouseArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: notificationItem.modelData.dismiss()
        }
      }
    }

    Text {
      Layout.fillWidth: true
      text: notificationItem.modelData.summary.replace(/[^\x00-\x7F]/g, "").trim() 
      color: Colors.primary
      font: Settings.getFont()
      elide: Text.ElideRight
      visible: text !== ""
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Settings.style.margin
      visible: notificationItem.modelData.body !== "" || notificationItem.modelData.image !== ""

      Text {
        id: notificationItemBody
        Layout.fillWidth: true
        text: notificationItem.modelData.body.replace(/[^\x00-\x7F]/g, "").trim() 
        color: Colors.secondary
        font: Settings.getFont(12)
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        maximumLineCount: 2
        visible: text !== ""
      }

      ClippingRectangle {
        Layout.preferredWidth: notificationItemBody.implicitHeight > 0 ? notificationItemBody.implicitHeight : 24
        Layout.preferredHeight: notificationItemBody.implicitHeight > 0 ? notificationItemBody.implicitHeight : 24
        radius: Settings.style.radius / 2
        color: "transparent"
        clip: true
        visible: notificationItem.modelData.image !== ""

        Image {
          anchors.fill: parent
          source: notificationItem.modelData.image
          fillMode: Image.PreserveAspectCrop
          sourceSize: Qt.size(
            notificationItemBody.implicitHeight > 0 ? notificationItemBody.implicitHeight : 24, 
            notificationItemBody.implicitHeight > 0 ? notificationItemBody.implicitHeight : 24
          )
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.topMargin: 2
      implicitHeight: 2
      radius: 1
      color: Colors.surface

      Rectangle {
        id: notificationItemProgress
        implicitHeight: parent.height
        implicitWidth: parent.width
        color: Colors.primary
        opacity: 0.6

        SequentialAnimation {
          running: notificationItem.modelData.urgency !== NotificationUrgency.Critical && !notificationItem.modelData.hovered
          PauseAnimation { duration: 50 }
          NumberAnimation {
            target: notificationItemProgress
            property: "implicitWidth"
            to: 0
            duration: notificationItem.modelData.expireTimeout > 0
              ? notificationItem.modelData.expireTimeout * 1000
              : 5000
          }
        }
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: notificationItem.modelData.dismiss()
  }
}
