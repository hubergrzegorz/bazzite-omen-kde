
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.ksvg 1.0 as KSvg
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.kirigami 2.0  as Kirigami
import org.kde.plasma.plasmoid 2.0
Item
{
    id: containerx2
    property alias favoritesGrid: globalFavoritesGrid
    readonly property int myIndex: 0
    readonly property bool isActiveFav:kicker.stateflag === myIndex && !kicker.isShowingRunner

    width: parent.width
    height: parent.height

    opacity: isActiveFav ? 1 : 0
    enabled: isActiveFav || opacity > 0
    z: isActiveFav ? 10 : 1

    transform: Translate {
        id: selectorTransform
        x: !kicker.useCarousel ? 0 :
        containerx2.isActiveFav ? 0 : // Posición central cuando está activo
        (containerx2.myIndex < kicker.stateflag ? -rootItem.width : rootItem.width) // Salida completa

        Behavior on x {
            NumberAnimation {
                duration: kicker.timeAnimation
                easing.type: Easing.OutCubic // Ambos usan la misma curva para ir a la par
            }
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration:kicker.fadeAnimation ? kicker.timeAnimation : 0;
            easing.type: isActiveFav ? Easing.OutCubic : Easing.OutQuad

        }
    }

    visible: opacity > 0
    PC3.ScrollView
        {
            id: cont_fav_places
            spacing: 15 // Espacio entre secciones
            width: parent.width;
            height: parent.height;
            PC3.ScrollBar.horizontal.policy: PC3.ScrollBar.AlwaysOff
            ColumnLayout
            {
                width: rootItem.width
                spacing: 0
                //favoritos
                RowLayout
                {

                    Layout.fillWidth: true
                    Layout.bottomMargin: 10

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        Layout.leftMargin: 5
                        Layout.rightMargin: 15
                        Layout.bottomMargin: 8
                        radius: 5
                        opacity: 0.4

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            PC3.Label {
                                text: "Aplicaciones Favoritas"
                                font.bold: true
                                font.pointSize: 11
                                opacity: 0.8
                                Layout.fillWidth: true
                                Layout.leftMargin: 10 // Ahora este margen sí funcionará

                            }
                        }
                    }

                }

                ItemGridView
                {
                    id: globalFavoritesGrid
                    dragEnabled: true
                    dropEnabled: true
                    focus: true
                    //cellWidth:   kicker.cellSizeWidth
                    cellHeight:  kicker.cellSizeHeight
                    iconSize:    kicker.iconSize
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model:globalFavorites
                }
                Kirigami.Separator
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                    opacity:0.3
                }
                //folders
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.leftMargin: 5
                    Layout.rightMargin: 15
                    Layout.bottomMargin: 8
                    radius: 5
                    opacity: 0.3

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        PC3.Label {
                            text: "Carpetas y Lugares"
                            font.bold: true
                            font.pointSize: 11
                            opacity: 0.8
                            Layout.fillWidth: true
                            Layout.leftMargin: 10 // Ahora este margen sí funcionará
                        }
                    }
                }
                ItemGridView
                {
                    id: folderplaces
                    clip: true
                    iconSize: kicker.iconSize
                    //cellWidth: kicker.cellSizeWidth
                    cellHeight: kicker.cellSizeHeight
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model : computerModel

                }


                Item { Layout.preferredHeight: 10 }
            }
        }
    }
