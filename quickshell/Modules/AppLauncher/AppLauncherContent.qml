pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons
import qs.Services

Rectangle {
  id: appLauncherContent
  
  property alias searchFieldFocus: searchField.focus

  Accessible.role: Accessible.Dialog
  Accessible.name: "Application Launcher"

  anchors.bottom: parent.bottom
  implicitWidth: parent.width
  implicitHeight: GlobalState.isAppLauncherVisible ? parent.height : 0
  
  color: Colors.surface
  topRightRadius: Settings.style.radius
  topLeftRadius: Settings.style.radius
  clip: true

  Behavior on implicitHeight {
    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
  }

  ColumnLayout {
    Accessible.role: Accessible.List
    Accessible.name: "Application List"

    anchors.fill: parent
    anchors.margins: Settings.style.margin
    spacing: Settings.style.margin

    TextField {
      id: searchField
      Accessible.role: Accessible.EditableText
      Accessible.name: "Search Applications"

      Layout.fillWidth: true
      padding: Settings.style.margin * 1.5
      leftPadding: searchIcon.width + Settings.style.margin * 3

      text: root.searchQuery
      placeholderText: "Search applications..."
      font: Settings.getFont()
      color: Colors.on_surface
      selectionColor: Colors.primary
      selectedTextColor: Colors.on_primary

      background: Rectangle {
        anchors.fill: parent
        color: Colors.surface
        border { color: Colors.border; width: 1 }
        radius: Settings.style.radius

        Text {
          id: searchIcon
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          anchors.leftMargin: Settings.style.margin * 1.5
          text: ""
          font: Settings.getFont()
          color: Colors.on_surface
        }
      }

      onTextChanged: {
        root.searchQuery = text
        root.filterApps(text)
        appList.currentIndex = 0
      }

      Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
          GlobalState.toggleAppLauncher()
          event.accepted = true
          return
        }

        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
          const selectedItem = filteredAppModel.get(appList.currentIndex)
          if (selectedItem) Apps.launch(selectedItem.exec, selectedItem.terminal)

          GlobalState.toggleAppLauncher()
          event.accepted = true
          return
        }

        if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_R) {
          Apps.refresh()
          event.accepted = true
          return
        }

        if (filteredAppModel.count === 0) return
        const isNext = event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_N)
        const isPrev = event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P)

        if (isNext || isPrev) {
          event.accepted = true
          let idx = appList.currentIndex
          if (isNext) idx = Math.min(idx + 1, filteredAppModel.count - 1)
          else if (isPrev) idx = Math.max(idx - 1, 0)
          appList.currentIndex = idx
        }
      }
    }

    ListView {
      id: appList
      model: filteredAppModel
      Accessible.role: Accessible.List
      Accessible.name: "Filtered Application List"

      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      spacing: Settings.style.margin

      highlightFollowsCurrentItem: true
      keyNavigationEnabled: true

      delegate: AppLauncherDelegate {
        required property string name
        required property string exec
        required property string icon
        required property bool terminal

        modelData: {
          "name": name,
          "exec": exec,
          "icon": icon,
          "terminal": terminal
        }
        
        onClicked: {
          Apps.launch(exec, terminal)
          GlobalState.toggleAppLauncher()
        }
      }
    }
  }
}
