pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons
import qs.Services 

Rectangle {
  id: contentRoot

  property alias searchFieldFocus: searchField.focus

  anchors.bottom: parent.bottom
  implicitWidth: parent.width
  implicitHeight: GlobalState.isClipboardVisible ? parent.height : 0
  
  color: Colors.surface
  topRightRadius: Settings.style.radius
  topLeftRadius: Settings.style.radius
  clip: true

  Behavior on implicitHeight {
    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Settings.style.margin
    spacing: Settings.style.margin

    TextField {
      id: searchField
      Layout.fillWidth: true
      padding: Settings.style.margin * 1.5
      leftPadding: searchIcon.width + Settings.style.margin * 3

      text: root.searchQuery
      placeholderText: "Search clipboard history (text or image preview ID)..."
      font: Settings.getFont()
      color: Colors.on_surface
      
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
        root.filterClips(text)
        clipList.currentIndex = 0
      }

      Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
          GlobalState.isClipboardVisible = false
          event.accepted = true
          return
        }

        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
          const selectedItem = filteredClipModel.get(clipList.currentIndex)
          if (selectedItem) Clipboard.selectItem(selectedItem.clipId)
          GlobalState.isClipboardVisible = false
          event.accepted = true
          return
        }

        if (event.key === Qt.Key_Delete) {
          const selectedItem = filteredClipModel.get(clipList.currentIndex)
          if (selectedItem) Clipboard.deleteItem(selectedItem.clipId)
          event.accepted = true
          return
        }

        if (filteredClipModel.count === 0) return
        const isNext = event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_N)
        const isPrev = event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) || (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P)

        if (isNext || isPrev) {
          event.accepted = true
          let idx = clipList.currentIndex
          if (isNext) idx = Math.min(idx + 1, filteredClipModel.count - 1)
          else if (isPrev) idx = Math.max(idx - 1, 0)
          clipList.currentIndex = idx
        }
      }
    }

    ListView {
      id: clipList
      model: filteredClipModel
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      spacing: Settings.style.margin

      highlightFollowsCurrentItem: true
      keyNavigationEnabled: true

      delegate: ClipboardDelegate {
        required property string clipId
        required property string type
        required property string content

        modelData: {
          "clipId": clipId,
          "type": type,
          "content": content
        }
        
        onClicked: {
          Clipboard.selectItem(clipId)
          GlobalState.isClipboardVisible = false
        }
      }
    }
  }
}
