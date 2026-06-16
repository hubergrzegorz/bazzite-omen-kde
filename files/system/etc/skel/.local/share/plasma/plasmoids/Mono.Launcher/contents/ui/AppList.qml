import QtQuick
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
    id: root

    readonly property int dotsAreaHeight: 28

    property int columns: Math.floor(width / cellWidth)
    property int rows: Math.floor(heightGridApps / cellHeight)
    property int itemsPerPage: columns * rows
    property int totalItems: (isSearching ? runnerModel.modelForRow(0) : activeFullListApps ? rootModel.modelForRow(0) : rootModel.favoritesModel).count
    property int totalPages: Math.ceil(totalItems / itemsPerPage)

    //--------------------------------------
    // CONTENEDOR DESPLAZABLE
    //--------------------------------------
    Item {
        id: content
        width: totalPages * root.width
        height: root.height - dotsAreaHeight
        x: -currentPage * root.width
        Behavior on x {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

        Repeater {
            model: isSearching ? runnerModel.modelForRow(0) : activeFullListApps ? rootModel.modelForRow(0) : rootModel.favoritesModel
            onModelChanged: {
                currentPage = 0
            }

            delegate: Item {
                id: appDelegate
                width: cellWidth
                height: cellHeight

                property int page: Math.floor(index / itemsPerPage)
                property int indexInPage: index % itemsPerPage
                property int column: indexInPage % columns
                property int row: Math.floor(indexInPage / columns)

                x: column * cellWidth + page * root.width
                y: row * cellHeight

                // Fondo con efecto hover/press
                Rectangle {
                    id: appBackground
                    anchors.fill: parent
                    radius: 12
                    color: appMouseArea.pressed
                    ? Qt.rgba(Kirigami.Theme.highlightColor.r,
                              Kirigami.Theme.highlightColor.g,
                              Kirigami.Theme.highlightColor.b, 0.3)
                    : appMouseArea.containsMouse
                    ? Qt.rgba(1, 1, 1, 0.08)
                    : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }
                }

                Column {
                    width: parent.width
                    height: parent.height
                    spacing: 16

                    Kirigami.Icon {
                        id: appIcon
                        width: Plasmoid.configuration.iconSize
                        height: width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 12
                        source: model.decoration

                        scale: appMouseArea.pressed ? 0.88 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                    }

                    Item {
                        width: parent.width
                        height: parent.height - parent.spacing - appIcon.height
                        anchors.top: appIcon.bottom
                        anchors.topMargin: 6
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        visible: page === currentPage

                        Kirigami.Heading {
                            id: appLabel
                            width: parent.width
                            height: parent.height
                            level: 5
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: model.display
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            color: appMouseArea.containsMouse
                            ? Kirigami.Theme.highlightColor
                            : Kirigami.Theme.textColor

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }
                }

                // MouseArea para abrir la app
                MouseArea {
                    id: appMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: false

                    onClicked: {
                        if (model.hasModelChildren) {
                            // Es una carpeta/submenú, navegamos dentro
                        } else {
                            var appModel = isSearching
                            ? runnerModel.modelForRow(0)
                            : activeFullListApps
                            ? rootModel.modelForRow(0)
                            : rootModel.favoritesModel

                            appModel.trigger(index, "", null)
                        }
                    }
                }
            }
        }
    }

    //--------------------------------------
    // DRAG CON MOUSE
    //--------------------------------------
    MouseArea {
        id: dragArea
        anchors.fill: parent
        property real startX
        property real dragOffset
        property bool dragging: false

        onPressed: {
            startX = mouse.x
            dragOffset = 0
            dragging = false
        }

        onPositionChanged: {
            dragOffset = mouse.x - startX
            if (Math.abs(dragOffset) > 10) {
                dragging = true
                content.x = -currentPage * root.width + dragOffset
            }
        }

        onReleased: {
            if (dragging) {
                if (dragOffset < -root.width / 4 && currentPage < totalPages - 1)
                    currentPage++
                    else if (dragOffset > root.width / 4 && currentPage > 0)
                        currentPage--
                        content.x = -currentPage * root.width
            }
            dragging = false
        }

        onWheel: {
            if (wheel.angleDelta.y < 0 && currentPage < totalPages - 1)
                currentPage++
                else if (wheel.angleDelta.y > 0 && currentPage > 0)
                    currentPage--
        }

        propagateComposedEvents: true
    }

    //--------------------------------------
    // INDICADORES DE PÁGINA MEJORADOS
    //--------------------------------------
    Row {
        id: dotsRow
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (dotsAreaHeight - 14) / 2
        visible: totalPages > 1

        Repeater {
            id: dotsRepeater
            model: totalPages

            Rectangle {
                id: dot
                width: index === currentPage ? 24 : 8
                height: 8
                radius: height / 2
                color: index === currentPage
                ? Kirigami.Theme.highlightColor
                : Qt.rgba(Kirigami.Theme.textColor.r,
                          Kirigami.Theme.textColor.g,
                          Kirigami.Theme.textColor.b, 0.4)

                // Animación suave para el cambio de ancho
                Behavior on width {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutElastic
                        easing.amplitude: 0.8
                        easing.period: 0.3
                    }
                }

                // Animación para el color
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                // Efecto de brillo adicional para el indicador activo
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: index === currentPage
                    ? Qt.rgba(Kirigami.Theme.highlightColor.r,
                              Kirigami.Theme.highlightColor.g,
                              Kirigami.Theme.highlightColor.b, 0.5)
                    : "transparent"
                    border.width: index === currentPage ? 1 : 0
                    opacity: index === currentPage ? 0.6 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentPage = index
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    // Indicador opcional de página actual (texto)
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (dotsAreaHeight - 20) / 2
        visible: totalPages > 1 && Plasmoid.configuration.showPageIndicator
        height: 20
        width: 50
        radius: 10
        color: Qt.rgba(0, 0, 0, 0.5)

        Kirigami.Heading {
            level: 6
            anchors.centerIn: parent
            text: (currentPage + 1) + " / " + totalPages
            color: "white"
            font.pointSize: 9
        }
    }
}
