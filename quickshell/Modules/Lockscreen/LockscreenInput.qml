import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick

import qs.Colors

Item {
  id: root
  Colors { id: colors }
  property font rootFont
  property LockscreenContext context

  implicitHeight: lockscreenInput.implicitHeight

	ColumnLayout {
	  id: lockscreenInput
		// visible: Window.active

		anchors.horizontalCenter: parent.horizontalCenter

		RowLayout {
		  id: inputRow

			TextField {
				id: passwordBox

				implicitWidth: 400
				padding: 10

				focus: true
				enabled: !root.context.unlockInProgress
				echoMode: TextInput.Password
				inputMethodHints: Qt.ImhSensitiveData

				font: root.rootFont
				color: colors.surface
				selectionColor: colors.primary
				selectedTextColor: colors.on_primary

				background: Rectangle {
					radius: 8
					color: colors.surface + 'cc'
					border { 
					  color: root.context.showFailure ? colors.error_container : colors.on_primary
					  width: 2
					}
				}

				opacity: enabled ? 1.0 : 0.5

				onTextChanged: root.context.currentText = this.text;
				onAccepted: root.context.tryUnlock();

				Connections {
					target: root.context

					function onCurrentTextChanged() {
						passwordBox.text = root.context.currentText;
					}
				}
			}

			Button {
				text: "Unlock"
				padding: 10

				focusPolicy: Qt.NoFocus

				enabled: !root.context.unlockInProgress && root.context.currentText !== "";
				onClicked: root.context.tryUnlock();

				contentItem: Text {
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter

					text: parent.text
					font: root.rootFont
					color: colors.primary_fixed
				}

				background: Rectangle {
					color: colors.primary_container
					radius: 8
					
					opacity: !parent.enabled ? 0.5 : (parent.down ? 0.8 : 1.0) 
				}
			}
		}

		Label {
			visible: root.context.showFailure
			text: "Incorrect password"
			color: colors.on_error
		}
	}

	Timer {
    id: errorTimer
    interval: 10 * 000
    running: root.context.showFailure
    onTriggered: root.context.showFailure = false
  }
}
