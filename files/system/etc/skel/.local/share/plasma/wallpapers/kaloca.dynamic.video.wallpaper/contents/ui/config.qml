pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols 2.0 as KQuickControls
import "code/enum.js" as Enum
import "code/utils.js" as Utils
import "components" as Components

ColumnLayout {
    id: root
    spacing: Kirigami.Units.smallSpacing

    property var parentLayout
    property alias cfg_FillMode: videoFillMode.currentValue
    property alias cfg_BackgroundColor: colorButton.color
    property alias cfg_FillBlur: blurRadioButton.checked
    property alias cfg_FillBlurRadius: fillBlurRadius.value
    property alias cfg_ScheduleMode: scheduleModeCombo.currentValue
    property alias cfg_SunriseTime: sunriseTimeField.text
    property alias cfg_SunsetTime: sunsetTimeField.text
    property string cfg_VideoUrls
    property int editingIndex: -1
    property int videosRevision: 0
    property var validDropExtensions: [".mp4", ".mpg", ".ogg", ".mov", ".webm", ".flv", ".mkv", ".avi", ".wmv", ".gif"]
    readonly property int enabledVideoCount: {
        videosRevision;
        return videosModel.enabledCount();
    }
    readonly property bool sunEventsMode: cfg_ScheduleMode === Enum.ScheduleMode.SunEvents

    function updateConfig() {
        let videos = [];
        for (let i = 0; i < videosModel.model.count; i++) {
            const item = videosModel.model.get(i);
            if (!item.filename) {
                continue;
            }
            videos.push({
                filename: item.filename,
                enabled: item.enabled,
                duration: 0,
                customDuration: 0,
                playbackRate: 0.0,
                alternativePlaybackRate: 0.0,
                loop: false,
                startTime: Utils.normalizeStartTime(item.startTime)
            });
        }
        cfg_VideoUrls = JSON.stringify(videos);
    }

    VideosModel {
        id: videosModel
        onUpdated: {
            root.videosRevision += 1;
            root.updateConfig();
        }
    }

    Component.onCompleted: {
        videosModel.initModel(cfg_VideoUrls);
    }

    Kirigami.FormLayout {
        Layout.fillWidth: true

        RowLayout {
            Kirigami.FormData.label: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Version:")
            Components.Header {
                Layout.fillHeight: true
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Positioning:")
            ComboBox {
                id: videoFillMode
                model: [
                    {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Stretch"),
                        value: VideoOutput.Stretch
                    },
                    {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Keep Proportions"),
                        value: VideoOutput.PreserveAspectFit
                    },
                    {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Scaled and Cropped"),
                        value: VideoOutput.PreserveAspectCrop
                    }
                ]
                textRole: "text"
                valueRole: "value"
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Schedule:")
            ComboBox {
                id: scheduleModeCombo
                model: [
                    {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Custom Times"),
                        value: Enum.ScheduleMode.CustomTimes
                    },
                    {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Sunrise and Sunset"),
                        value: Enum.ScheduleMode.SunEvents
                    }
                ]
                textRole: "text"
                valueRole: "value"
            }
        }

        RowLayout {
            visible: root.sunEventsMode
            Kirigami.FormData.label: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Sun times:")
            TextField {
                id: sunriseTimeField
                text: "06:00"
                Layout.preferredWidth: Kirigami.Units.gridUnit * 5
                horizontalAlignment: TextInput.AlignHCenter
                validator: RegularExpressionValidator {
                    regularExpression: /^([01]?\d|2[0-3]):[0-5]\d$/
                }
                onEditingFinished: text = Utils.normalizeStartTime(text)
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Sunrise time")
            }
            Label {
                text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "to")
            }
            TextField {
                id: sunsetTimeField
                text: "18:00"
                Layout.preferredWidth: Kirigami.Units.gridUnit * 5
                horizontalAlignment: TextInput.AlignHCenter
                validator: RegularExpressionValidator {
                    regularExpression: /^([01]?\d|2[0-3]):[0-5]\d$/
                }
                onEditingFinished: text = Utils.normalizeStartTime(text)
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Sunset time")
            }
        }

        ButtonGroup {
            id: backgroundGroup
        }

        RowLayout {
            visible: root.cfg_FillMode === VideoOutput.PreserveAspectFit
            Kirigami.FormData.label: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Background:")
            RadioButton {
                id: blurRadioButton
                text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Blur")
                ButtonGroup.group: backgroundGroup
            }
            SpinBox {
                id: fillBlurRadius
                from: 0
                to: 145
                editable: true
                textFromValue: function (value, locale) {
                    return i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "%1px", value);
                }
                valueFromText: function (text, locale) {
                    return parseInt(text);
                }
            }
            RadioButton {
                id: colorRadioButton
                text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Solid color")
                ButtonGroup.group: backgroundGroup
                checked: !root.cfg_FillBlur
            }
            KQuickControls.ColorButton {
                id: colorButton
                dialogTitle: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Select Background Color")
                ButtonGroup.group: backgroundGroup
            }
        }

        Kirigami.InlineMessage {
            Layout.fillWidth: true
            type: Kirigami.MessageType.Information
            text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Sunrise and Sunset mode uses the first enabled video at sunrise and the second enabled video at sunset.")
            visible: root.sunEventsMode
        }

        Kirigami.InlineMessage {
            Layout.fillWidth: true
            type: Kirigami.MessageType.Warning
            text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Enable exactly two videos for Sunrise and Sunset mode.")
            visible: root.sunEventsMode && root.enabledVideoCount !== 2
        }
    }

    Kirigami.Separator {
        Layout.fillWidth: true
    }

    Component {
        id: inlineMessageComponent
        Kirigami.InlineMessage {
            visible: true
            width: dropArea.width
            type: Kirigami.MessageType.Information
            showCloseButton: true
            Timer {
                running: true
                interval: 5000
                onTriggered: parent.destroy()
            }
        }
    }

    DropArea {
        id: dropArea
        Layout.fillWidth: true
        Layout.fillHeight: true
        onEntered: drag => {
            if (drag.hasUrls) {
                drag.accept();
            }
        }
        onDropped: drop => {
            const validUrls = drop.urls.filter(url => {
                url = url.toString();
                const isValid = validDropExtensions.some(ext => url.endsWith(ext));
                if (!isValid) {
                    inlineMessageComponent.createObject(messagesList, {
                        text: `${url.toString()} invalid extension`,
                        type: Kirigami.MessageType.Warning
                    });
                }
                return isValid;
            });
            validUrls.forEach(url => {
                url = url.toString();
                if (videosModel.fileExists(url)) {
                    inlineMessageComponent.createObject(messagesList, {
                        text: `${url.toString()} already exists`
                    });
                } else {
                    videosModel.addItem(url);
                }
            });
        }

        Rectangle {
            anchors.fill: parent
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            color: Kirigami.Theme.backgroundColor
        }

        Kirigami.PlaceholderMessage {
            visible: videosModel.model.count === 0
            anchors.centerIn: parent
            width: parent.width - Kirigami.Units.gridUnit * 2
            icon.name: "video-symbolic"
            text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Add or drop videos")
        }

        ColumnLayout {
            id: messagesList
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            z: 2
        }

        ScrollView {
            anchors.fill: parent
            ListView {
                id: list
                model: videosModel.model
                clip: true
                spacing: 0
                Kirigami.Theme.colorSet: Kirigami.Theme.View
                Kirigami.Theme.inherit: false
                headerPositioning: ListView.OverlayHeader
                header: Kirigami.InlineViewHeader {
                    width: list.width
                    text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Videos")
                    ToolButton {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Pick a file...")
                        icon.name: "document-open"
                        onClicked: fileDialog.open()
                    }
                    ToolButton {
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Enter path or URL")
                        icon.name: "document-import-symbolic"
                        onClicked: videosModel.addItem()
                    }
                    ToolButton {
                        icon.name: "list-remove-all-symbolic"
                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Remove all")
                        onClicked: {
                            confirmationDialog.title = i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Remove all videos?");
                            confirmationDialog.callback = () => videosModel.clear();
                            confirmationDialog.open();
                        }
                    }
                }

                delegate: Item {
                    id: itemDelegate
                    readonly property var view: ListView.view
                    required property int index
                    required property string filename
                    required property bool enabled
                    required property string startTime
                    implicitWidth: ListView.view.width
                    implicitHeight: delegate.height

                    ItemDelegate {
                        id: delegate
                        implicitWidth: itemDelegate.implicitWidth
                        down: false
                        highlighted: false
                        background: Item {}
                        contentItem: RowLayout {
                            Button {
                                icon.name: itemDelegate.enabled ? "checkmark-symbolic" : "dialog-close-symbolic"
                                checkable: true
                                checked: itemDelegate.enabled
                                highlighted: itemDelegate.enabled
                                onCheckedChanged: videosModel.updateItem(itemDelegate.index, "enabled", checked)
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Enable this video")
                            }

                            Label {
                                visible: root.sunEventsMode
                                text: {
                                    root.videosRevision;
                                    const ordinal = itemDelegate.enabled ? videosModel.enabledOrdinal(itemDelegate.index) : -1;
                                    if (ordinal === 0) {
                                        return i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Day");
                                    } else if (ordinal === 1) {
                                        return i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Night");
                                    }
                                    return i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Unused");
                                }
                                color: text === i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Unused") ? Kirigami.Theme.disabledTextColor : Kirigami.Theme.textColor
                                Layout.preferredWidth: Kirigami.Units.gridUnit * 4
                            }

                            TextField {
                                id: startTimeField
                                text: Utils.normalizeStartTime(itemDelegate.startTime)
                                visible: !root.sunEventsMode
                                enabled: itemDelegate.enabled
                                Layout.preferredWidth: Kirigami.Units.gridUnit * 5
                                horizontalAlignment: TextInput.AlignHCenter
                                validator: RegularExpressionValidator {
                                    regularExpression: /^([01]?\d|2[0-3]):[0-5]\d$/
                                }
                                function applyTime() {
                                    const normalized = Utils.normalizeStartTime(text);
                                    text = normalized;
                                    videosModel.updateItem(itemDelegate.index, "startTime", normalized);
                                    videosModel.sortByStartTime();
                                }
                                Keys.onReturnPressed: applyTime()
                                Keys.onEnterPressed: applyTime()
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Start time in 24-hour HH:MM format")
                            }

                            Button {
                                icon.name: "document-save-symbolic"
                                visible: !root.sunEventsMode
                                enabled: itemDelegate.enabled
                                onClicked: startTimeField.applyTime()
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Apply time")
                            }

                            TextField {
                                id: filenameTextField
                                text: itemDelegate.filename
                                placeholderText: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Local file or static URL")
                                enabled: itemDelegate.enabled
                                onEditingFinished: videosModel.updateItem(itemDelegate.index, "filename", text)
                                Kirigami.Theme.colorSet: Kirigami.Theme.View
                                Layout.fillWidth: true
                                Component.onCompleted: {
                                    if (!text) {
                                        filenameTextField.forceActiveFocus();
                                    }
                                }
                            }

                            Button {
                                icon.name: "document-open"
                                enabled: itemDelegate.enabled
                                onClicked: {
                                    root.editingIndex = itemDelegate.index;
                                    fileDialog.open();
                                }
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Pick a file")
                            }

                            Button {
                                icon.name: "overflow-menu-symbolic"
                                onPressed: mediaMenu.opened ? mediaMenu.close() : mediaMenu.open()
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                Menu {
                                    id: mediaMenu
                                    y: parent.height
                                    MenuItem {
                                        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Preview")
                                        icon.name: "document-preview-symbolic"
                                        onClicked: Qt.openUrlExternally(itemDelegate.filename)
                                    }
                                }
                            }

                            Button {
                                icon.name: "list-remove-symbolic"
                                icon.color: Kirigami.Theme.negativeTextColor
                                onClicked: {
                                    confirmationDialog.title = i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Remove video?");
                                    confirmationDialog.callback = () => videosModel.removeItem(itemDelegate.index, 1);
                                    confirmationDialog.open();
                                }
                                Layout.fillHeight: true
                                Layout.preferredWidth: height
                                ToolTip.delay: 1000
                                ToolTip.visible: hovered
                                ToolTip.text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Remove")
                            }
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        fileMode: root.editingIndex === -1 ? FileDialog.OpenFiles : FileDialog.OpenFile
        title: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Pick a video file")
        nameFilters: [i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Video files") + " (*.mp4 *.mpg *.ogg *.mov *.webm *.flv *.matroska *.avi *wmv *.gif)", i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "All files") + " (*)"]
        onAccepted: {
            for (let file of fileDialog.selectedFiles) {
                file = file.toString();
                if (videosModel.fileExists(file)) {
                    continue;
                }

                if (root.editingIndex !== -1) {
                    videosModel.updateItem(root.editingIndex, "filename", file);
                    root.editingIndex = -1;
                } else {
                    videosModel.addItem(file);
                }
            }
        }
    }

    Kirigami.PromptDialog {
        id: confirmationDialog
        title: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "Remove all videos?")
        property var callback
        standardButtons: Kirigami.Dialog.Ok | Kirigami.Dialog.Cancel
        onAccepted: callback()
    }

}
