import QtQuick 1.1
import com.victron.velib 1.0
import "utils.js" as Utils

MbPage {
	id: root
	title: qsTr("System Shutdown")
	VBusItem { id: shutdownItem; bind: Utils.path("com.victronenergy.shutdown", "/Shutdown") }
	VBusItem { id: externalShutdown; bind: Utils.path("com.victronenergy.shutdown", "/ExtShutdownPresent") }
	property bool externalShutdownPresent: externalShutdown.valid && externalShutdown.value === 1

	model: VisibleItemModel {
		MbItemText {
			text: qsTr("ShutdownMonitor not running")
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignLeft
			show: !shutdownItem.valid
		}
		MbSwitch {
			id: externalShutdownSwitch
			name: qsTr("Enable shutdown pin on Raspberry Pi")
			bind: Utils.path("com.victronenergy.settings", "/Settings/ShutdownMonitor/ExternalSwitch")
			writeAccessLevel: User.AccessInstaller
			show: externalShutdownPresent
		}
		MbOK {
			id: shutdown
			description: qsTr("Shutdown?")
			writeAccessLevel: User.AccessUser
			onClicked: {
				toast.createToast(qsTr("Shutting down..."), 10000, "icon-restart-active")
				if (shutdownItem.valid)
					shutdownItem.setValue(1)
			}
			show: shutdownItem.valid
		}
	}
}
