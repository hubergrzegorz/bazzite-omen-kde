
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
    id: allAppsScope
    readonly property int myIndex: 1
    readonly property bool isActive: kicker.stateflag === myIndex && !kicker.isShowingRunner

    opacity: (isActive || (kicker.useCarousel && x !== 0)) ? 1 : 0
    enabled: isActive || opacity > 0
    //opacity: isActive ? 1 : 0
    z: isActive ? 10 : (opacity > 0 ? 5 : 1)
    transform: Translate {
        x: !kicker.useCarousel ? 0 : allAppsScope.isActive ? 0 : (allAppsScope.myIndex < kicker.stateflag ? -rootItem.width : rootItem.width)
        Behavior on x {
            NumberAnimation {
                duration: kicker.timeAnimation;
                easing.type: Easing.OutCubic
            }
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration:kicker.fadeAnimation ? kicker.timeAnimation : 0;
             easing.type: isActive ? Easing.OutCubic : Easing.OutQuad

        }
    }
    visible: opacity > 0
    onOpacityChanged: { console.log("valor de stateflag desde Allgridsviewer:  "+kicker.stateflag+ " valor de active: " + isActive);}
    property alias allAppsGrid: internalGrid
    property alias count: internalGrid.count
    ColumnLayout
    {
        // 1. LISTA DE CATEGORÍAS
        width: parent.width
        height: parent.height
        RowLayout
        {
            visible:rootItem.menuCategories
            Layout.fillWidth: true
            //Layout.preferredHeight: 48
            height:48
            spacing: 0
            PC3.ToolButton {
                icon.name: "go-previous"
                visible: !categoriesList.atBeginning
                onClicked: categoriesList.flick(1000, 0) // Empuja la lista a la izquierda
                height: 48


            }


            ListView
            {
                id: categoriesList

                Layout.fillWidth: true
                //Layout.fillHeight: true
                height:48
                model: rootModel
                //topMargin: (height - alturaDeseadaBoton) / 2
                currentIndex: rootItem.currentCategoryIndex // Vinculación directa
                interactive: true
                highlightMoveDuration: 200

                spacing: 12
                orientation: ListView.Horizontal
                clip: true // IMPORTANTE: Para que los elementos no se salgan de la fila

                delegate: PC3.Button
                {
                    id: categoryButton
                    // Dimensiones y lógica flat
                    width: implicitWidth + 20 // Un poco más de margen para que no esté apretado
                    height: 48
                    flat: categoriesList.currentIndex !== index
                    checkable: true
                    checked: categoriesList.currentIndex === index
                    text: model.display
                    icon.name: model.decoration

                    contentItem: RowLayout
                    {
                        spacing: 12

                        Kirigami.Icon {
                            source: categoryButton.icon.name
                            implicitWidth: 16
                            implicitHeight: 16
                            // Layout.alignment: Qt.AlignVCenter
                            // Cambia el color del icono si el botón está seleccionado
                            color: categoryButton.checked ? Kirigami.Theme.textColor : Kirigami.Theme.textColor
                            isMask: true
                        }

                        PC3.Label {
                            text: categoryButton.text
                            font: categoryButton.font
                            // Usamos Kirigami.Theme para evitar el error de "theme is not defined"
                            color: categoryButton.checked ? Kirigami.Theme.textColor : Kirigami.Theme.textColor
                            horizontalAlignment: Text.AlignLeft
                            //verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    onClicked: {
                        categoriesList.currentIndex = index
                        rootItem.currentCategoryIndex = index
                        //rootItem.setModels();
                        //console.log("altura del listview" + height);

                    }
                }

            }

            // Botón Derecha
            PC3.ToolButton {
                icon.name: "go-next"
                visible: !categoriesList.atEnd
                onClicked: categoriesList.flick(-1000, 0) // Empuja la lista a la derecha
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignVCenter
                implicitHeight: 32
            }
        }


        RowLayout
        {
        // 2. GRID DE APLICACIONES

            Layout.fillWidth: true
            Layout.fillHeight: true

        ItemGridView {
            id: internalGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: rootModel.modelForRow(rootItem.currentCategoryIndex)
            iconSize: kicker.iconSize
            columns: rootItem.columns_p
            rows: rootItem.rows_p
            //cellWidth: kicker.cellSizeWidth
            cellHeight: kicker.cellSizeHeight



        }
        }
}
}

