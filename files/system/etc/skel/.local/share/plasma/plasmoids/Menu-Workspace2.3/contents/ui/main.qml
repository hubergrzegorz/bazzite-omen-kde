/*   Copyright (C) 2024-2024 by Randy Abiel Cabrera                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.core as PlasmaCore
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.private.kicker as Kicker

PlasmoidItem
{
    id: kicker
    anchors.fill: parent
    signal reset

    //propiedades
    property bool isDash: Plasmoid.pluginName === "org.kde.plasma.kickerdash"
    switchWidth: isDash || !fullRepresentationItem ? 0 :fullRepresentationItem.Layout.minimumWidth
    switchHeight: isDash || !fullRepresentationItem ? 0 :fullRepresentationItem.Layout.minimumHeight
    compactRepresentation: isDash ? null : compactRepresentation
    preferredRepresentation: isDash ?fullRepresentation : null
    fullRepresentation: isDash ? compactRepresentation : menuRepresentation
    //propiedades de configuracion
    property bool showFavorites : Plasmoid.configuration.showFavoritesFirst
    property Item dragSource: null
    property bool searching: false
    //teclado
    property int currentColumn : 0
    property int currentRow : 0
    property int currentIndex: 0
    property int count: 0
    property string keyIn  : ""
    property int timeAnimation: Plasmoid.configuration.TimeAnimation
    property bool useCarousel:Plasmoid.configuration.AnimationTranslate
    property bool fadeAnimation:Plasmoid.configuration.AnimationFade
    property bool iconAnimation:Plasmoid.configuration.IconAnimation

    //comandos
    readonly property string systemPreferencesCMD: Plasmoid.configuration.systemPreferencesSettings
    readonly property string homeCMD: Plasmoid.configuration.homeSettings
    readonly property string appStoreCMD: Plasmoid.configuration.appStoreSettings
    property bool view_any_controls : Plasmoid.configuration.rebootEnabled || Plasmoid.configuration.shutDownEnabled || Plasmoid.configuration.systemPreferencesEnabled || Plasmoid.configuration.appStoreEnabled || Plasmoid.configuration.sleepEnabled || Plasmoid.configuration.lockScreenEnabled  || Plasmoid.configuration.logOutEnabled ||  Plasmoid.configuration.homeEnabled
    //propiedades de imagen e iconos
    property int sizeImage: Kirigami.Units.iconSizes.large * 2.5
    Plasmoid.icon: Plasmoid.configuration.useCustomButtonImage ? Plasmoid.configuration.customButtonImage : Plasmoid.configuration.icon

    property int optionicon: Plasmoid.configuration.appsIconSize
    property int iconSize:
    {
        switch(Plasmoid.configuration.appsIconSize){
        case 0: return Kirigami.Units.iconSizes.smallMedium;
        case 1: return Kirigami.Units.iconSizes.medium;
        case 2: return Kirigami.Units.iconSizes.large;
        case 3: return Kirigami.Units.iconSizes.huge;
        case 4: return 96;
        case 5: return 128;
        default: return 64}
    }
    property int cellSizeWidth: cellSizeHeight + Kirigami.Units.gridUnit
    property int cellSizeHeight: iconSize + (Kirigami.Units.gridUnit * 2) + ( Math.max(highlightItemSvg.margins.top +  (highlightItemSvg.margins.bottom*2), highlightItemSvg.margins.left + highlightItemSvg.margins.right)) + 3

    // --- Banderas Maestras de Estado ---
    property int  stateflag: Plasmoid.configuration.showFavoritesFirst == true ? 0 : 1
    property bool isShowingFavorites: Plasmoid.configuration.showFavoritesFirst
    property bool isShowingHistory: false
    property bool isShowingRunner: kicker.searching
    property bool isShowingAllApps: !isShowingFavorites && !isShowingHistory && !isShowingRunner
    property bool showHistory: false

    // Sincronización con el motor de Plasma
    onIsShowingFavoritesChanged: {
        if (typeof kicker !== "undefined") {
            kicker.showFavorites = isShowingFavorites;
        }
    }

    //propiedades de objetos qt
    property QtObject globalFavorites: rootModel.favoritesModel
    property QtObject systemFavorites: rootModel.systemFavoritesModel

    //models
    Kicker.RootModel
    {
        id: rootModel
        autoPopulate: false
        appNameFormat: 0
        flat: true
        sorted: true
        showSeparators: false
        appletInterface: kicker
        showAllApps: true
        showRecentApps: false
        showRecentDocs: false
        showPowerSession: true

        onShowRecentAppsChanged:{ Plasmoid.configuration.showRecentApps = showRecentApps;}
        onShowRecentDocsChanged: { Plasmoid.configuration.showRecentDocs = showRecentDocs;}
        onRecentOrderingChanged: {Plasmoid.configuration.recentOrdering = recentOrdering;}
        Component.onCompleted:
        {
            favoritesModel.initForClient("org.kde.plasma.kicker.favorites.instance-" + Plasmoid.id)
            if (!Plasmoid.configuration.favoritesPortedToKAstats)
            {
                if (favoritesModel.count < 1)
                {
                    favoritesModel.portOldFavorites(Plasmoid.configuration.favoriteApps);
                }
                Plasmoid.configuration.favoritesPortedToKAstats = true;
            }
        }
    }


    Kicker.RootModel
    {
        id: recentAppsModel
        autoPopulate: true
        appNameFormat: 0
        flat: true
        sorted: true
        showSeparators: false
        showAllApps: false
        showRecentApps: true
        showRecentDocs: true
        showPowerSession: false
        onShowRecentAppsChanged:{ Plasmoid.configuration.showRecentApps = showRecentApps;}
        onShowRecentDocsChanged: { Plasmoid.configuration.showRecentDocs = showRecentDocs;}
        onRecentOrderingChanged: {Plasmoid.configuration.recentOrdering = recentOrdering;}
    }

    /*readonly property Kicker.RootModel rootModel: Kicker.RootModel {
        appletInterface: root // 'root' es el id de tu componente principal
    }*/

    // Este es el modelo que contiene las carpetas (Home, Root, Trash, etc.)
    readonly property Kicker.ComputerModel computerModel: Kicker.ComputerModel
    {
        favoritesModel: rootModel.favoritesModel
        //systemApplications: false // Cambia a false si SOLO quieres carpetas y no apps de sistema
    }


    /* no existe todavia en recentUsageModel.cpp
     * Kicker.RecentUsageModel {
        id: justFolderModel
        shownItems: Kicker.RecentUsageModel.OnlyFolders;

    }
    * construirlo significa construir una lista que divida en secciones a los 3 elementos que estan juntos.
    */

    Kicker.RecentUsageModel
    {
        id: justAppModel;
        shownItems: Kicker.RecentUsageModel.OnlyApps;

    }

    Kicker.RecentUsageModel
    {
        id: justFilesModel
        shownItems: Kicker.RecentUsageModel.OnlyDocs
    }


    Kicker.RunnerModel
    {
        id: runnerModel
        appletInterface: kicker
        favoritesModel: globalFavorites
        runners:
        {
            const results = ["krunner_services",
            "krunner_systemsettings",
            "krunner_sessions",
            "krunner_powerdevil",
            "calculator",
            "unitconverter"];
            if (Plasmoid.configuration.useExtraRunners) {results.push(...Plasmoid.configuration.extraRunners);}
            return results;
        }
    }

    Kicker.DragHelper
    {   id: dragHelper
        dragIconSize: Kirigami.Units.iconSizes.medium
    }
    Kicker.ProcessRunner {id: processRunner}
    Kicker.WindowSystem  { id: windowSystem}

    //conexiones
    Connections
    {
        target: globalFavorites
        function onFavoritesChanged() { Plasmoid.configuration.favoriteApps = target.favorites;}
    }

    Connections
    {
        target: systemFavorites
        function onFavoritesChanged() {Plasmoid.configuration.favoriteSystemActions = target.favorites;}
    }

    Connections
    {
        target: Plasmoid.configuration
        function onFavoriteAppsChanged () { globalFavorites.favorites = Plasmoid.configuration.favoriteApps;}
        function onFavoriteSystemActionsChanged () {systemFavorites.favorites = Plasmoid.configuration.favoriteSystemActions;}
        function onHiddenApplicationsChanged(){rootModel.refresh();}
    }

    Connections
    {
        target: kicker
        function onExpandedChanged(expanded)
        {
            if (expanded)
            {
                windowSystem.monitorWindowVisibility(Plasmoid.fullRepresentationItem);
                justOpenedTimer.start();
                return_principal();
                kicker.searching = false;
            }
            else
            {
                if (fullRepresentationItem)
                {
                    kicker.showHistory = false;
                }
                kicker.reset();
            }
        }
    }

    //components IU
    PlasmaExtras.Menu
    {   id: contextMenu
        PlasmaExtras.MenuItem {action: Plasmoid.internalAction("configure")}
    }
    PlasmaExtras.Highlight
    {
        id: delegateHighlight
        visible: false
        z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
    }
    Kirigami.Heading
    {
     id: dummyHeading
     visible: false
     width: 0
     level: 5
    }
    //Svg
    KSvg.FrameSvgItem
    {
        id : panelSvg
        visible: false
        imagePath: "widgets/panel-background"
    }
    KSvg.FrameSvgItem
    {
        id : scrollbarSvg
        visible: false
        imagePath: "widgets/scrollbar"
    }
    KSvg.FrameSvgItem
    {
        id: highlightItemSvg
        visible: false
        imagePath: "widgets/viewitem"
        prefix: "hover"
    }
    KSvg.FrameSvgItem
    {
        id: listItemSvg
        visible: false
        imagePath: "widgets/listitem"
        prefix: "normal"
    }
    KSvg.FrameSvgItem
    {
        id : backgroundSvg
        visible: false
        imagePath: "dialogs/background"
    }

    PC3 .Label
    {
        id: toolTipDelegate
        width: contentWidth
        height: undefined
        property Item toolTip
        text: toolTip ? toolTip.text : ""
        textFormat: Text.PlainText
    }
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Edit Applications…")
            icon.name: "kmenuedit"
            visible: Plasmoid.immutability !== PlasmaCore.Types.SystemImmutable
            onTriggered: processRunner.runMenuEditor()
        }
    ]
    //Components
    Timer {
        id: justOpenedTimer
        repeat: false
        interval: 600
    }
    Component {
        id: compactRepresentation
        CompactRepresentation {}
    }
    Component {
        id: menuRepresentation
        MenuRepresentation {}
    }
    Component.onCompleted:
    {
        if (Plasmoid.hasOwnProperty("activationTogglesExpanded"))
        {
            Plasmoid.activationTogglesExpanded = !kicker.isDash
        }
        windowSystem.focusIn.connect(enableHideOnWindowDeactivate);
        kicker.hideOnWindowDeactivate = true;
        rootModel.refreshed.connect(reset);
        dragHelper.dropped.connect(resetDragSource);
    }

    //functions
    onSystemFavoritesChanged:{}
    function resetDragSource() { dragSource = null;}
    function toggle() { kicker.expanded=!kicker.expanded}
    function action_menuedit() { processRunner.runMenuEditor();}
    function enableHideOnWindowDeactivate() { kicker.hideOnWindowDeactivate = true;}

    /*funcion para cargar siempre la imagen principal all apps o favorites apps*/
    function return_principal()
    {
        if (fullRepresentationItem)
        {

            if (Plasmoid.configuration.showFavoritesFirst)
            {
                kicker.stateflag=0;
                kicker.showFavorites= true;
                kicker.isShowingFavorites= true
                kicker.isShowingAllApps= false
                kicker.isShowingRunner= false
                kicker.isShowingHistory=false

            }
            else
            {
                kicker.showFavorites= false;
                kicker.stateflag=1;
                kicker.isShowingFavorites= false
                kicker.isShowingAllApps= true
                kicker.isShowingRunner= false
                kicker.isShowingHistory=false
            }

            kicker.searching = false;
            kicker.showHistory = false;
        }
    }

}
