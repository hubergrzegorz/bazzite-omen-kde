
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
    id: rootItem
    property int contador_rep:0;
    property bool contextMenuOpen: false

    property bool searchvisible : Plasmoid.configuration.showSearch
    property bool menuCategories: Plasmoid.configuration.menuCategories;
    property int userShape : calculateUserShape(Plasmoid.configuration.userShape);
    property bool useGrid: Plasmoid.configuration.recentgrid
    property bool useHorizontal: Plasmoid.configuration.useHorizontalFav

    readonly property int headerHeight: Plasmoid.configuration.showInfoUser ? 130 : 0
    readonly property int searchHeight: rootItem.searchvisible ? 45 : 0
    readonly property int footerHeight: kicker.view_any_controls ? 25 : 0
    readonly property int categoriesHeight: rootItem.menuCategories ? 55 : 0

    property int visible_items: headerHeight + searchHeight + footerHeight + categoriesHeight + Kirigami.Units.gridUnit

    readonly property rect screenRect: kicker.availableScreenRect
    property int columns_p:Plasmoid.configuration.numberColumns
    property int rows_p:Plasmoid.configuration.numberRows

    property int calc_width: (kicker.cellSizeWidth * Plasmoid.configuration.numberColumns) + Kirigami.Units.gridUnit
    property int space_width: Math.min(calc_width, screenRect.width - (Kirigami.Units.gridUnit * 2))
    property int cuadricula_hg: (kicker.cellSizeHeight * Plasmoid.configuration.numberRows)
    property int calc_height: cuadricula_hg + rootItem.visible_items
    property int space_height: Math.min(calc_height, screenRect.height - (Kirigami.Units.gridUnit * 2))
    property int quad_height: rootItem.calc_height - rootItem.visible_items
    property int quad_width: (rootItem.calc_width > rootItem.space_width) ? rootItem.space_width : rootItem.calc_width


    property int currentCategoryIndex: 0 ;
    property var currentAppsModel: rootModel.modelForRow(currentCategoryIndex)
    property var actualModel: rootModel.modelForRow(currentCategoryIndex)

    Layout.maximumWidth: rootItem.space_width
    Layout.minimumWidth: rootItem.space_width
    Layout.minimumHeight:rootItem.space_height
    Layout.maximumHeight:rootItem.space_height
    Layout.preferredHeight:rootItem.space_height
    Layout.preferredWidth:rootItem.space_width
    width: space_width
    height: space_height
    Layout.fillWidth: false
    Layout.fillHeight: false
    focus: true

    KCoreAddons.KUser {   id: kuser  }
    KSvg.FrameSvgItem
    {
        id : headingSvg
        width: parent.width + backgroundSvg.margins.left + backgroundSvg.margins.right
        height: Plasmoid.configuration.showInfoUser ? encabezado.height + Kirigami.Units.smallSpacing : Kirigami.Units.smallSpacing
        y: - backgroundSvg.margins.top
        x: - backgroundSvg.margins.left
        imagePath: "widgets/plasmoidheading"
        prefix: "header"
        opacity: Plasmoid.configuration.transparencyHead * 0.01
        visible: Plasmoid.configuration.showInfoUser
    }

    KSvg.FrameSvgItem
    {
        id: footerSvg
        visible: kicker.view_any_controls
        width: parent.width + backgroundSvg.margins.left + backgroundSvg.margins.right
        height:footer.Layout.preferredHeight + 2  + Kirigami.Units.smallSpacing * 3
        y: parent.height + Kirigami.Units.smallSpacing * 2 // - (footer.height + Kirigami.Units.smallSpacing)
        x: backgroundSvg.margins.left
        imagePath: "widgets/plasmoidheading"
        prefix: "header"
        transform: Rotation { angle: 180; origin.x: width / 2;}
        opacity: Plasmoid.configuration.transparencyFooter * 0.01
    }

    //contenedor del widget
    ColumnLayout
    {
    id:container
    anchors.fill: parent
    spacing: 0
        //encabezado
        Item
        {
            id: encabezado
            width: rootItem.space_width
            Layout.preferredHeight: 130
            visible:  Plasmoid.configuration.showInfoUser
            Loader
            {
                id: head_
                sourceComponent: headComponent
                onLoaded:
                {
                    var pinButton = head_.item.pinButton;
                    if (!activeFocus && kicker.hideOnWindowDeactivate === false)
                    {
                        if (!pinButton.checked) {turnclose();}
                    }
                }
            }
        }

        //cuadrillas
        Item
        {
           id: gridComponent
             Layout.fillHeight: true
             Layout.preferredWidth:rootItem.quad_width
            //------------------lista de favoritos-----------------------------------------------------
            Item
            {
                Layout.fillWidth: true
                width:  parent.width
                height: parent.height

                Loader
                {
                    id: hor_vert
                    width:  parent.width
                    height: parent.height
                    sourceComponent: useHorizontal ? container_fav_horizontal : container_fav_vertical
                }
            }
            //------------item para el panel para cuadrilla apps.--------------------------------------
            Item
            {
                id: allAppsGrid_container
                Layout.fillWidth: true
                width:  parent.width
                height: parent.height

                Loader
                {
                    id: allAppsGrid_loader
                    sourceComponent: allAppsGrid_component
                    width: parent.width
                    height: parent.height
                    Binding {
                        target: allAppsGrid_loader.item ? allAppsGrid_loader.item.allAppsGrid : null
                        property: "model"
                        value: rootItem.actualModel
                        when: allAppsGrid_loader.status === Loader.Ready
                    }
                }
            }
            //------item para el panel  app y files recientes-------------------------------
            Item
            {
                id:recent_contenedor
                width:  parent.width
                height: parent.height
                Loader
                {
                    id: recent_loader
                    width: parent.width
                    height: parent.height
                    sourceComponent: recent_component
                }
            }
            //--------------------------------------cuadrilla de resultados de busqueda
            ItemMultiGridView
            {
                id: runnerGrid
                width:  parent.width
                height: parent.height
                cellWidth:   kicker.cellSizeWidth
                cellHeight:  kicker.cellSizeHeight
                model: runnerModel
                grabFocus: true
                // Lógica de visibilidad de solo lectura
                readonly property bool isBusy: kicker.isShowingRunner
                opacity: isBusy ? 1.0 : 0.0
                visible: opacity > 0
                enabled: opacity === 1.0
                z: enabled ? 10 : -1
                onKeyNavUp: searchLoader.item.gofocus()
            }
        }
        //buscador
        Item
        {
            id: rowSearchField
            visible: rootItem.searchvisible
            Layout.preferredHeight:45
            width: rootItem.space_width
            Loader{id: searchLoader; sourceComponent: searchComponent}
        }
        //controles
        Item
        {
            id: footer
            Layout.preferredHeight:25
            visible: kicker.view_any_controls
            width: rootItem.quad_width
            Loader
            {id: foot_
             sourceComponent: footerComponent}
        }
    }

    //press key in menu representation
    Keys.onPressed: (event)=> {
        kicker.keyIn = "menurepresentation : " + event.key;
        event.accepted = true;
        if (event.key === Qt.Key_CapsLock ||
            event.key === Qt.Key_NumLock ||
            event.key === Qt.Key_ScrollLock ||
            event.key === Qt.Key_Control ||
            event.key === Qt.Key_Alt ||
            event.key === Qt.Key_Meta) {
            return; // Salimos sin hacer nada, manteniendo el panel actual (Recientes, etc.)
            }

            // 2. ATAJOS CON MODIFICADORES
            if (event.modifiers & Qt.ControlModifier) {
                searchLoader.item.gofocus();
                return;
            }

            // 3. LÓGICA DE NAVEGACIÓN Y ACCIÓN
            switch (event.key) {
                case Qt.Key_Escape:
                    if (kicker.searching) {
                        searchLoader.item.emptysearch();
                        rootItem.res_activate();
                    }
                    else{turnclose();} // O reset() + turnclose() según prefieras
                    break;
                case Qt.Key_Backspace:
                    if (kicker.searching) {
                        searchLoader.item.backspace();
                    }
                    break;
                case Qt.Key_Tab:
                case Qt.Key_Backtab:
                case Qt.Key_Down:
                case Qt.Key_Up:
                case Qt.Key_Left:
                case Qt.Key_Enter:
                case Qt.Key_Return:
                case Qt.Key_Right:
                    break;
                default:
                    if (event.text !== "" && isLetterOrNumber(event.text)) {
                        searchLoader.item.appendText(event.text);
                    }
                    break;
            }
            searchLoader.item.gofocus();
    }

    //component
    Component {id: footerComponent; Footer{}}
    Component {id: searchComponent; Search{}}
    Component {id: headComponent;     Head{}}
    Component {id: container_fav_horizontal; FavHorizontalGridView{}}
    Component {id: container_fav_vertical; FavVerticalGridView{}}
    Component {id: allAppsGrid_component; AllGridsViewer{} }
    Component {id:recent_component; RecentGridView{} }

    function obtenerUltimoIndice()
    {
        var totalFilas = recentAppsModel.count;
        var ultimoIndice = totalFilas - 1;
        return recentAppsModel.modelForRow(ultimoIndice);
    }

    function isLetterOrNumber(text)
    {
    return /^[a-zA-Z0-9+\-\*\/=]$/.test(text);
    }

    function turnclose()
    {
        searchLoader.item.emptysearch()
        kicker.searching=false;
        if (kicker.showFavorites)
        {
            kicker.stateflag=0;
            kicker.isShowingFavorites= true
            kicker.isShowingAllApps= false
            kicker.isShowingRunner= false
            kicker.isShowingAllApps=false
        }
        else
        {
            kicker.stateflag=1;
            kicker.isShowingFavorites= false
            kicker.isShowingAllApps= false
            kicker.isShowingRunner= false
            kicker.isShowingAllApps=true
        }
        rootItem.res_activate();
        kicker.expanded = false;
        return
    }

    function res_activate()
    {
        searchLoader.item.emptysearch()
        if (contextMenuOpen) return;
        if (kicker.showFavorites)
        {
            if (hor_vert.item && hor_vert.item.favoritesGrid)
            {
                hor_vert.item.favoritesGrid.tryActivate(0,0);
                hor_vert.item.favoritesGrid.forceActiveFocus();
            }
        }
        else if (kicker.isShowingAllApps)
        {
            var loaderItem = allAppsGrid_loader.item;
            if (loaderItem)
            {
                var grid = loaderItem.allAppsGrid;
                if (grid && loaderItem.count > 0)
                {
                    grid.tryActivate(0,0);
                    grid.forceActiveFocus();
                } else {
                    console.log("El Grid aún no tiene items cargados");
                }
            }
        }
        else if (kicker.isShowingHistory)
        {
            var loaderItem = recent_loader.item;
            if (loaderItem)
            {
                var grid = loaderItem.appHistory;
                if (grid && loaderItem.count > 0)
                {
                    grid.tryActivate(0,0);
                    grid.forceActiveFocus();
                } else {
                    console.log("El Grid aún no tiene items cargados");
                }
            }
        }
    }

    function reset()
    {
        searchLoader.item.emptysearch()
        kicker.searching = false;
        showHistory = false;

        if (kicker.showFavorites)
        {
            kicker.stateflag=0;
            kicker.isShowingFavorites= true
            kicker.isShowingAllApps= false
            kicker.isShowingRunner= false
            kicker.isShowingHistory=false
        }
        else
        {
            kicker.stateflag=1;
            kicker.isShowingFavorites= false
            kicker.isShowingAllApps= false
            kicker.isShowingRunner= false
            kicker.isShowingAllApps=true
        }
        rootItem.res_activate();
    }


    function calculateUserShape(shape)
    {
        switch (shape)
        {
        case 0: return (kicker.sizeImage * 0.85) / 2;
        case 1: return 8;
        case 2: return 0;
        default:return (kicker.sizeImage * 0.85) / 2;
        }
    }

    function updateHistoryModels()
    {
        recentAppsModel.refresh();
        appsHistory.sourceModel = recentAppsModel.modelForRow(0);
        if (docsLoader.item)
        {
            if (useGrid) {
                docsLoader.item.sourceModel = recentAppsModel.modelForRow(1);
            } else {
                docsLoader.item.model = recentAppsModel.modelForRow(1);
            }
        }
    }

    function setModels()
    {
    if (allAppsGrid_loader.item && allAppsGrid_loader.item.allAppsGrid)
        {
            allAppsGrid_loader.item.allAppsGrid.model = rootModel.modelForRow(rootItem.currentCategoryIndex);
            if (kicker.isShowingAllApps) { Qt.callLater(rootItem.res_activate);}
        }
        else
        { console.log("Error: No se encontró el componente cargado en el Loader");}

    }


    onVisibleChanged:
    {
            if (visible) {
                 // Solo cuando el Menú se muestra físicamente al usuario
                updateHistoryModels();
                rootItem.res_activate();
            }
    }

    onActiveFocusChanged: {
        if (!activeFocus) {
            // Lógica de cierre (solo si pierde el foco)
            if (kicker.hideOnWindowDeactivate === false) {
                if (head_.item && head_.item.pinButton && !head_.item.pinButton.checked) {
                    turnclose();
                }
            }
        } else {
            // Solo si GANA el foco y no es la apertura inicial (ya cubierta por onVisible)
            // O simplemente puedes eliminar esta línea si onVisible ya lo hace bien.
            // rootItem.res_activate();
        }

        if (rootItem.width == 0){rootItem.width=Layout.minimumWidth}

        console.log("avallible width: " + rootItem.space_width);
        console.log("avalible hegith: "+ rootItem.space_height);
        console.log("cuadricula width: "+ rootItem.quad_width);
        console.log("cuadricula height: "+ rootItem.quad_height);
        console.log("widget width: " + rootItem.width);
        console.log("widget hegith: "+ rootItem.height);
        console.log("widget maximumWidth: "+Layout.maximumWidth)
        console.log("widget minimumWidth: "+Layout.minimumWidth)
        console.log("widget minimumHeight: "+Layout.minimumHeight)
        console.log("widget maximumWidth: "+Layout.maximumHeight)
        console.log("---------------------------------------")


    }

    onCurrentCategoryIndexChanged: {
        // Actualizamos la propiedad; el Binding del Loader hará el resto solo
        rootItem.actualModel = rootModel.modelForRow(currentCategoryIndex)
        if (kicker.isShowingAllApps) {
            Qt.callLater(rootItem.res_activate)
        }
    }



    Component.onCompleted:
    {
        rootModel.refreshed.connect(setModels)
        rootItem.currentCategoryIndex = 0;
        rootModel.refresh();


    }

}
