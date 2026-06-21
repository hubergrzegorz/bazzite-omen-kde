
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.kquickcontrolsaddons 2.0
//import org.kde.plasma.private.quicklaunch 1.0
import QtQuick.Controls 2.15
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.plasma5support 2.0 as P5Support
import Qt5Compat.GraphicalEffects
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.kirigami 2.0  as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM
import org.kde.plasma.private.sessions as Sessions

Item
{

    RowLayout
    {
    id: searchComponent
    //width: rootItem.resizeWidth()  == 0 ? rootItem.calc_width : rootItem.resizeWidth()
    width: rootItem.space_width
    //Item { Layout.fillWidth: true}
    PC3.TextField
        {
            id: searchField
            visible: rootItem.searchvisible
            Layout.fillWidth: true
            placeholderText: i18n("Type here to search ...")
            topPadding: 10
            bottomPadding: 10
            focus:true
            leftPadding: Kirigami.Units.gridUnit + Kirigami.Units.iconSizes.small
            text: ""
            font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2

            onTextChanged:
            {
                runnerModel.query = text;

                if (text == "")
                {
                    // --- AQUÍ SE REGRESA AL PANEL ANTERIOR ---
                    kicker.searching = false;
                    kicker.isShowingRunner = false;
                    switch(kicker.stateflag)
                    {
                        case 0:  return kicker.isShowingFavorites = true;
                        case 1:  return kicker.isShowingAllApps = true;
                        case 2:  return kicker.isShowingHistory = true;
                    }
                    // Llamamos al reset para limpiar estados internos
                    //rootItem.reset();
                }
                else
                {
                    // --- ESTADO DE BÚSQUEDA ---
                    kicker.searching = true;
                    kicker.isShowingRunner = true;
                    kicker.isShowingFavorites = false;
                    kicker.isShowingAllApps = false;
                    kicker.isShowingHistory = false;

                }
            }

            Keys.onPressed:(event)=>
            {   kicker.keyIn = "search : " + event.key;
                if(event.modifiers & Qt.ControlModifier ||event.modifiers & Qt.ShiftModifier)
                {
                    focus:true;
                    return;
                }
                else if (event.key === Qt.Key_Tab)
                {
                    event.accepted = true;
                    focus:true;
                }
                else if (event.key === Qt.Key_Escape)
                {
                    event.accepted = true;
                    rootItem.turnclose()
                }
            }

            function backspace()
            {
                if (!kicker.expanded)
                {
                    return;
                }
                focus = true;
                text = text.slice(0, -1);
                if (text=="" || searchField.text == "")
                {
                    searchField.text = "";
                }
            }

            function appendText(newText)
            {
                if (!kicker.expanded)
                {
                    return;
                }
                kicker.searching=true;
                focus = true;
                text = text + newText;
            }

            Kirigami.Icon
            {
                source: 'search'
                anchors
                {
                    left: searchField.left
                    verticalCenter: searchField.verticalCenter
                    leftMargin: Kirigami.Units.smallSpacing * 2
                }
                height: Kirigami.Units.iconSizes.small
                width: height
            }
        }
    Item {Layout.fillWidth: true}
    PC3.ToolButton
        {
            id: btnFavorites
            icon.name: 'favorites'
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            visible: rootItem.searchvisible
            flat: !(kicker.stateflag === 0 && !kicker.searching)
            onClicked:
            {
                searchField.text = "";
                kicker.stateflag=0;
                kicker.showFavorites = true;
                kicker.isShowingFavorites=true;
                kicker.isShowingAllApps=false;
                kicker.isShowingHistory=false;
                kicker.isShowingRunner=false;
                rootItem.res_activate()
            }
            ToolTip.delay: 200
            ToolTip.timeout: 1000
            ToolTip.visible: hovered
            ToolTip.text: i18n("Favorites")
        }

        PC3.ToolButton
        {
            icon.name: "view-list-icons"
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            //flat: kicker.showFavorites
            flat: !(kicker.stateflag === 1 && !kicker.searching)
            visible: rootItem.searchvisible
            onClicked:
            {
                searchField.text = "";
                kicker.stateflag=1;
                kicker.showHistory = false;
                kicker.showFavorites = false;
                kicker.isShowingFavorites=false;
                kicker.isShowingAllApps=true;
                kicker.isShowingHistory=false;
                kicker.isShowingRunner=false;
                rootItem.res_activate()
            }
            ToolTip.delay: 200
            ToolTip.timeout: 1000
            ToolTip.visible: hovered
            ToolTip.text: i18n("All apps")
        }

        PC3.ToolButton {
            id: btnHistory
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            // 'document-open-recent' es el nombre estándar en Plasma
            icon.name: "document-open-recent"
            // Se verá 'flat' si no estamos viendo ni favoritos ni historial
            flat: !(kicker.stateflag === 2 && !kicker.searching)
            visible: rootItem.searchvisible
            onClicked: {
                searchField.text = "";
                kicker.stateflag=2;
                kicker.showFavorites = false;
                kicker.searching = false;
                kicker.showHistory = true;
                kicker.isShowingFavorites=false;
                kicker.isShowingAllApps=false;
                kicker.isShowingHistory=true;
                kicker.isShowingRunner=false;
                rootItem.res_activate()

            }
            ToolTip.delay: 200
            ToolTip.timeout: 1000
            ToolTip.visible: hovered
            ToolTip.text: i18n("Recent files")
        }

    }
    function emptysearch()
    {
        searchField.text = "";
    }
    function backspace()
    {
        searchField.backspace();
    }

    function appendText(p)
    {
        searchField.appendText(p);
    }
    function gofocus()
    {
        searchField.focus = true;
    }
}
