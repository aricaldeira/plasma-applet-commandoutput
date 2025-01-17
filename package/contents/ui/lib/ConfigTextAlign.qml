// Version 2

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	id: configTextAlign

	property string configKey: ''
	readonly property string configValue: configKey ? plasmoid.configuration[configKey] : ""
	
	property alias before: labelBefore.text
	property alias after: labelAfter.text

	function setValue(val) {
		if (configKey) {
			plasmoid.configuration[configKey] = val
		}
		updateChecked()
	}

	function updateChecked() {
		// button.checked bindings are unbound when clicked
		justifyLeftButton.checked = Qt.binding(function(){ return configValue == Text.AlignLeft })
		justifyCenterButton.checked = Qt.binding(function(){ return configValue == Text.AlignHCenter })
		justifyRightButton.checked = Qt.binding(function(){ return configValue == Text.AlignRight })
		justifyFillButton.checked = Qt.binding(function(){ return configValue == Text.AlignJustify })
	}

	Component.onCompleted: updateChecked()

	Label {
		id: labelBefore
		text: ""
		visible: text
	}
	
	Button {
		id: justifyLeftButton
		icon.name: "format-justify-left-symbolic"
		checkable: true
		onClicked: setValue(Text.AlignLeft)
	}

	Button {
		id: justifyCenterButton
		icon.name: "format-justify-center-symbolic"
		checkable: true
		onClicked: setValue(Text.AlignHCenter)
	}

	Button {
		id: justifyRightButton
		icon.name: "format-justify-right-symbolic"
		checkable: true
		onClicked: setValue(Text.AlignRight)
	}

	Button {
		id: justifyFillButton
		icon.name: "format-justify-fill-symbolic"
		checkable: true
		onClicked: setValue(Text.AlignJustify)
	}

	Label {
		id: labelAfter
		text: ""
		visible: text
	}
}
