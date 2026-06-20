var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "cachedWeather": "{\"success\":true,\"current\":{\"temp\":5,\"feels_like\":1,\"temp_min\":5,\"temp_max\":14,\"humidity\":76,\"pressure\":1015,\"clouds\":58,\"wind_speed\":14,\"wind_deg\":288,\"wind_gust\":34,\"precipitation\":0,\"uv_index\":4,\"sunrise\":\"2026-04-19T05:52\",\"sunset\":\"2026-04-19T19:56\",\"weather_code\":2,\"visibility\":34,\"dew_point\":1,\"cloud_cover\":58,\"description\":\"Partly Cloudy\",\"condition\":\"Partly Cloudy\",\"icon\":\"\",\"code\":2,\"location\":\"Wałbrzych\",\"coord\":{\"lat\":50.77141,\"lon\":16.28432},\"timestamp\":1776632431916},\"forecast\":{\"daily\":[{\"day\":0,\"date\":\"2026-04-19\",\"temp\":10,\"temp_min\":5,\"temp_max\":14,\"feels_like\":7,\"feels_like_max\":12,\"feels_like_min\":1,\"wind_speed\":18,\"wind_deg\":229,\"uv_index\":4,\"precipitation\":3.7,\"precipitation_probability\":78,\"humidity\":85,\"sunrise\":\"2026-04-19T05:52\",\"sunset\":\"2026-04-19T19:56\",\"code\":80,\"condition\":\"Rain Showers\",\"icon\":\"\",\"hasDetails\":true},{\"day\":1,\"date\":\"2026-04-20\",\"temp\":6,\"temp_min\":4,\"temp_max\":8,\"feels_like\":2,\"feels_like_max\":4,\"feels_like_min\":0,\"wind_speed\":15,\"wind_deg\":286,\"uv_index\":4,\"precipitation\":10.7,\"precipitation_probability\":85,\"humidity\":92,\"sunrise\":\"2026-04-20T05:49\",\"sunset\":\"2026-04-20T19:57\",\"code\":80,\"condition\":\"Rain Showers\",\"icon\":\"\",\"hasDetails\":true},{\"day\":2,\"date\":\"2026-04-21\",\"temp\":5,\"temp_min\":2,\"temp_max\":9,\"feels_like\":1,\"feels_like_max\":4,\"feels_like_min\":-2,\"wind_speed\":20,\"wind_deg\":21,\"uv_index\":5,\"precipitation\":2.9,\"precipitation_probability\":58,\"humidity\":98,\"sunrise\":\"2026-04-21T05:47\",\"sunset\":\"2026-04-21T19:59\",\"code\":80,\"condition\":\"Rain Showers\",\"icon\":\"\",\"hasDetails\":true},{\"day\":3,\"date\":\"2026-04-22\",\"temp\":6,\"temp_min\":1,\"temp_max\":11,\"feels_like\":2,\"feels_like_max\":7,\"feels_like_min\":-3,\"wind_speed\":16,\"wind_deg\":335,\"uv_index\":6,\"precipitation\":0,\"precipitation_probability\":0,\"humidity\":65,\"sunrise\":\"2026-04-22T05:45\",\"sunset\":\"2026-04-22T20:00\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":4,\"date\":\"2026-04-23\",\"temp\":9,\"temp_min\":5,\"temp_max\":13,\"feels_like\":5,\"feels_like_max\":9,\"feels_like_min\":1,\"wind_speed\":21,\"wind_deg\":313,\"uv_index\":5,\"precipitation\":0,\"precipitation_probability\":10,\"humidity\":83,\"sunrise\":\"2026-04-23T05:43\",\"sunset\":\"2026-04-23T20:02\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":5,\"date\":\"2026-04-24\",\"temp\":8,\"temp_min\":5,\"temp_max\":12,\"feels_like\":5,\"feels_like_max\":9,\"feels_like_min\":2,\"wind_speed\":14,\"wind_deg\":306,\"uv_index\":6,\"precipitation\":0,\"precipitation_probability\":8,\"humidity\":94,\"sunrise\":\"2026-04-24T05:41\",\"sunset\":\"2026-04-24T20:04\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":6,\"date\":\"2026-04-25\",\"temp\":6,\"temp_min\":2,\"temp_max\":10,\"feels_like\":0,\"feels_like_max\":5,\"feels_like_min\":-5,\"wind_speed\":27,\"wind_deg\":282,\"uv_index\":3,\"precipitation\":0.6,\"precipitation_probability\":15,\"humidity\":92,\"sunrise\":\"2026-04-25T05:39\",\"sunset\":\"2026-04-25T20:05\",\"code\":85,\"condition\":\"Snow Showers\",\"icon\":\"\",\"hasDetails\":true},{\"day\":0,\"date\":\"2026-04-26\",\"temp\":3,\"temp_min\":-1,\"temp_max\":7,\"feels_like\":-3,\"feels_like_max\":1,\"feels_like_min\":-6,\"wind_speed\":28,\"wind_deg\":314,\"uv_index\":4,\"precipitation\":1.8,\"precipitation_probability\":28,\"humidity\":96,\"sunrise\":\"2026-04-26T05:37\",\"sunset\":\"2026-04-26T20:07\",\"code\":71,\"condition\":\"Snow\",\"icon\":\"\",\"hasDetails\":true},{\"day\":1,\"date\":\"2026-04-27\",\"temp\":3,\"temp_min\":-3,\"temp_max\":8,\"feels_like\":-1,\"feels_like_max\":4,\"feels_like_min\":-6,\"wind_speed\":17,\"wind_deg\":323,\"uv_index\":5,\"precipitation\":0,\"precipitation_probability\":19,\"humidity\":95,\"sunrise\":\"2026-04-27T05:36\",\"sunset\":\"2026-04-27T20:08\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":2,\"date\":\"2026-04-28\",\"temp\":4,\"temp_min\":0,\"temp_max\":8,\"feels_like\":0,\"feels_like_max\":4,\"feels_like_min\":-3,\"wind_speed\":21,\"wind_deg\":9,\"uv_index\":6,\"precipitation\":0,\"precipitation_probability\":14,\"humidity\":83,\"sunrise\":\"2026-04-28T05:34\",\"sunset\":\"2026-04-28T20:10\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":3,\"date\":\"2026-04-29\",\"temp\":3,\"temp_min\":0,\"temp_max\":6,\"feels_like\":-1,\"feels_like_max\":2,\"feels_like_min\":-4,\"wind_speed\":22,\"wind_deg\":15,\"uv_index\":2,\"precipitation\":3.3,\"precipitation_probability\":19,\"humidity\":99,\"sunrise\":\"2026-04-29T05:32\",\"sunset\":\"2026-04-29T20:12\",\"code\":53,\"condition\":\"Drizzle\",\"icon\":\"\",\"hasDetails\":true},{\"day\":4,\"date\":\"2026-04-30\",\"temp\":8,\"temp_min\":4,\"temp_max\":12,\"feels_like\":4,\"feels_like_max\":8,\"feels_like_min\":1,\"wind_speed\":22,\"wind_deg\":49,\"uv_index\":4,\"precipitation\":0.6,\"precipitation_probability\":25,\"humidity\":100,\"sunrise\":\"2026-04-30T05:30\",\"sunset\":\"2026-04-30T20:13\",\"code\":51,\"condition\":\"Drizzle\",\"icon\":\"\",\"hasDetails\":true}],\"hourly\":[{\"time\":\"0:00\",\"timestamp\":1776636000000,\"temp\":5,\"code\":2,\"condition\":\"Partly Cloudy\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"1:00\",\"timestamp\":1776639600000,\"temp\":4,\"code\":2,\"condition\":\"Partly Cloudy\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"2:00\",\"timestamp\":1776643200000,\"temp\":4,\"code\":2,\"condition\":\"Partly Cloudy\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"3:00\",\"timestamp\":1776646800000,\"temp\":4,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"4:00\",\"timestamp\":1776650400000,\"temp\":5,\"code\":2,\"condition\":\"Partly Cloudy\",\"precipitation\":0,\"precipitation_probability\":3,\"icon\":\"\"},{\"time\":\"5:00\",\"timestamp\":1776654000000,\"temp\":5,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":10,\"icon\":\"\"},{\"time\":\"6:00\",\"timestamp\":1776657600000,\"temp\":5,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":20,\"icon\":\"\"},{\"time\":\"7:00\",\"timestamp\":1776661200000,\"temp\":5,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":33,\"icon\":\"\"},{\"time\":\"8:00\",\"timestamp\":1776664800000,\"temp\":5,\"code\":61,\"condition\":\"Rain\",\"precipitation\":0,\"precipitation_probability\":38,\"icon\":\"\"},{\"time\":\"9:00\",\"timestamp\":1776668400000,\"temp\":7,\"code\":2,\"condition\":\"Partly Cloudy\",\"precipitation\":0,\"precipitation_probability\":45,\"icon\":\"\"},{\"time\":\"10:00\",\"timestamp\":1776672000000,\"temp\":8,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":0,\"precipitation_probability\":45,\"icon\":\"\"},{\"time\":\"11:00\",\"timestamp\":1776675600000,\"temp\":7,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":0,\"precipitation_probability\":55,\"icon\":\"\"},{\"time\":\"12:00\",\"timestamp\":1776679200000,\"temp\":7,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":0.5,\"precipitation_probability\":63,\"icon\":\"\"},{\"time\":\"13:00\",\"timestamp\":1776682800000,\"temp\":7,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":1.2,\"precipitation_probability\":73,\"icon\":\"\"},{\"time\":\"14:00\",\"timestamp\":1776686400000,\"temp\":7,\"code\":61,\"condition\":\"Rain\",\"precipitation\":1.1,\"precipitation_probability\":80,\"icon\":\"\"},{\"time\":\"15:00\",\"timestamp\":1776690000000,\"temp\":7,\"code\":63,\"condition\":\"Rain\",\"precipitation\":2.7,\"precipitation_probability\":80,\"icon\":\"\"},{\"time\":\"16:00\",\"timestamp\":1776693600000,\"temp\":6,\"code\":61,\"condition\":\"Rain\",\"precipitation\":0.8,\"precipitation_probability\":80,\"icon\":\"\"},{\"time\":\"17:00\",\"timestamp\":1776697200000,\"temp\":6,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":1.5,\"precipitation_probability\":85,\"icon\":\"\"},{\"time\":\"18:00\",\"timestamp\":1776700800000,\"temp\":6,\"code\":61,\"condition\":\"Rain\",\"precipitation\":0.4,\"precipitation_probability\":85,\"icon\":\"\"},{\"time\":\"19:00\",\"timestamp\":1776704400000,\"temp\":6,\"code\":61,\"condition\":\"Rain\",\"precipitation\":0.4,\"precipitation_probability\":73,\"icon\":\"\"},{\"time\":\"20:00\",\"timestamp\":1776708000000,\"temp\":5,\"code\":61,\"condition\":\"Rain\",\"precipitation\":0.4,\"precipitation_probability\":68,\"icon\":\"\"},{\"time\":\"21:00\",\"timestamp\":1776711600000,\"temp\":5,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":0.6,\"precipitation_probability\":53,\"icon\":\"\"},{\"time\":\"22:00\",\"timestamp\":1776715200000,\"temp\":5,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":0.8,\"precipitation_probability\":53,\"icon\":\"\"},{\"time\":\"23:00\",\"timestamp\":1776718800000,\"temp\":4,\"code\":80,\"condition\":\"Rain Showers\",\"precipitation\":0.3,\"precipitation_probability\":58,\"icon\":\"\"}]},\"provider\":\"openmeteo\"}",
                            "lastUpdate": "1776632431931",
                            "locationMode": "manual"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "com.mcc45tr.mweather",
                    "title": "MWeather"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "flameStyle": "2",
                            "showLoadText": "false",
                            "showTempText": "false",
                            "transparentBackground": "true"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "com.github.khlesk.cpuflame",
                    "title": "CPU Flame"
                }
            ],
            "config": {
                "/": {
                    "ItemGeometries-1422x800": "Applet-29:816,0,592,288,0;",
                    "ItemGeometries-1920x1080": "Applet-29:1312,0,608,288,0;Applet-94:1664,288,256,256,0;",
                    "ItemGeometriesHorizontal": "Applet-29:1312,0,608,288,0;Applet-94:1664,288,256,256,0;",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "630",
                    "DialogWidth": "810"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "/home/grzegorz/MEGA/Systemy/skel/kame-house-dragon-3840x2160-25003.jpg",
                    "SlidePaths": "/usr/share/wallpapers/"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        },
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "1",
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
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "571",
                            "popupWidth": "635"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "animationDuration": "200",
                            "appIconSize": "3",
                            "appsIconSize": "4",
                            "backgroundOpacity": "70",
                            "compactListItems": "true",
                            "compactMode": "true",
                            "dashboardApps": "[{\"desktopFile\":\"applications:org.kde.dolphin.desktop\",\"name\":\"Dolphin\",\"icon\":\"org.kde.dolphin\"},{\"desktopFile\":\"applications:omen-rgb.desktop\",\"name\":\"HP OMEN RGB Master\",\"icon\":\"/home/grzegorz/.local/share/omen-rgb/logo.png\"},{\"desktopFile\":\"applications:virtualbox.desktop\",\"name\":\"Oracle VirtualBox\",\"icon\":\"virtualbox\"},{\"desktopFile\":\"applications:kde-theme-manager.desktop\",\"name\":\"KDE Theme Manager\",\"icon\":\"preferences-desktop-theme\"},{\"desktopFile\":\"applications:org.kde.konsole.desktop\",\"name\":\"Konsola\",\"icon\":\"utilities-terminal\"},{\"desktopFile\":\"applications:kalkulator_procenty.desktop\",\"name\":\"Kalkulator Procenty\",\"icon\":\"/home/grzegorz/MEGA/Ważne/Moje DPD/ikona_procenty.png\"},{\"desktopFile\":\"applications:systemsettings.desktop\",\"name\":\"Ustawienia systemowe\",\"icon\":\"preferences-system\"},{\"desktopFile\":\"applications:org.kde.plasma-systemmonitor.desktop\",\"name\":\"Monitor systemowy\",\"icon\":\"utilities-system-monitor\"},{\"desktopFile\":\"applications:page.kramo.Cartridges.desktop\",\"name\":\"Cartridges\",\"icon\":\"page.kramo.Cartridges\"},{\"desktopFile\":\"applications:nvidia-settings.desktop\",\"name\":\"Ustawienia serwera X NVIDIA\",\"icon\":\"nvidia-settings\"},{\"desktopFile\":\"applications:btrfs-assistant.desktop\",\"name\":\"Btrfs Assistant\",\"icon\":\"btrfs-assistant\"}]",
                            "favoritesPortedToKAstats": "true",
                            "icon": "fedora-logo-icon",
                            "iconEntranceDuration": "300",
                            "navPos": "1",
                            "showActionButtonCaptions": "false",
                            "showActiveApps": "false",
                            "showAllAppsInGrid": "false",
                            "showAllAppsInList": "true",
                            "showRecentAppsSection": "false",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown"
                        }
                    },
                    "plugin": "io.github.jinliu.kickon"
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
                            "launchers": "preferred://filemanager,applications:org.kde.discover.desktop,applications:org.kde.konsole.desktop,preferred://browser,applications:io.github.hkdb.Aerion.desktop",
                            "taskSpacingSize": "7",
                            "useBorders": "false"
                        }
                    },
                    "plugin": "io.github.daydve.fancytasksng"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
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
            "height": 3.5555555555555554,
            "hiding": "normal",
            "location": "bottom",
            "maximumLength": 106.66666666666667,
            "minimumLength": 106.66666666666667,
            "offset": 0
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
