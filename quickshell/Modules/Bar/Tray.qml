import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont

  implicitWidth: tray.implicitWidth

  Rectangle {
    id: tray
    Accessible.role: Accessible.StaticText
    Accessible.name: "System tray"

    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: trayItems.implicitWidth
    implicitHeight: 24
    color: colors.surface

    RowLayout {
      id: trayItems
      spacing: 2

      Repeater {
        model: SystemTray.items

        delegate: MouseArea {
          id: trayItem
          required property SystemTrayItem modelData
          Accessible.role:  Accessible.Button
          Accessible.name: modelData.tooltipTitle || modelData.title || "System tray item"
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

          Layout.preferredWidth: 24
          Layout.preferredHeight: 24

          IconImage {
            id: trayItemIcon
            anchors.centerIn: parent
            source: modelData.icon
            implicitSize: root.rootFont.pixelSize
          }

          QsMenuAnchor {
            id: trayItemAnchor
            menu: modelData.menu

            anchor {
              window: trayItem.QsWindow.window
              adjustment: PopupAdjustment.Flip
              onAnchoring: {
                const window = trayItem.QsWindow.window;
                const widgetRect =  window.contentItem.mapFromItem(
                  trayItem, 0, trayItem.implicitHeight,
                  trayItem.implicitWidth, trayItem.implicitHeight);
                trayItemAnchor.anchor.rect = widgetRect;
              }
            }
          }

          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) modelData.activate()
            else if (mouse.button === Qt.RightButton && modelData.hasMenu) trayItemAnchor.open()
            else if (mouse.button === Qt.MiddleButton) modelData.secondaryActivate()
          }
        }
      }
    }
  }
}
