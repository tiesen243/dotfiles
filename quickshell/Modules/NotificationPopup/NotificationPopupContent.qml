pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.NotificationService

ColumnLayout {
  id: notificationLayout
  
  visible: !GlobalState.isControlCenterVisible && NotificationService.notifications.length > 0

  anchors { 
    fill: parent
    topMargin: GlobalState.isBarVisible ? Settings.bar.size + 4 : 4
    rightMargin: 4
  }
  implicitWidth: parent.width - 4
  spacing: Settings.style.margin

  Repeater {
    model: ScriptModel {
      values: NotificationService.notifications ? NotificationService.notifications : []
      objectProp: "seqId"
    }

    delegate: NotificationPopupDelegate {}
  }
}
