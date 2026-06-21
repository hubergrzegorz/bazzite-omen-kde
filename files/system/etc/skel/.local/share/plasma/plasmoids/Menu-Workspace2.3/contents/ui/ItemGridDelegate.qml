import QtQuick 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami
import "code/tools.js" as Tools

Item {
    id: item

    width: GridView.view.cellWidth
    height: GridView.view.cellHeight

    enabled: !model.disabled

    property bool showLabel: true
    property int itemIndex: model.index
    property string favoriteId: model.favoriteId !== undefined ? model.favoriteId : ""
    property url url: model.url !== undefined ? model.url : ""
    property variant icon: model.decoration !== undefined ? model.decoration : ""
    property var m: model
    property bool hasActionList: ((model.favoriteId !== null) || (("hasActionList" in model) && (model.hasActionList === true)))
    Accessible.role: Accessible.MenuItem
    Accessible.name: model.display

    Column {
        id: mainLayout
        spacing: 5
        anchors.centerIn: parent
        width: item.width - (highlightItemSvg.margins.left + highlightItemSvg.margins.right)

        Item {
            id: iconWrapper
            width: iconSize
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            Kirigami.Icon {
                id: icon
                anchors.fill: parent
                animated: false
                source: model.decoration
                smooth: true

                opacity: 0
                NumberAnimation on opacity {
                    id: entradaOpacity
                    from: kicker.iconAnimation ? 0 : 1
                    to: 1
                    duration: kicker.timeAnimation
                    easing.type: Easing.InCubic
                }

                property bool isCurrent: item.GridView.view.currentIndex === model.index
                width: iconWrapper.width * 1.2
                height: iconWrapper.height * 1.2

                scale: isCurrent ? (kicker.iconAnimation ? 1 : 0.83) : 0.83
                Behavior on scale {
                    NumberAnimation {
                        duration: kicker.timeAnimation
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        PlasmaComponents3.Label {
            id: label
            visible: item.showLabel
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 2
            elide: Text.ElideMiddle
            wrapMode: Text.Wrap
            color: Kirigami.Theme.textColor
            font.pointSize: Kirigami.Theme.defaultFont.pointSize + 0.5
            text: ("name" in model ? model.name : model.display)
            textFormat: Text.PlainText
        }
    }

    // =========================================================================
    // CONTROL DE INTERACCIÓN CENTRALIZADO (MouseArea nativo con ToolTip integrado)
    // =========================================================================
    MouseArea {
        id: delegateMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        propagateComposedEvents: true
        property int pressX: -1
        property int pressY: -1

        onEntered: {
            // SOLUCIÓN: Si el menú de este kicker (o de KDE) está abierto,
            // congelamos por completo el cambio de índice para evitar saltos molestos.
            if (kicker.contextMenuOpen || itemGrid.lockHover) {
                if (!itemGrid.lockHover) itemGrid.lockHover = true;
                return;
            }

            if (item.GridView.view) {
                item.GridView.view.currentIndex = model.index;
                item.GridView.view.focus = true;
            }
        }

        onPressed: mouse => {
            pressX = mouse.x;
            pressY = mouse.y;

            if (mouse.button === Qt.RightButton) {
                mouse.accepted = true;
                if (item.hasActionList) {
                    // Bloqueo inmediato antes de renderizar el menú
                    itemGrid.lockHover = true;

                    // Nos aseguramos de que esta celda sea la actual antes de abrir el menú
                    if (item.GridView.view) {
                        item.GridView.view.currentIndex = model.index;
                    }

                    var mapped = mapToItem(item, mouse.x, mouse.y);
                    item.openActionMenu(mapped.x, mapped.y);
                }
            }
        }

        onPositionChanged: mouse => {
            if (itemGrid.dragEnabled && pressX !== -1 && dragHelper.isDrag(pressX, pressY, mouse.x, mouse.y)) {
                mouse.accepted = true;
                if ("pluginName" in item.m) {
                    dragHelper.startDrag(kicker, item.url, item.icon, "text/x-plasmoidservicename", item.m.pluginName);
                } else {
                    dragHelper.startDrag(kicker, item.url);
                }
                kicker.dragSource = item;
                pressX = pressY = -1;
            }
        }

        onReleased: mouse => {
            if (mouse.button === Qt.LeftButton && !dragHelper.dragging) {
                mouse.accepted = true;
                if ("trigger" in item.GridView.view.model) {
                    item.GridView.view.model.trigger(model.index, "", null);
                    kicker.toggle();
                }
                itemGrid.itemActivated(model.index, "", null);
            }
            pressX = pressY = -1;
        }

        PlasmaCore.ToolTipArea {
            id: toolTip
            anchors.fill: parent
            property string text: model.display
            active: kicker.visible && label.truncated && !kicker.contextMenuOpen // Desactivar tooltip si el menú está abierto
            mainItem: toolTipDelegate

            onContainsMouseChanged: {
                if (!kicker.contextMenuOpen && !itemGrid.lockHover) {
                    item.GridView.view.itemContainsMouseChanged(containsMouse);
                }
            }
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Menu && hasActionList) {
            event.accepted = true;
            // Forzar bloqueo al abrir por teclado
            itemGrid.lockHover = true;
            openActionMenu(item.width / 2, item.height / 2);
        } else if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            event.accepted = true;

            if ("trigger" in GridView.view.model) {
                GridView.view.model.trigger(index, "", null);
                kicker.toggle();
            }

            itemGrid.itemActivated(index, "", null);
        }
    }

    function openActionMenu(x, y) {
        var actionList = hasActionList ? model.actionList : [];
        Tools.fillActionMenu(i18n, actionMenu, actionList, GridView.view.model.favoritesModel, model.favoriteId);
        actionMenu.visualParent = item;

        // CONECTAR EL CIERRE DEL MENÚ (Cura definitiva del Bug)
        // Buscamos interceptar cuando el menu se cierre para devolver el control al hover de la grilla
        if (actionMenu.closed !== undefined) {
            actionMenu.closed.disconnect(resetLockHover); // Evitar conexiones duplicadas
            actionMenu.closed.connect(resetLockHover);
        }

        actionMenu.open(x, y);
    }

    // Función auxiliar para limpiar estados al cerrar el menú contextual
    function resetLockHover() {
        itemGrid.lockHover = false;
    }

    function actionTriggered(actionId, actionArgument) {
        var close = (Tools.triggerAction(GridView.view.model, model.index, actionId, actionArgument) === true);
        if (close) { kicker.toggle(); }
    }
}
