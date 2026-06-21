import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root
    readonly property string version: "0.1.0"
    readonly property string githubUrl: "https://github.com/kaloca/plasma-dynamic-video-wallpaper"
    readonly property string kdeStoreUrl: "https://store.kde.org/p/2358230/"

    Label {
        text: root.version
        font.weight: Font.DemiBold
    }

    Button {
        id: linksButton
        text: i18nd("plasma_wallpaper_kaloca.dynamic.video.wallpaper", "About")
        icon.name: "info-symbolic"
        onClicked: menu.opened ? menu.close() : menu.open()
        Layout.fillHeight: true
    }

    Menu {
        id: menu
        y: linksButton.height
        x: linksButton.x

        Action {
            text: "GitHub"
            icon.source: Qt.resolvedUrl("../../icons/github.svg")
            onTriggered: Qt.openUrlExternally(root.githubUrl)
        }

        Action {
            text: "KDE Store"
            icon.source: Qt.resolvedUrl("../../icons/kde.svg")
            onTriggered: Qt.openUrlExternally(root.kdeStoreUrl)
        }
    }
}
