pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami


Kirigami.FormLayout {
	id: root

	//lines to appease kde/fedora qml
	required property var configDialog
	required property var wallpaperConfiguration

	//vars fetched from configuration
	property string cfg_Wallpapers
	property int cfg_Mode

	//local storage of items from wallpapers initialized to empty
	property var items: []

	// mode control int 0 = rigid; 1 = smooth
	property int currentMode: 0


	//vars to detect whether replacing image or adding
	//selected index is selected index
	property int selectedIndex: 0
	property bool replacingImage: false

	//this segment loads configuration on start
	Component.onCompleted: {
		loadConfig()
	}

	//loads configuration function
	//attempts to safely load wallpapers into items as a js object
	//also updates Mode
	function loadConfig(){
		//try catch to update wallpapers
		try{
			root.items = JSON.parse(cfg_Wallpapers || "[]")
		} catch (e) {
			root.items = []
		}

		//update entryList model
		entryList.clear()
		for (let i = 0; i < root.items.length; i++){
			entryList.append({
				time: root.items[i].time,
				imagePath: root.items[i].path
			})
		}
		
		//update mode
		root.currentMode = cfg_Mode
		modeBox.currentIndex = root.currentMode
	}

	//save config function to save program values into actual configuration files
	function saveConfig(){
		root.cfg_Wallpapers = JSON.stringify(root.items)
		root.cfg_Mode = root.currentMode

	}

	//cool heading
	Kirigami.Heading {
		text: "Wallpapers"
		level: 2
		Layout.fillWidth: true
	}

	Controls.Label {
		text: "Double-click an entry to change its image."
		opacity: 0.7
		Layout.fillWidth: true
		wrapMode: Text.WordWrap
	}


	//declaration for the list of wallpapers
	Kirigami.AbstractCard {
		implicitWidth: 300
		implicitHeight: 500

		contentItem: ListView {
			model: entryList
			delegate: listDelegate
			clip:true
			spacing: 8
		}
	}

	//define the list model
	ListModel{
		id: entryList
	}

	//Defines each component of the list
	Component {
		id: listDelegate

		Controls.ItemDelegate{
			id: delegateRoot

			//required properties for item
			required property string time
			required property string imagePath
			required property int index

			//sizing
			width: ListView.view.width
			height: 72

			//when an entry is clicked open dialogue to replace image
			onClicked: {
				root.selectedIndex = delegateRoot.index
				root.replacingImage = true;
				fileDialog.open()
			}

			//layout for each row
			contentItem: RowLayout {
				spacing: 12

				//image properties
				Image {
					Layout.preferredWidth: 96
					Layout.preferredHeight: 54
					fillMode: Image.PreserveAspectCrop
					source: delegateRoot.imagePath
				}

				//text information properties
				Controls.TextField {
					id: timeField

					text: delegateRoot.time
					placeholderText: "00:00"
					Layout.preferredWidth: 90

					//function to update and check if time is valid
					function commitTime() {
						const validTime = root.getValidTime(delegateRoot.index, timeField.text)


						entryList.setProperty(delegateRoot.index, "time", validTime)
						root.items[delegateRoot.index].time = validTime
						timeField.text = validTime

						root.saveConfig()
					}

					//when enter clicked unfocus the box and commit
					onAccepted: {
						focus = false
						commitTime()
					}

					onActiveFocusChanged: {
						if(!activeFocus){
							commitTime()
						}
					}

				}
			}

		}
	}

	//function to convert string time to minutes
	function timeToMinutes(time){
		const parts = time.split(":")
		return Number(parts[0]) * 60 + Number(parts[1])
	}

	//function to convert minuts abck to string time
	function minutesToTime(minutes){
		minutes = minutes % 1440

		const hours = Math.floor(minutes / 60)
		const mins = minutes % 60 

		return String(hours).padStart(2,"0") + ":" + String(mins).padStart(2, "0")
	}


	//function to check for a valid time
	function getValidTime(currentIndex, newTime) {
		// Must be exactly HH:MM
		const timeRegex = /^([0-1][0-9]|2[0-3]):([0-5][0-9])$/

		if (!timeRegex.test(newTime)) {
			return root.items[currentIndex].time
		}

		const newMinutes = timeToMinutes(newTime)

		if(currentIndex > 0){
			const prevMinutes = timeToMinutes(root.items[currentIndex - 1].time)

			if (newMinutes <= prevMinutes) {
				return root.items[currentIndex].time
			}
		}

		if(currentIndex < root.items.length - 1){
			const nextMinutes = timeToMinutes(root.items[currentIndex + 1].time)

			if(newMinutes >= nextMinutes){
				return root.items[currentIndex].time
			}
		}

		return newTime
	}

	//file selection logic based on replacing image or adding new one
	FileDialog {
		id: fileDialog
		title: "Choose wallpaper image"

		nameFilters: ["Images (*.png *.jpg *.jpeg *.webp *.avif)"]

		onAccepted: {
			if(root.replacingImage){
				root.replaceWallpaper(selectedFile.toString())
				root.replacingImage = false
			}else{
				root.addWallpaper(selectedFile.toString())
			}
		}
	}

	//bottom buttons layout
	RowLayout {
		spacing: 80

		ColumnLayout {
			Controls.Label {
				text: "Add a new wallpaper"
				font: Kirigami.Theme.smallFont
				opacity: 0.7
			}
			Controls.Button {
				text: "Add Wallpaper"
				onClicked: fileDialog.open()
			}
		}

		ColumnLayout {
			Controls.Label{
				text: "Remove last wallpaper"
				font: Kirigami.Theme.smallFont 
				opacity: 0.7
			}
			Controls.Button {
				text: "Remove Last"
				enabled: root.items.length > 1 
				onClicked: root.removeLastWallpaper()
			}
		}

		ColumnLayout {
			Controls.Label{
				text: "Transition Mode"
				font: Kirigami.Theme.smallFont 
				opacity: 0.7
			}
			Controls.ComboBox {
				id: modeBox

				model: ["Rigid", "Smooth"]

				onActivated: {
					root.currentMode = modeBox.currentIndex
					root.saveConfig()
				}
			}
		}
	}

	//seperater for aesthetics
	Kirigami.Separator {
		Layout.fillWidth: true
		Layout.topMargin: Kirigami.Units.largeSpacing
		Layout.bottomMargin: Kirigami.Units.smallSpacing
	}
	//text to mention update time
	Controls.Label {
		text: "After you adjust wallpapers or times and hit apply, it will take up to 1 minute to see changes on your actual desktop wallpaper."
		opacity: 0.7
		Layout.fillWidth: true
		wrapMode: Text.WordWrap
	}


	//dialogue to throw if attempting to add past 23:59
	Kirigami.PromptDialog {
		id: invalidEntry
		title: "Hourglass Debug"
		subtitle: "Cannot insert item into list if last entry is 23:59 since later entries must have a later time"
		standardButtons: Kirigami.Dialog.Ok
	}

	//add wallpaper function to check time and add on new entry
	function addWallpaper(imagePath){
		if(root.items[root.items.length - 1].time === "23:59"){
			invalidEntry.open()
			return
		}
		const previousTime = root.items[root.items.length -1].time

		let previousTimeMinutes = timeToMinutes(previousTime)
		let newTimeMinutes = previousTimeMinutes + 1 

		const newTime = minutesToTime(newTimeMinutes)

		const newEntry = {
			path: imagePath,
			time: newTime
		}

		let newItems = root.items.slice()
		newItems.push(newEntry)
		root.items = newItems

		entryList.append({
			imagePath: newEntry.path,
			time: newEntry.time 
		})

		saveConfig()

	}

	//replace wallpaper function
	function replaceWallpaper(selectedPath){
		if(root.selectedIndex < 0 || root.selectedIndex >= root.items.length){
			return
		}
		let newItems = root.items.slice()
		newItems[root.selectedIndex] = {
			path: selectedPath,
			time: root.items[root.selectedIndex].time
		}
		root.items = newItems
		entryList.setProperty(root.selectedIndex, "imagePath", selectedPath)

		saveConfig()
	}

	//remove button
	function removeLastWallpaper(){
		if (root.items.length <= 1) {
			return
		}

		let newItems = root.items.slice()
		newItems.pop()
		root.items = newItems

		entryList.remove(entryList.count - 1)

		saveConfig()
	}
	
}
