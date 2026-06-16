
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.ksvg 1.0 as KSvg
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.kirigami 2.0  as Kirigami
import org.kde.plasma.plasmoid 2.0
FocusScope
{
    id:recent_class
    property alias appHistory: internalGrid
    property alias count: internalGrid.count
    readonly property bool isActive0: kicker.isShowingHistory && !kicker.isShowingRunner
    readonly property int myIndex: 2
    opacity: (isActive0 || (kicker.useCarousel && x !== 0)) ? 1 : 0
    enabled: isActive0 || opacity > 0
    z: isActive0 ? 10 : (opacity > 0 ? 5 : 1)
    transform: Translate {
        x: !kicker.useCarousel ? 0 : recent_class.isActive0 ? 0 : (recent_class.myIndex < kicker.stateflag ? -rootItem.width : rootItem.width)
        Behavior on x {
            NumberAnimation {
                duration: kicker.timeAnimation;
                easing.type: Easing.OutCubic
            }
        }
    }
    Behavior on opacity {
        SequentialAnimation {
            PauseAnimation {
                duration: (!kicker.fadeAnimation && kicker.useCarousel) ? kicker.timeAnimation : 0
            }
            NumberAnimation {
                duration: kicker.fadeAnimation ? kicker.timeAnimation : 0;
                easing.type: isActive0 ? Easing.OutCubic : Easing.OutQuad
            }
        }
    }
    visible: opacity > 0

    onOpacityChanged: { console.log("valor de stateflag desde RecentGridview:  "+kicker.stateflag+ " valor de active0: " + isActive0);}

    ColumnLayout
        {

            width: parent.width;
            height: parent.height;
            spacing: 0

            /* aplicaciones */
            RowLayout
            {
                Layout.fillWidth: true
                Layout.bottomMargin: 5
                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.leftMargin: 3
                    Layout.rightMargin: 3
                    Layout.bottomMargin: 3
                    radius: 5
                    opacity: 0.4

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        PC3.Label {
                            text: "Aplicaciones Recientes"
                            font.bold: true
                            font.pointSize: 11
                            opacity: 0.9
                            Layout.fillWidth: true
                            Layout.leftMargin: 10

                        }
                    }
                }

            }

            ItemGridView
            {
                id: internalGrid
                Layout.fillWidth: true
                Layout.preferredHeight: rootItem.height/3
                Layout.minimumHeight: rootItem.height/4
                Layout.maximumHeight: rootItem.height/3
                Layout.fillHeight: true
                width: rootItem.width
                iconSize: kicker.iconSize
                //cellWidth: kicker.cellSizeWidth
                cellHeight: kicker.cellSizeHeight
                model: justAppModel
                // ENLACE HACIA ABAJO:
                // ENLACE HACIA ABAJO CORREGIDO
                onKeyNavDown: {
                    if (docsLoader.item) {
                        internalGrid.currentIndex = -1; // Liberamos la selección superior
                        if (useGrid) {
                            docsLoader.item.tryActivate(0, 0);
                        } else {
                            docsLoader.item.forceActiveFocus();
                            if (docsLoader.item.count > 0) docsLoader.item.currentIndex = 0;
                        }
                    }
                }


            }

            // --- SECCIÓN 3: DOCUMENTOS ---
            RowLayout
            {
                Layout.fillWidth: true
                Layout.bottomMargin: 5
                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.leftMargin: 3
                    Layout.rightMargin: 3
                    Layout.bottomMargin: 3
                    radius: 5
                    opacity: 0.4

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        PC3.Label {
                            text: "Documentos Recientes"
                            font.bold: true
                            font.pointSize: 11
                            opacity: 0.9
                            Layout.fillWidth: true
                            Layout.leftMargin: 10

                        }
                    }
                }

            }
            RowLayout
            {

                id: docsContainer
                Layout.fillWidth: true
                Behavior on Layout.preferredHeight{
                    NumberAnimation { duration: kicker.timeAnimation; easing.type: Easing.InOutQuad }
                }
                Loader
                {
                        id: docsLoader
                        Layout.fillWidth: true
                        Layout.preferredHeight: rootItem.height / 3
                        Layout.minimumHeight: rootItem.height / 4
                        Layout.maximumHeight: rootItem.height / 3
                        Layout.fillHeight: true
                        focus: true
                        sourceComponent: useGrid ? gridComponent2 : listComponent
                }
            }

        }


    Component
    {
        id: listComponent;
        ListItemView
        {
            id: docsGrid2
            width: parent.width
            Layout.fillWidth: true
            model: recentAppsModel.modelForRow(1)
            kicker: kicker
            onKeyNavUp:
            {
                if (internalGrid.count > 0) {
                    // Le pedimos a la grilla superior que seleccione su última fila, columna 0
                    internalGrid.tryActivate(internalGrid.lastRow(), 0);
                    docsGrid2.currentIndex = -1;
                }
            }
        }

    }
    Component
    {
        id: gridComponent2
        ItemGridView
        {
            id: docsGrid
            anchors.fill: parent
            iconSize: kicker.iconSize
            //cellWidth: kicker.cellSizeWidth
            cellHeight: kicker.cellSizeHeight
            model: justFilesModel
            // ENLACE HACIA ARRIBA:
            onKeyNavUp:
            {
                if (internalGrid.count > 0) {
                    // Le pedimos a la grilla superior que seleccione su última fila, columna 0
                    internalGrid.tryActivate(internalGrid.lastRow(), 0);
                    docsGrid.currentIndex = -1;
                }
            }
        }
    }

}
