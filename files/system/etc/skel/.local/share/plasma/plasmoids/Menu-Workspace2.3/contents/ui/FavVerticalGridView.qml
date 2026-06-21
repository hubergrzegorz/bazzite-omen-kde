
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.private.kicker 0.1 as Kicker
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.kirigami 2.0  as Kirigami
import org.kde.plasma.plasmoid 2.0


Item
{
    id:containerx2

    readonly property int h_Height: Plasmoid.configuration.showInfoUser ? 130 : 0
    readonly property int s_Height: rootItem.searchvisible ? 45 : 0
    readonly property int f_Height: kicker.view_any_controls ? 25 : 0
    readonly property int c_Height: menuCategories ? 55 : 0
    property int v_items: h_Height + s_Height + f_Height + c_Height


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
        containerx2.isActiveFav ? 0 :
        (containerx2.myIndex < kicker.stateflag ? -rootItem.width : rootItem.width)

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
    //onOpacityChanged: { console.log("valor de stateflag desde FavVerticalGridView:  "+kicker.stateflag+ " valor de activeFav: " + isActiveFav);}
    visible: opacity > 0

    ColumnLayout
    {
        width: parent.width;
        height: parent.height
        RowLayout
        {
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true
        spacing: 0
        ColumnLayout
        {
            id: sideBarFolders
            Layout.preferredWidth: 250
            Layout.minimumWidth: 250
            Layout.maximumWidth: 250
            spacing: 0
            Rectangle
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Layout.bottomMargin: 8
                radius: 5
                opacity:0.4

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    PC3.Label {
                        text: "Folders y Lugares"
                        font.bold: true
                        font.pointSize: 10
                        Layout.fillWidth: true
                    }
                }
            }

            ListItemView
            {
                id: folderplaces
                model: computerModel
                width: 250
                Layout.preferredHeight:rootItem.height - (v_items + 100)
                Layout.fillWidth: true
                Layout.fillHeight: true

            }

        }

        // SECCIÓN DERECHA: Aplicaciones Favoritas
        ColumnLayout {
            id: mainAppsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Layout.bottomMargin: 8
                radius: 5
                opacity:0.4


                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    PC3.Label {
                        text: "Favoritos"
                        font.bold: true
                        font.pointSize: 10
                        Layout.fillWidth: true
                    }
                }
            }

          ItemGridView
          {
              id: globalFavoritesGrid
              Layout.fillWidth: true
              //Layout.preferredHeight: rootItem.height - (v_items + 100)
              Layout.fillHeight: true
              //width: rootItem.width
              iconSize: kicker.iconSize
              cellHeight: kicker.cellSizeHeight
              model: justAppModel
              // ENLACE HACIA ABAJO:
              // ENLACE HACIA ABAJO CORREGIDO
              /*onKeyNavDown: {
                  if (docsLoader.item) {
                      internalGrid.currentIndex = -1; // Liberamos la selección superior
                      if (useGrid) {
                          docsLoader.item.tryActivate(0, 0);
                      } else {
                          docsLoader.item.forceActiveFocus();
                          if (docsLoader.item.count > 0) docsLoader.item.currentIndex = 0;
                      }
                  }
              }*/


          }

        }

    }
    Kirigami.Separator {
        Layout.fillWidth: true
        Layout.topMargin:0
        Layout.bottomMargin:0
        Layout.rightMargin: 15
        opacity: 0.3
    }
    RowLayout
    {
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        Layout.preferredWidth:parent.width
        Infosystem
        {
            id: systemStatusInfo
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 100
            Layout.bottomMargin: 0
        }
    }
}


}

