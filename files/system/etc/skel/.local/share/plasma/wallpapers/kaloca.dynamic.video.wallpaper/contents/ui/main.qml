/*
 *  Copyright 2018 Rog131 <samrog131@hotmail.com>
 *  Copyright 2019 adhe   <adhemarks2@gmail.com>
 *  Copyright 2024 Luis Bocanegra <luisbocanegra17b@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 */

import QtQuick
import QtMultimedia
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import "code/utils.js" as Utils

WallpaperItem {
    id: main
    anchors.fill: parent

    property int clockTick: 0
    property var videosConfig: Utils.parseCompat(main.configuration.VideoUrls).filter(video => video.enabled)
    property var scheduleVideos: Utils.getScheduleVideos(videosConfig, main.configuration.ScheduleMode, main.configuration.SunriseTime, main.configuration.SunsetTime)
    property var currentSource: {
        clockTick;
        return Utils.getVideoByTime(scheduleVideos, Utils.currentMinutes());
    }

    onCurrentSourceChanged: {
        if (currentSource.filename) {
            playTimer.restart();
        }
    }

    onVideosConfigChanged: {
        clockTick += 1;
    }

    Rectangle {
        anchors.fill: parent
        color: scheduleVideos.length === 0 ? Kirigami.Theme.backgroundColor : main.configuration.BackgroundColor

        VideoPlayer {
            id: player
            anchors.fill: parent
            visible: main.scheduleVideos.length !== 0
            source: main.currentSource.filename ?? ""
            muted: true
            volume: 0
            playbackRate: 1
            fillMode: main.configuration.FillMode
            fillBlur: main.configuration.FillBlur
            fillBlurRadius: main.configuration.FillBlurRadius
            loops: MediaPlayer.Infinite
        }
    }

    PlasmaExtras.PlaceholderMessage {
        visible: main.scheduleVideos.length === 0
        anchors.centerIn: parent
        width: parent.width - Kirigami.Units.gridUnit * 2
        iconName: "video-symbolic"
        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "No video source")
    }

    Timer {
        id: playTimer
        interval: 10
        onTriggered: player.play()
    }

    Timer {
        id: scheduleTimer
        running: true
        repeat: true
        interval: 30000
        triggeredOnStart: true
        onTriggered: {
            main.clockTick += 1;
            if (main.currentSource.filename) {
                playTimer.restart();
            }
        }
    }

    Component.onCompleted: {
        playTimer.restart();
    }

    contextualActions: []
}
