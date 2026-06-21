var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "ItemGeometries-1280x800": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/": {
                            "popupHeight": "181",
                            "popupWidth": "270"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "latitudeC": "50.720",
                            "longitudeC": "16.346",
                            "showConditionFull": "false",
                            "showConditionOnPanel": "false",
                            "updateInterval": "10",
                            "useCoordinatesIp": "false"
                        }
                    },
                    "plugin": "com.github.samy879.modernweather"
                },
                {
                    "config": {
                        "/General": {
                            "expanding": "false"
                        }
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "571",
                            "popupWidth": "520"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "AnimationFade": "true",
                            "AnimationTranslate": "true",
                            "IconAnimation": "true",
                            "alphaSort": "false",
                            "animationDuration": "200",
                            "appIconSize": "3",
                            "backgroundOpacity": "70",
                            "compactListItems": "true",
                            "customButtonImage": "fedora-logo-icon",
                            "dashboardApps": "[{\"desktopFile\":\"applications:org.kde.dolphin.desktop\",\"name\":\"Dolphin\",\"icon\":\"org.kde.dolphin\"},{\"desktopFile\":\"applications:omen-rgb.desktop\",\"name\":\"HP OMEN RGB Master\",\"icon\":\"/home/grzegorz/.local/share/omen-rgb/logo.png\"},{\"desktopFile\":\"applications:virtualbox.desktop\",\"name\":\"Oracle VirtualBox\",\"icon\":\"virtualbox\"},{\"desktopFile\":\"applications:kde-theme-manager.desktop\",\"name\":\"KDE Theme Manager\",\"icon\":\"preferences-desktop-theme\"},{\"desktopFile\":\"applications:org.kde.konsole.desktop\",\"name\":\"Konsola\",\"icon\":\"utilities-terminal\"},{\"desktopFile\":\"applications:kalkulator_procenty.desktop\",\"name\":\"Kalkulator Procenty\",\"icon\":\"/home/grzegorz/MEGA/Ważne/Moje DPD/ikona_procenty.png\"},{\"desktopFile\":\"applications:systemsettings.desktop\",\"name\":\"Ustawienia systemowe\",\"icon\":\"preferences-system\"},{\"desktopFile\":\"applications:org.kde.plasma-systemmonitor.desktop\",\"name\":\"Monitor systemowy\",\"icon\":\"utilities-system-monitor\"},{\"desktopFile\":\"applications:page.kramo.Cartridges.desktop\",\"name\":\"Cartridges\",\"icon\":\"page.kramo.Cartridges\"},{\"desktopFile\":\"applications:nvidia-settings.desktop\",\"name\":\"Ustawienia serwera X NVIDIA\",\"icon\":\"nvidia-settings\"},{\"desktopFile\":\"applications:btrfs-assistant.desktop\",\"name\":\"Btrfs Assistant\",\"icon\":\"btrfs-assistant\"}]",
                            "defaultTileColor": "#00000000",
                            "defaultTileGradient": "true",
                            "favoritesPortedToKAstats": "true",
                            "groupLabelAlignment": "center",
                            "hideUserControl": "true",
                            "highlightNewlyInstalledApps": "true",
                            "icon": "/usr/share/pixmaps/system-logo-white.png",
                            "iconEntranceDuration": "300",
                            "menuCategories": "true",
                            "navPos": "1",
                            "paneSwap": "false",
                            "showActionButtonCaptions": "false",
                            "showActiveApps": "false",
                            "showAllAppsInGrid": "false",
                            "showAllAppsInList": "true",
                            "showRecentAppsSection": "false",
                            "sidebarFollowsTheme": "true",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown",
                            "tileLabelAlignment": "center",
                            "tileModel": "W3sieCI6MCwieSI6MTAsInciOjYsImgiOjEsInVybCI6IiIsInRpbGVUeXBlIjoiZ3JvdXAiLCJsYWJlbCI6IlByb2R1Y3Rpdml0eSIsInB1c2hlZEZyb21YIjotMSwicHVzaGVkRnJvbVkiOi0xfSx7IngiOjAsInkiOjksInciOjYsImgiOjEsInVybCI6IiIsInRpbGVUeXBlIjoiZ3JvdXAiLCJsYWJlbCI6IkV4cGxvcmUiLCJwdXNoZWRGcm9tWCI6LTEsInB1c2hlZEZyb21ZIjotMX0seyJ4IjowLCJ5IjowLCJ3IjoyLCJoIjoyLCJ1cmwiOiJwcmVmZXJyZWQ6Ly9icm93c2VyIiwicHVzaGVkRnJvbVgiOi0xLCJwdXNoZWRGcm9tWSI6LTF9LHsieCI6MiwieSI6MCwidyI6MiwiaCI6MiwidXJsIjoic3RlYW0uZGVza3RvcCIsInB1c2hlZEZyb21YIjotMSwicHVzaGVkRnJvbVkiOi0xfSx7IngiOjQsInkiOjAsInciOjIsImgiOjIsInVybCI6Im9yZy5rZGUua29uc29sZS5kZXNrdG9wIiwicHVzaGVkRnJvbVgiOi0xLCJwdXNoZWRGcm9tWSI6LTF9LHsieCI6MiwieSI6MiwidyI6MiwiaCI6MiwidXJsIjoic3lzdGVtc2V0dGluZ3MuZGVza3RvcCIsInB1c2hlZEZyb21YIjotMSwicHVzaGVkRnJvbVkiOi0xfSx7IngiOjQsInkiOjIsInciOjIsImgiOjIsInVybCI6ImNvbS53YXJsb3Jkc29mdHdhcmVzLnlvdXR1YmUtZG93bmxvYWRlci00a3R1YmUuZGVza3RvcCIsInB1c2hlZEZyb21YIjotMSwicHVzaGVkRnJvbVkiOi0xfSx7IngiOjAsInkiOjQsInciOjIsImgiOjIsInVybCI6ImlvLmdpdGh1Yi5oa2RiLkFlcmlvbi5kZXNrdG9wIiwicHVzaGVkRnJvbVgiOi0xLCJwdXNoZWRGcm9tWSI6LTF9LHsieCI6NCwieSI6NCwidyI6MiwiaCI6MiwidXJsIjoiaW8uZ2l0aHViLmtvbHVubWkuQmF6YWFyLmRlc2t0b3AiLCJwdXNoZWRGcm9tWCI6LTEsInB1c2hlZEZyb21ZIjotMX0seyJ4IjoyLCJ5Ijo0LCJ3IjoyLCJoIjoyLCJ1cmwiOiJidHJmcy1hc3Npc3RhbnQuZGVza3RvcCIsInB1c2hlZEZyb21YIjotMSwicHVzaGVkRnJvbVkiOi0xfSx7IngiOjAsInkiOjIsInciOjIsImgiOjIsInVybCI6InBhZ2Uua3JhbW8uQ2FydHJpZGdlcy5kZXNrdG9wIiwicHVzaGVkRnJvbVgiOi0xLCJwdXNoZWRGcm9tWSI6LTF9XQ==",
                            "tilesLocked": "true",
                            "useCustomButtonImage": "true"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff-simplified"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "400",
                            "popupWidth": "560"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "buttonColorize": "true",
                            "buttonColorizeInactive": "true",
                            "iconEdgeOffset": "4",
                            "iconScale": "98",
                            "iconSizeOverride": "true",
                            "iconSpacing": "3",
                            "indicatorAccentColor": "false",
                            "indicatorDesaturate": "true",
                            "indicatorDominantColor": "true",
                            "indicatorGrow": "true",
                            "indicatorOverride": "true",
                            "indicatorProgress": "true",
                            "indicatorStyle": "2",
                            "indicatorsEnabled": "1",
                            "launchers": "applications:brave-browser.desktop,preferred://filemanager,applications:org.kde.konsole.desktop,applications:io.github.kolunmi.Bazaar.desktop",
                            "taskSpacingSize": "7",
                            "useBorders": "false"
                        }
                    },
                    "plugin": "io.github.daydve.fancytasksng"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.systemtray"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "441",
                            "popupWidth": "300"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.welevenclock"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 2.6666666666666665,
            "hiding": "normal",
            "lengthMode": "fill",
            "location": "bottom",
            "maximumLength": 71.11111111111111,
            "minimumLength": 71.11111111111111,
            "offset": 0,
            "opacity": "translucent"
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
