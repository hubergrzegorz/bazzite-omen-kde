import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
    id: menu

    property int cellWidth: Plasmoid.configuration.cellSize
    property int cellHeight: Plasmoid.configuration.cellSize

    property double heightGridApps: cellHeight * 3 + 28

    property bool activeFullListApps: true

    property bool isSearching: false


    property int currentPage: 0

    Layout.preferredWidth: cellWidth*4
    Layout.preferredHeight: header.height + heightGridApps + searchField.implicitHeight + 16
    Layout.minimumWidth: cellWidth*4
    Layout.maximumWidth: cellWidth*4
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true

    Header {
        id: header
        height: cellHeight + 8
        width: parent.width
    }

    AppList {
        id: list
        width: parent.width
        height: heightGridApps
        anchors.top: header.bottom
        anchors.topMargin: 8
        focus: true
    }

    TextField {
        id: searchField

        width: parent.width * 0.5
        height: 28

        anchors.top: list.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        placeholderText: i18n("Search applications…")

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: 12

        background: Rectangle {
            radius: height / 2
            color: Kirigami.Theme.backgroundColor
            border.color: Kirigami.Theme.disabledTextColor
            border.width: 1
        }

        padding: 4

        onTextChanged: {
            runnerModel.query = text
            if (runnerModel.count > 0)
                isSearching = true
            if (text.length === 0) {
                isSearching = false
                searchField.focus = false
            }

        }
    }

}
