/*
 * SPDX-FileCopyrightText: 2026 Randy Cabrera <>
 * SPDX-License-Identifier: GPL-2.0-or-later
 * Optimización de Lista de Documentos Recientes con control macro/micro.
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami as Kirigami

import "code/tools.js" as Tools

FocusScope {
    id: itemList
    property bool lockHover: false

    // ==========================================
    // INTERFAZ PÚBLICA (API Desacoplada)
    // ==========================================
    property alias model: listView.model
    property int iconSize: 48
    property var kicker: null

    signal keyNavLeft
    signal keyNavRight
    signal keyNavUp
    signal keyNavDown
    signal itemActivated(int index, string actionId, string argument)

    property alias currentIndex: listView.currentIndex
    property alias currentItem: listView.currentItem
    property alias contentItem: listView.contentItem
    property alias count: listView.count

    property var horizontalScrollBarPolicy: PlasmaComponents.ScrollBar.AlwaysOff
    property var verticalScrollBarPolicy: PlasmaComponents.ScrollBar.AsNeeded

    // Dimensiones implícitas calculadas macro/micro
    readonly property int idealItemHeight: Math.max(iconSize + 14, 48) + 2
    implicitWidth: 400
    implicitHeight: count > 0 ? Math.min(idealItemHeight * count, Screen.desktopAvailableHeight) : 200

    // Menú de acciones contextuales globalizado (Corregido)
    ActionMenu {
        id: rootActionMenu // Cambiado el ID para evitar colisiones de contexto
        onActionClicked: (actionId, actionArgument) => {
            if (visualParent && typeof visualParent.actionTriggered === "function") {
                visualParent.actionTriggered(actionId, actionArgument);
            }
        }

        onClosed: {
            itemList.lockHover = false;
            if (itemList.kicker) {
                itemList.kicker.contextMenuOpen = false;
            }
            listView.forceActiveFocus(); // Devuelve el foco de teclado a la ListView
        }
    }

    PlasmaComponents.ScrollView
    {
        id: scrollArea
        anchors.fill: parent
        focus: true

        PlasmaComponents.ScrollBar.horizontal.policy: itemList.horizontalScrollBarPolicy
        PlasmaComponents.ScrollBar.vertical.policy: itemList.verticalScrollBarPolicy

        ListView {
            id: listView
            width: scrollArea.width
            height: scrollArea.height
            clip: true
            spacing: 2
            interactive: false
            currentIndex: -1
            focus: true

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlight: PlasmaExtras.Highlight {
                visible: listView.currentIndex !== -1
                hovered: true
            }

            delegate: PlasmaComponents.ItemDelegate
            {
                id: control
                width: listView.width
                height: Math.max(itemList.iconSize + 14, 48)

                function actionTriggered(actionId, actionArgument) {
                    var close = (Tools.triggerAction(listView.model, index, actionId, actionArgument) === true);
                    if (close && itemList.kicker) {
                        itemList.kicker.toggle();
                    }
                }

                function openActionMenu(x, y) {
                    if (!model) return;
                    var actionList = hasActionList ? model.actionList : [];

                    // CORRECCIÓN DE ÁMBITO: Accedemos de forma explícita al menú del ancestro raíz
                    rootActionMenu.visualParent = control;
                    var favModel = (listView.model && listView.model.favoritesModel) ? listView.model.favoritesModel : null;
                    Tools.fillActionMenu(i18n, rootActionMenu, actionList, favModel, model.favoriteId || "");

                    // Avisamos del bloqueo antes de abrir
                    itemList.lockHover = true;
                    if (itemList.kicker) {
                        itemList.kicker.contextMenuOpen = true;
                    }
                    rootActionMenu.open(x, y);
                }

                property bool hasActionList: model && ((model.favoriteId !== undefined && model.favoriteId !== null) || model.hasActionList === true)

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true

                    onEntered: {
                        if (!itemList.lockHover) {
                            listView.currentIndex = index;
                        }
                    }

                    // ¡SOLUCCIÓN AUTÓNOMA!: Cada celda apaga su highlight al salir si va al vacío
                    onExited: {
                        if (!itemList.lockHover) {
                            if (listView.currentIndex === index) {
                                listView.currentIndex = -1;
                            }
                        }
                    }

                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            itemList.lockHover = true;
                            // Mapeo dinámico de coordenadas para que el menú emerja en el cursor
                            control.openActionMenu(mouse.x, mouse.y);
                        } else {
                            if (listView.model) {
                                listView.model.trigger(index, "", null);
                                if (itemList.kicker) itemList.kicker.toggle();
                            }
                        }
                    }
                }

                contentItem: RowLayout {
                    spacing: 8

                    Kirigami.Icon {
                        Layout.preferredWidth: itemList.iconSize
                        Layout.preferredHeight: itemList.iconSize
                        source: (model && model.decoration) ? model.decoration : "application-x-executable"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        PlasmaComponents.Label {
                            text: (model && model.display) ? model.display : ""
                            font.weight: Font.Bold
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        PlasmaComponents.Label {
                            text: (model && model.description) ? model.description : ""
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize - 2
                            opacity: 0.6
                            elide: Text.ElideMiddle
                            Layout.fillWidth: true
                            visible: text !== ""
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignRight
                        PlasmaComponents.Label {
                            text: (model && model.itemData && model.itemData[Qt.UserRole + 10]) ? model.itemData[Qt.UserRole + 10] : ""
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize - 3
                            Layout.alignment: Qt.AlignRight
                        }
                        PlasmaComponents.Label {
                            text: {
                                let name = (model && model.display) ? model.display : "";
                                return name.includes('.') ? name.split('.').pop().toUpperCase() : ""
                            }
                            color: Kirigami.Theme.highlightColor
                            font.weight: Font.Black
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize - 4
                            Layout.alignment: Qt.AlignRight
                            visible: text !== ""
                        }
                    }
                }
            }

            // =========================================================================
            // MANEJO DE EVENTOS DE TECLADO SIN INTERRUPCIÓN (Sincronía con FocusScope)
            // =========================================================================
            Keys.onUpPressed: event => {
                if (currentIndex > 0) {
                    event.accepted = true;
                    decrementCurrentIndex();
                } else {
                    itemList.keyNavUp();
                }
            }

            Keys.onDownPressed: event => {
                if (currentIndex < count - 1) {
                    event.accepted = true;
                    incrementCurrentIndex();
                } else {
                    itemList.keyNavDown();
                }
            }

            Keys.onLeftPressed: event => { itemList.keyNavLeft(); }
            Keys.onRightPressed: event => { itemList.keyNavRight(); }

            onCurrentIndexChanged: {
                if (currentIndex !== -1) {
                    focus = true;
                }
            }
        }
    }

    // Sensor perimetral macro trasero
    MouseArea {
        anchors.fill: parent
        z: -1
        hoverEnabled: true
        onEntered: {
            if (!itemList.lockHover) {
                listView.currentIndex = -1;
            }
        }
    }

    onFocusChanged: {
        if (!focus) {
            currentIndex = -1;
        }
        if (itemList.kicker && !itemList.kicker.contextMenuOpen) {
            itemList.lockHover = false;
        }
    }

    // ==========================================
    // MÉTODOS DE CÁLCULO INTERNO COMPATIBLES
    // ==========================================
    function lastRow() {
        return count - 1;
    }

    function tryActivate(row, col) {
        if (count > 0) {
            currentIndex = Math.min(Math.max(0, row), count - 1);
            listView.forceActiveFocus();
        }
    }
}
