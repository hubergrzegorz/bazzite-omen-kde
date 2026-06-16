pragma ComponentBehavior: Bound
import QtQuick
import org.kde.plasma.plasmoid

WallpaperItem {
	id: root

	//local items var for Wallpapers
	//local mode int for Modes
	property var items: []
	property int mode: 0

	//what wallpaper is currently displayed?
	property int currentIndex: 0

	//what wallpaper is coming next? only used for smooth
	property int nextIndex: 0


	//defaultImage file path
	property url defaultImage: Qt.resolvedUrl("..images/hourglassDefault.png")

	//debug code ------------------
/*	property int tickCount: 0

	Text {
		anchors.top: parent.top
		anchors.left: parent.left
		text: "ticks: " + root.tickCount + "index: " + root.currentIndex + "time: " + root.minutesToTime(root.getTime()) + "length: " + root.items.length
		color: "white"
		font.pixelSize: 32  
		z:999
	}
	*/	

	//actual desktop image on top
	Image {
		id: wallPaperImage
		anchors.fill: parent
		fillMode: Image.PreserveAspectCrop
		source: root.items.length > 0 ? root.items[root.currentIndex].path : root.defaultImage
		opacity: 1.0
	}

	Image {
		id: nextImage
		anchors.fill: parent
		fillMode: Image.PreserveAspectCrop
		source: root.items.length > 0 ? root.items[root.nextIndex].path : root.defaultImage
		opacity: 0.0
	}

	//when program starts
	Component.onCompleted: {
		root.loadConfig()
		root.currentIndex = root.findCurrent()
		root.nextIndex = findNext()
		root.updateWallpaper()
	}


	//loop, you can change interval to check for updates/update wallpaper quicker, i defaulted this to 60000 which is ~1 minute updates
	//If you do change the interval though, you cannot go below 1 minute with current algorithm because everything is tracked to minutes placed
	Timer {
		interval: 60000
		running: true
		repeat: true
		triggeredOnStart: true

		onTriggered: {
			//tick count is for debug info
			//root.tickCount++
			root.loadConfig()
			root.updateWallpaper()
		}
	}


	//load settings from configuration
	function loadConfig(){
		try {
			root.items = JSON.parse(root.configuration.Wallpapers || "[]")
		} catch (e) {
			root.items = []
		}

		root.mode = root.configuration.Mode
	}

	//code to find what wallpaper should currently be displayed
	function findCurrent(){
		const currentTime = getTime()
		for(let i = 0; i < root.items.length; i++){
			if(currentTime < timeToMinutes(root.items[i].time)){
				return i > 0 ? i - 1 : root.items.length - 1
			}
		}
		return root.items.length - 1
	}

	//code to find what wallpaper is next, only really used by smooth
	function findNext(){
		const current = root.currentIndex
		if(current >= root.items.length - 1){
			return 0 
		}else{
			return root.currentIndex + 1 
		}

	}

	//code to get current time
	function getTime(){
		const now = new Date()

		const hours = now.getHours()
		const minutes = now.getMinutes()

		return hours * 60 + minutes
	}

	//code to convert string time to minutes
	function timeToMinutes(time){
		const parts = time.split(":")
		return Number(parts[0]) * 60 + Number(parts[1])
	}

	//code to convert minutes back to string time
	function minutesToTime(minutes){
		minutes = minutes % 1440

		const hours = Math.floor(minutes / 60)
		const mins = minutes % 60 

		return String(hours).padStart(2,"0") + ":" + String(mins).padStart(2, "0")
	}

	//updateWallpaper function
	function updateWallpaper(){
		if(root.mode == 0){
			rigidUpdate()
		}else{
			smoothUpdate()
		}
	}

	//rigid update
	function rigidUpdate(){
		nextImage.opacity = 0.0
		const newCurrentIndex = root.findCurrent()
		if(newCurrentIndex !== root.currentIndex) {
			root.currentIndex = newCurrentIndex
		}
	}

	//smooth update
	function smoothUpdate(){
		let normalizedDistribution = 0
		//find currentIndex, if it has changed update both currentIndex and next index
		const newCurrentIndex = root.findCurrent()
		if(newCurrentIndex !== root.currentIndex){
			root.currentIndex = newCurrentIndex
			root.nextIndex = findNext()
		}

		//get the current time
		let now = getTime()

		//get the time that the current image started
		let currentImageTime = timeToMinutes(root.items[root.currentIndex].time)

		//get the time that the next image starts
		let nextImageTime = timeToMinutes(root.items[root.nextIndex].time)

		if(nextImageTime <= currentImageTime){
			nextImageTime += 24*60
		}

		if(now < currentImageTime){
			now += 24*60
		}

		//find difference between next image start and current image start
		let difference = nextImageTime - currentImageTime

		//find where we are at on that difference
		let progress = now - currentImageTime

		//find a value between 0-1 that represents how far along we are in the transition
		normalizedDistribution = progress / difference

		
		//make opacity that normalized distribution
		//add clamp to 0 or 1 for safety just in case
		nextImage.opacity = Math.max(0, Math.min(normalizedDistribution, 1))
	}

}
