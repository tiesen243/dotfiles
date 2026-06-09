import Quickshell.Widgets
import Quickshell
import QtQuick.Layouts
import QtQuick

import qs.Commons
import qs.Services.NotificationService

Item {
  id: root

  Layout.fillWidth: true
  Layout.fillHeight: true
  anchors.margins: Settings.style.margin

  ColumnLayout {
    id: notifications
    spacing: Settings.style.margin
    anchors.fill: parent

    RowLayout {
      id: notificationsHeader
      Layout.fillWidth: true

      Text {
        id: notificationsHeaderText
        text: "Notifications"
        color: Colors.on_surface
        font: Settings.getFont(18, true)
        Layout.fillWidth: true
      }

      Rectangle {
        id: notificationsHeaderClearButton
        implicitWidth: 18
        implicitHeight: 18
        color: Colors.primary
        radius: Settings.style.radius / 2

        Text {
          anchors.centerIn: parent
          text: "󰎟"
          color: Colors.on_primary
          font: Settings.getFont(12)
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: NotificationService.clearAll()
        }
      }
    }

    ListView {
      id: notificationsList
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: NotificationService.notificationHistory
      clip: true
      spacing: Settings.style.margin

      remove: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: 150 }
      }

      displaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutCubic }
      }

      delegate: Item {
        id: notificationContainer
        required property var modelData

        implicitWidth: notificationsList.width
        implicitHeight: isRemoved ? 0 : (notificationItemContent.implicitHeight + Settings.style.margin * 2)

        property bool isRemoved: false
        ListView.delayRemove: isRemoved

        Behavior on implicitHeight {
          NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Rectangle {
          anchors.fill: parent
          color: Colors.surface
          radius: Settings.style.radius
          visible: notificationItem.x !== 0
        }

        Rectangle {
          id: notificationItem
          width: parent.width
          height: notificationItemContent.implicitHeight + Settings.style.margin * 2
          color: Colors.on_primary
          radius: Settings.style.radius
          clip: true

          Behavior on x {
            enabled: !notificationItemDragArea.drag.active
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
          }

          ColumnLayout {
            id: notificationItemContent
            anchors.fill: parent
            anchors.margins: Settings.style.margin
            spacing: Settings.style.margin / 2

            RowLayout {
              Layout.fillWidth: true
              spacing: Settings.style.margin / 1.5

              Item {
                Layout.preferredWidth: 12
                Layout.preferredHeight: 12

                IconImage {
                  anchors.centerIn: parent
                  source: Quickshell.iconPath(notificationContainer.modelData.appIcon, true)
                  implicitSize: 12
                  visible: notificationContainer.modelData.appIcon !== ""
                }

                Text {
                  anchors.centerIn: parent
                  text: notificationContainer.modelData.getIcon()
                  color: Colors.primary
                  font: Settings.getFont(12)
                  visible: notificationContainer.modelData.appIcon === ""
                }
              }

              Text {
                text: notificationContainer.modelData.appName || "NotificationService"
                color: Colors.primary
                font: Settings.getFont(12, true)
              }
            }

            Text {
              Layout.fillWidth: true
              text: notificationContainer.modelData.summary.replace(/[^\x00-\x7F]/g, "").trim() 
              color: Colors.primary
              font: Settings.getFont()
              elide: Text.ElideRight
              visible: text !== ""
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: Settings.style.margin
              visible: notificationContainer.modelData.body !== "" || notificationContainer.modelData.image !== ""

              Text {
                id: notificationItemBody
                Layout.fillWidth: true
                text: notificationContainer.modelData.body.replace(/[^\x00-\x7F]/g, "").trim() 
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
                visible: notificationContainer.modelData.image !== ""

                Image {
                  anchors.fill: parent
                  source: notificationContainer.modelData.image
                  fillMode: Image.PreserveAspectCrop
                  sourceSize: Qt.size(
                    notificationItemBody.implicitHeight > 0 ? notificationItemBody.implicitHeight : 24, 
                    notificationItemBody.implicitHeight > 0 ? notificationItemBody.implicitHeight : 24
                  )
                }
              }
            }
          }

          MouseArea {
            id: notificationItemDragArea
            anchors.fill: parent

            drag.target: notificationItem
            drag.axis: Drag.XAxis

            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: {
              cursorShape = Qt.PointingHandCursor
              const threshold = parent.width * 0.35

              if (Math.abs(notificationItem.x) > threshold) {
                notificationItem.x = -parent.width
                notificationContainer.isRemoved = true
                NotificationService.clear(notificationContainer.modelData)
              } else notificationItem.x = 0
            }
          }
        }
      }
    }
  }
}
