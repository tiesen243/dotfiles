import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick

import "../../Services"

Item {
  id: root
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
				placeholderText: "Enter password"

				font: root.rootFont
				color: Matugen.on_surface
				selectionColor: Matugen.on_primary
				selectedTextColor: Matugen.primary

				background: Rectangle {
					radius: 8
					color: Matugen.surface
					border { 
					  color: root.context.showFailure ? Matugen.error : Matugen.primary
					  width: 1
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
					color: Matugen.primary
				}

				background: Rectangle {
					color: Matugen.surface
					border { 
            color: Matugen.primary
            width: 1
          }
					radius: 8
					
					opacity: !parent.enabled ? 0.5 : (parent.down ? 0.8 : 1.0) 
				}
			}
		}

		Label {
			visible: root.context.showFailure
			text: "Incorrect password"
			color: Matugen.error
		}
	}

	Timer {
    id: errorTimer
    interval: 10 * 1000
    running: root.context.showFailure
    onTriggered: root.context.showFailure = false
  }
}
