/*
 * SPDX-FileCopyrightText: 2025 Randy Cabrera <>
 * SPDX-License-Identifier: GPL-2.0-or-later
 * Modificado para desacoplamiento y control macro/micro.
 */

import QtQuick
import org.kde.kquickcontrolsaddons 2.0
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Window 2.15

FocusScope {
    id: itemGrid
    property bool lockHover: false

    // ==========================================
    // INTERFAZ PÚBLICA (El conocimiento compartido)
    // ==========================================
    property int columns: 0
    property int rows: 0

    readonly property int idealCellWidth: iconSize + (Kirigami.Units.gridUnit * 6)
    readonly property int idealCellHeight: iconSize + (Kirigami.Units.gridUnit * 6)

    signal keyNavLeft
    signal keyNavRight
    signal keyNavUp
    signal keyNavDown
    signal itemActivated(int index, string actionId, string argument)

    property bool dragEnabled: true
    property bool dropEnabled: false
    property bool showLabels: true

    property alias currentIndex: gridView.currentIndex
    property alias currentItem: gridView.currentItem
    property alias contentItem: gridView.contentItem
    property alias count: gridView.count
    property alias model: gridView.model

    property alias cellWidth: gridView.cellWidth
    property alias cellHeight: gridView.cellHeight
    property int iconSize: gridView.iconSize

    property var horizontalScrollBarPolicy: PlasmaComponents.ScrollBar.AlwaysOff
    property var verticalScrollBarPolicy: PlasmaComponents.ScrollBar.AsNeeded


    implicitWidth: columns > 0 ? Math.min(idealCellWidth * columns, Screen.desktopAvailableWidth) : 400
    implicitHeight: rows > 0 ? Math.min(idealCellHeight * rows, Screen.desktopAvailableHeight) : (iconSize + (Kirigami.Units.gridUnit * 6)* (count/rootItem.columns_p ))+20

    DropArea {
        id: dropArea
        anchors.fill: parent

        PlasmaComponents.ScrollView {
            id: scrollArea
            anchors.fill: parent
            focus: true

            PlasmaComponents.ScrollBar.horizontal.policy: itemGrid.horizontalScrollBarPolicy
            PlasmaComponents.ScrollBar.vertical.policy: itemGrid.verticalScrollBarPolicy

            GridView
            {
                id: gridView
                width: scrollArea.width
                height: scrollArea.height

                readonly property int columnsCount:
                {
                    if (itemGrid.columns > 0) {
                        return itemGrid.columns;
                    } else {
                        var minCellWidth = iconSize + (Kirigami.Units.gridUnit * 5);
                        return Math.max(1, Math.floor(width / minCellWidth));
                    }
                }

                cellWidth: columnsCount > 0 ? Math.floor(width / columnsCount) : width
                cellHeight:
                {
                    if (itemGrid.rows > 0) {
                        return Math.floor(height / itemGrid.rows);
                    } else {
                        return iconSize + (Kirigami.Units.gridUnit * 5);
                    }
                }

                signal itemContainsMouseChanged(bool containsMouse)
                property bool animating: false
                property int animationDuration: itemGrid.dropEnabled ? resetAnimationDurationTimer.interval : 0

                focus: true
                currentIndex: -1

                // ----------------------------- DRAG & DROP MULTI-ROW -----------------------------
                move: Transition {
                    enabled: itemGrid.dropEnabled
                    SequentialAnimation {
                        PropertyAction { target: gridView; property: "animating"; value: true }
                        NumberAnimation { duration: gridView.animationDuration; properties: "x, y"; easing.type: Easing.OutQuad }
                        PropertyAction { target: gridView; property: "animating"; value: false }
                    }
                }

                moveDisplaced: Transition {
                    enabled: itemGrid.dropEnabled
                    SequentialAnimation {
                        PropertyAction { target: gridView; property: "animating"; value: true }
                        NumberAnimation { duration: gridView.animationDuration; properties: "x, y"; easing.type: Easing.OutQuad }
                        PropertyAction { target: gridView; property: "animating"; value: false }
                    }
                }

                keyNavigationWraps: false
                boundsBehavior: Flickable.StopAtBounds
                snapMode: GridView.SnapToRow

                delegate: ItemGridDelegate {
                    showLabel: itemGrid.showLabels
                }

                // --------------------------------- HIGHLIGHT ---------------------------------
                highlight: Item {
                    id: highlightContainer
                    property bool isDropPlaceHolder: "dropPlaceholderIndex" in itemGrid.model && itemGrid.currentIndex === itemGrid.model.dropPlaceholderIndex
                    width: gridView.cellWidth
                    height: gridView.cellHeight

                    PlasmaExtras.Highlight {
                        visible: gridView.currentItem && !isDropPlaceHolder
                        hovered: true
                        pressed: false // Vinculado de forma pasiva a eventos nativos ahora
                        anchors.fill: parent
                    }

                    KSvg.FrameSvgItem {
                        visible: gridView.currentItem && isDropPlaceHolder
                        anchors.fill: parent
                        imagePath: "widgets/viewitem"
                        prefix: "selected"
                        opacity: 0.5

                        Kirigami.Icon {
                            anchors {
                                right: parent.right
                                rightMargin: parent.margins.right
                                bottom: parent.bottom
                                bottomMargin: parent.margins.bottom
                            }
                            width: Kirigami.Units.iconSizes.smallMedium
                            height: width
                            source: "list-add"
                            active: false
                        }
                    }
                }

                highlightFollowsCurrentItem: true
                highlightMoveDuration: 0

                // ------------------------------- EVENTOS DE ESTADO -------------------------------
                onCurrentIndexChanged: {
                    if (currentIndex !== -1) {
                        // Mantenemos el foco del teclado en la GridView sin romper el hover nativo
                        focus = true;
                    }
                }

                onCountChanged: {
                    animationDuration = 0;
                    resetAnimationDurationTimer.start();
                }

                onModelChanged: {
                    currentIndex = -1;
                }

                // =========================================================================
                // NAVEGACIÓN DICTAMINADA POR TECLADO COORDENADA CON EL DELEGATE
                // =========================================================================
                Keys.onLeftPressed: event => {
                    if (itemGrid.currentCol() !== 0) {
                        event.accepted = true;
                        moveCurrentIndexLeft();
                    } else {
                        itemGrid.keyNavLeft();
                    }
                }

                Keys.onRightPressed: event => {
                    if (itemGrid.currentCol() !== gridView.columnsCount - 1 && currentIndex !== count - 1) {
                        event.accepted = true;
                        moveCurrentIndexRight();
                    } else {
                        itemGrid.keyNavRight();
                    }
                }

                Keys.onUpPressed: event => {
                    if (itemGrid.currentRow() !== 0) {
                        event.accepted = true;
                        moveCurrentIndexUp();
                        positionViewAtIndex(currentIndex, GridView.Contain);
                    } else {
                        itemGrid.keyNavUp();
                    }
                }

                Keys.onDownPressed: event => {
                    if (itemGrid.currentRow() < itemGrid.lastRow()) {
                        event.accepted = true;
                        var newIndex = currentIndex + gridView.columnsCount;
                        currentIndex = Math.min(newIndex, count - 1);
                        positionViewAtIndex(currentIndex, GridView.Contain);
                    } else {
                        itemGrid.keyNavDown();
                    }
                }

                // Limpieza interna cuando el tooltip reporta salida
                onItemContainsMouseChanged: containsMouse => {
                    if (!containsMouse) {
                        if (currentIndex === -1 && "dropPlaceholderIndex" in itemGrid.model) {
                            itemGrid.model.dropPlaceholderIndex = -1;
                        }
                        // rompemos el "secuestro" del teclado limpiando el índice.
                        if (!itemGrid.lockHover) {
                            gridView.currentIndex = -1;
                        }

                    }
                }
            }
        }

        // ----------------------- GESTIÓN DE ZONA DE ARRASTRE EXTRÍNSECO -----------------------
        onPositionChanged: event => {
            if (!itemGrid.dropEnabled || gridView.animating || !kicker.dragSource) return;

            var x = Math.max(0, event.x - (width % gridView.cellWidth));
            var cPos = mapToItem(gridView.contentItem, x, event.y);
            var item = gridView.itemAt(cPos.x, cPos.y);

            if (item) {
                if (kicker.dragSource.parent === gridView.contentItem) {
                    if (item !== kicker.dragSource) {
                        item.GridView.view.model.moveRow(kicker.dragSource.itemIndex, item.itemIndex);
                    }
                } else if (kicker.dragSource.GridView.view.model.favoritesModel === itemGrid.model
                    && !itemGrid.model.isFavorite(kicker.dragSource.favoriteId)) {
                    var hasPlaceholder = (itemGrid.model.dropPlaceholderIndex !== -1);
                itemGrid.model.dropPlaceholderIndex = item.itemIndex;
                if (!hasPlaceholder) gridView.currentIndex = (item.itemIndex - 1);
                    }
            } else if (kicker.dragSource.parent !== gridView.contentItem
                && kicker.dragSource.GridView.view.model.favoritesModel === itemGrid.model
                && !itemGrid.model.isFavorite(kicker.dragSource.favoriteId)) {
                var hasPlaceholder = (itemGrid.model.dropPlaceholderIndex !== -1);
            itemGrid.model.dropPlaceholderIndex = hasPlaceholder ? itemGrid.model.count - 1 : itemGrid.model.count;
            if (!hasPlaceholder) gridView.currentIndex = (itemGrid.model.count - 1);
                } else {
                    itemGrid.model.dropPlaceholderIndex = -1;
                    gridView.currentIndex = -1;
                }
        }

        onExited: {
            if ("dropPlaceholderIndex" in itemGrid.model) {
                itemGrid.model.dropPlaceholderIndex = -1;
                gridView.currentIndex = -1;
            }
        }

        onDropped: {
            if (kicker.dragSource && kicker.dragSource.parent !== gridView.contentItem && kicker.dragSource.GridView.view.model.favoritesModel === itemGrid.model) {
                itemGrid.model.addFavorite(kicker.dragSource.favoriteId, itemGrid.model.dropPlaceholderIndex);
                gridView.currentIndex = -1;
            }
        }
    }

    Timer {
        id: resetAnimationDurationTimer
        interval: 120
        repeat: false
        onTriggered: gridView.animationDuration = interval - 20;
    }

    onDropEnabledChanged: {
        if (!dropEnabled && "dropPlaceholderIndex" in model) model.dropPlaceholderIndex = -1;
    }

    onFocusChanged: {
        if (!focus) {
            currentIndex = -1;
        }
        // Si el usuario interactúa con la grilla o cambia el foco de la ventana,
        // nos aseguramos de apagar el candado.
        if (!kicker.contextMenuOpen) {
            itemGrid.lockHover = false;
        }
    }

    // ==========================================
    // MÉTODOS DE CÁLCULO INTERNO CONOCIDO
    // ==========================================
    function currentRow() {
        if (currentIndex === -1) return -1;
        return Math.floor(currentIndex / gridView.columnsCount);
    }

    function currentCol() {
        if (currentIndex === -1) return -1;
        return currentIndex - (currentRow() * gridView.columnsCount);
    }

    function lastRow() {
        return Math.ceil(count / gridView.columnsCount) - 1;
    }

    function tryActivate(row, col) {
        if (count) {
            var rows = Math.ceil(count / gridView.columnsCount);
            row = Math.min(row, rows);
            col = Math.min(col, gridView.columnsCount);
            currentIndex = Math.min(row ? ((Math.max(1, row) * gridView.columnsCount) + col) : col, count - 1);
            kicker.currentRow = row;
            kicker.currentColumn = col;
            kicker.currentIndex = currentIndex;
            gridView.forceActiveFocus();
        }
    }

    function forceLayout() { gridView.forceLayout(); }
    ActionMenu {
        id: actionMenu
        onActionClicked: visualParent.actionTriggered(actionId, actionArgument);
    }
}
