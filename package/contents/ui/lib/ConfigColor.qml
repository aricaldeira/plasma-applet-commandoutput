// Version 2

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Window

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

import ".."

RowLayout {
	id: configColor
	spacing: 2
	// Layout.fillWidth: true
	Layout.maximumWidth: 300 * Screen.devicePixelRatio

	property alias label: label.text
	property alias horizontalAlignment: label.horizontalAlignment

	property string configKey: ''
	property string defaultColor: ''
	property string value: {
		if (configKey) {
			return plasmoid.configuration[configKey]
		} else {
			return "#000"
		}
	}

	readonly property color defaultColorValue: defaultColor
	readonly property color valueColor: {
		if (value == '' && defaultColor) {
			return defaultColor
		} else {
			return value
		}
	}

	onValueChanged: {
		if (!textField.activeFocus) {
			textField.text = configColor.value
		}
		if (configKey) {
			if (value == defaultColorValue) {
				plasmoid.configuration[configKey] = ""
			} else {
				plasmoid.configuration[configKey] = value
			}
		}
	}

	function setValue(newColor) {
		textField.text = newColor
	}

	Label {
		id: label
		text: "Label"
		Layout.fillWidth: horizontalAlignment == Text.AlignRight
		horizontalAlignment: Text.AlignLeft
	}

	MouseArea {
		id: mouseArea
		width: textField.height
		height: textField.height
		hoverEnabled: true

		onClicked: dialog.open()

		Rectangle {
			anchors.fill: parent
			color: configColor.valueColor
			border.width: 2
			border.color: parent.containsMouse ? Kirigami.Theme.highlightColor : "#BB000000"
		}
	}

	TextField {
		id: textField
		placeholderText: defaultColor ? defaultColor : "#AARRGGBB"
		Layout.fillWidth: label.horizontalAlignment == Text.AlignLeft
		onTextChanged: {
			// Make sure the text is:
			//   Empty (use default)
			//   or #123 or #112233 or #11223344 before applying the color.
			if (text.length === 0
				|| (text.indexOf('#') === 0 && (text.length == 4 || text.length == 7 || text.length == 9))
			) {
				configColor.value = text
			}
		}
	}

	ColorDialog {
		id: dialog
		visible: false
		modality: Qt.WindowModal
		title: configColor.label
		options: ColorDialog.ShowAlphaChannel
		selectedColor: configColor.valueColor
		onAccepted: {
			if (visible && color != currentColor) {
				configColor.value = currentColor
			}
		}
	}
}
