pragma ComponentBehavior: Bound

import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import Quickshell
import QtQuick.Layouts
import QtQuick

import "../../Services"

Scope {
  id: root
  property font rootFont: Qt.font({
    pixelSize: 14,
    family: "GeistMono Nerd Font"
  })

  IpcHandler {
    target: 'notification'

    function clear(): void {
      NotificationService.clear()
    }

    function is_dnd(): bool {
      return NotificationService.isDoNotDisturb
    }

    function toggle_dnd(): void {
      NotificationService.isDoNotDisturb = !NotificationService.isDoNotDisturb
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: notificationPanel
      required property var modelData
      screen: modelData
      visible: NotificationService.notifications.length > 0

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      WlrLayershell.exclusiveZone: -1
      WlrLayershell.namespace: "notifications"
      exclusionMode: ExclusionMode.Ignore

      anchors { top: true; right: true; }
      focusable: false
      color: "transparent"
      implicitWidth: 1920 / 5
      implicitHeight: notificationLayout.implicitHeight + 32

      ColumnLayout {
        id: notificationLayout
        visible: !GlobalState.isStartMenuOpen && NotificationService.notifications.length > 0

        anchors { fill: parent; topMargin: 32; rightMargin: 12 }
        implicitWidth: parent.width
        spacing: 8

        Repeater {
          model: ScriptModel {
            values: NotificationService.notifications
            objectProp: "seqId"
          }

          delegate: Rectangle {
            id: notificationItem
            required property var modelData

            Layout.fillWidth: true
            Layout.preferredHeight: notificationItemContent.implicitHeight + 28
            color: Matugen.surface
            border { color: Matugen.on_primary; width: 2 }
            radius: 12
            clip: true

            x: 1920 / 5
            Component.onCompleted: x = 0
            Behavior on x { 
              NumberAnimation { duration: 250; easing.type: Easing.OutCubic } 
            }

            Accessible.role: Accessible.StaticText
            Accessible.name: (modelData.urgency === NotificationUrgency.Critical 
              ? "[Critical] " : modelData.urgency === NotificationUrgency.Low      
              ? "[Low] " : "") + (modelData.appName || "Notification") + ": " + modelData.summary

            HoverHandler {
              id: cardHover
              onHoveredChanged: notificationItem.modelData.hovered = hovered
            }

            ColumnLayout {
              id: notificationItemContent
              anchors { fill: parent; margins: 12; leftMargin: 16 }
              spacing: 6

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
                    color: Matugen.primary
                    font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family }
                    visible: notificationItem.modelData.appIcon === ""
                  }
                }

                Text {
                  text: notificationItem.modelData.appName || "Notification"
                  color: Matugen.primary
                  font { pixelSize: root.rootFont.pixelSize * 0.8; family: root.rootFont.family; bold: true }
                  Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                  id: notificationItemDismiss

                  implicitWidth: root.rootFont.pixelSize * 1.5
                  implicitHeight: root.rootFont.pixelSize * 1.5
                  color: notificationItemDismissMouseArea.containsMouse ? Matugen.surface_bright : Matugen.surface
                  radius: root.rootFont.pixelSize / 2

                  Text {
                    anchors.centerIn: parent
                    text: ""
                    color: notificationItemDismissMouseArea.containsMouse ? Matugen.primary : Matugen.secondary
                    font: root.rootFont
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
                color: Matugen.primary
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
                  color: Matugen.secondary
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

              Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 2
                implicitHeight: 2
                radius: 1
                color: Matugen.surface

                Rectangle {
                  id: notificationItemProgress
                  implicitHeight: parent.height
                  implicitWidth: parent.width
                  color: Matugen.primary
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
        }
      }
    }
  }
}
