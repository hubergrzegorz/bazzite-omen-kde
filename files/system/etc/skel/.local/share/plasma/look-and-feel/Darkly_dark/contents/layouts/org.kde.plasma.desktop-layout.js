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
                            "cachedWeather": "{\"success\":true,\"current\":{\"temp\":10,\"feels_like\":6,\"temp_min\":-1,\"temp_max\":14,\"humidity\":38,\"pressure\":1028,\"clouds\":100,\"wind_speed\":7,\"wind_deg\":102,\"wind_gust\":20,\"precipitation\":0,\"uv_index\":3,\"sunrise\":\"2026-03-08T06:23\",\"sunset\":\"2026-03-08T17:47\",\"weather_code\":3,\"visibility\":47,\"dew_point\":-4,\"cloud_cover\":100,\"description\":\"Overcast\",\"condition\":\"Overcast\",\"icon\":\"\",\"code\":3,\"location\":\"Wałbrzych\",\"coord\":{\"lat\":50.77141,\"lon\":16.28432},\"timestamp\":1772987419130},\"forecast\":{\"daily\":[{\"day\":0,\"date\":\"2026-03-08\",\"temp\":6,\"temp_min\":-1,\"temp_max\":14,\"feels_like\":3,\"feels_like_max\":9,\"feels_like_min\":-4,\"wind_speed\":14,\"wind_deg\":126,\"uv_index\":3,\"precipitation\":0,\"precipitation_probability\":0,\"humidity\":100,\"sunrise\":\"2026-03-08T06:23\",\"sunset\":\"2026-03-08T17:47\",\"code\":45,\"condition\":\"Fog\",\"icon\":\"\",\"hasDetails\":true},{\"day\":1,\"date\":\"2026-03-09\",\"temp\":7,\"temp_min\":-1,\"temp_max\":14,\"feels_like\":3,\"feels_like_max\":9,\"feels_like_min\":-4,\"wind_speed\":23,\"wind_deg\":185,\"uv_index\":4,\"precipitation\":0,\"precipitation_probability\":0,\"humidity\":90,\"sunrise\":\"2026-03-09T06:21\",\"sunset\":\"2026-03-09T17:49\",\"code\":0,\"condition\":\"Clear\",\"icon\":\"\",\"hasDetails\":true},{\"day\":2,\"date\":\"2026-03-10\",\"temp\":9,\"temp_min\":6,\"temp_max\":12,\"feels_like\":4,\"feels_like_max\":7,\"feels_like_min\":0,\"wind_speed\":21,\"wind_deg\":206,\"uv_index\":3,\"precipitation\":0,\"precipitation_probability\":8,\"humidity\":76,\"sunrise\":\"2026-03-10T06:19\",\"sunset\":\"2026-03-10T17:50\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":3,\"date\":\"2026-03-11\",\"temp\":10,\"temp_min\":6,\"temp_max\":15,\"feels_like\":7,\"feels_like_max\":11,\"feels_like_min\":3,\"wind_speed\":16,\"wind_deg\":204,\"uv_index\":4,\"precipitation\":0,\"precipitation_probability\":3,\"humidity\":78,\"sunrise\":\"2026-03-11T06:17\",\"sunset\":\"2026-03-11T17:52\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":4,\"date\":\"2026-03-12\",\"temp\":7,\"temp_min\":6,\"temp_max\":9,\"feels_like\":5,\"feels_like_max\":7,\"feels_like_min\":3,\"wind_speed\":10,\"wind_deg\":241,\"uv_index\":2,\"precipitation\":2.1,\"precipitation_probability\":28,\"humidity\":87,\"sunrise\":\"2026-03-12T06:15\",\"sunset\":\"2026-03-12T17:54\",\"code\":61,\"condition\":\"Rain\",\"icon\":\"\",\"hasDetails\":true},{\"day\":5,\"date\":\"2026-03-13\",\"temp\":7,\"temp_min\":3,\"temp_max\":12,\"feels_like\":3,\"feels_like_max\":7,\"feels_like_min\":0,\"wind_speed\":20,\"wind_deg\":185,\"uv_index\":4,\"precipitation\":0,\"precipitation_probability\":4,\"humidity\":92,\"sunrise\":\"2026-03-13T06:12\",\"sunset\":\"2026-03-13T17:55\",\"code\":1,\"condition\":\"Mainly Clear\",\"icon\":\"\",\"hasDetails\":true},{\"day\":6,\"date\":\"2026-03-14\",\"temp\":8,\"temp_min\":4,\"temp_max\":12,\"feels_like\":6,\"feels_like_max\":11,\"feels_like_min\":1,\"wind_speed\":18,\"wind_deg\":219,\"uv_index\":4,\"precipitation\":0.7,\"precipitation_probability\":20,\"humidity\":94,\"sunrise\":\"2026-03-14T06:10\",\"sunset\":\"2026-03-14T17:57\",\"code\":61,\"condition\":\"Rain\",\"icon\":\"\",\"hasDetails\":true},{\"day\":0,\"date\":\"2026-03-15\",\"temp\":4,\"temp_min\":0,\"temp_max\":7,\"feels_like\":1,\"feels_like_max\":4,\"feels_like_min\":-2,\"wind_speed\":16,\"wind_deg\":247,\"uv_index\":1,\"precipitation\":3.8,\"precipitation_probability\":20,\"humidity\":98,\"sunrise\":\"2026-03-15T06:08\",\"sunset\":\"2026-03-15T17:59\",\"code\":61,\"condition\":\"Rain\",\"icon\":\"\",\"hasDetails\":true},{\"day\":1,\"date\":\"2026-03-16\",\"temp\":3,\"temp_min\":1,\"temp_max\":5,\"feels_like\":-1,\"feels_like_max\":0,\"feels_like_min\":-3,\"wind_speed\":28,\"wind_deg\":219,\"uv_index\":2,\"precipitation\":0,\"precipitation_probability\":32,\"humidity\":92,\"sunrise\":\"2026-03-16T06:06\",\"sunset\":\"2026-03-16T18:00\",\"code\":45,\"condition\":\"Fog\",\"icon\":\"\",\"hasDetails\":true},{\"day\":2,\"date\":\"2026-03-17\",\"temp\":7,\"temp_min\":5,\"temp_max\":9,\"feels_like\":3,\"feels_like_max\":7,\"feels_like_min\":-1,\"wind_speed\":26,\"wind_deg\":222,\"uv_index\":1,\"precipitation\":0,\"precipitation_probability\":16,\"humidity\":96,\"sunrise\":\"2026-03-17T06:03\",\"sunset\":\"2026-03-17T18:02\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true},{\"day\":3,\"date\":\"2026-03-18\",\"temp\":11,\"temp_min\":6,\"temp_max\":15,\"feels_like\":8,\"feels_like_max\":12,\"feels_like_min\":3,\"wind_speed\":19,\"wind_deg\":220,\"uv_index\":4,\"precipitation\":0,\"precipitation_probability\":10,\"humidity\":96,\"sunrise\":\"2026-03-18T06:01\",\"sunset\":\"2026-03-18T18:04\",\"code\":45,\"condition\":\"Fog\",\"icon\":\"\",\"hasDetails\":true},{\"day\":4,\"date\":\"2026-03-19\",\"temp\":9,\"temp_min\":5,\"temp_max\":12,\"feels_like\":6,\"feels_like_max\":11,\"feels_like_min\":2,\"wind_speed\":11,\"wind_deg\":317,\"uv_index\":2,\"precipitation\":0,\"precipitation_probability\":19,\"humidity\":87,\"sunrise\":\"2026-03-19T05:59\",\"sunset\":\"2026-03-19T18:05\",\"code\":3,\"condition\":\"Overcast\",\"icon\":\"\",\"hasDetails\":true}],\"hourly\":[{\"time\":\"18:00\",\"timestamp\":1772989200000,\"temp\":8,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"19:00\",\"timestamp\":1772992800000,\"temp\":6,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"20:00\",\"timestamp\":1772996400000,\"temp\":5,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"21:00\",\"timestamp\":1773000000000,\"temp\":4,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"22:00\",\"timestamp\":1773003600000,\"temp\":3,\"code\":3,\"condition\":\"Overcast\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"23:00\",\"timestamp\":1773007200000,\"temp\":3,\"code\":2,\"condition\":\"Partly Cloudy\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"0:00\",\"timestamp\":1773010800000,\"temp\":0,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"1:00\",\"timestamp\":1773014400000,\"temp\":-1,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"2:00\",\"timestamp\":1773018000000,\"temp\":0,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"3:00\",\"timestamp\":1773021600000,\"temp\":2,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"4:00\",\"timestamp\":1773025200000,\"temp\":4,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"5:00\",\"timestamp\":1773028800000,\"temp\":5,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"6:00\",\"timestamp\":1773032400000,\"temp\":6,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"7:00\",\"timestamp\":1773036000000,\"temp\":6,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"8:00\",\"timestamp\":1773039600000,\"temp\":8,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"9:00\",\"timestamp\":1773043200000,\"temp\":10,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"10:00\",\"timestamp\":1773046800000,\"temp\":11,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"11:00\",\"timestamp\":1773050400000,\"temp\":12,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"12:00\",\"timestamp\":1773054000000,\"temp\":13,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"13:00\",\"timestamp\":1773057600000,\"temp\":14,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"14:00\",\"timestamp\":1773061200000,\"temp\":14,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"15:00\",\"timestamp\":1773064800000,\"temp\":14,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"16:00\",\"timestamp\":1773068400000,\"temp\":13,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"},{\"time\":\"17:00\",\"timestamp\":1773072000000,\"temp\":13,\"code\":0,\"condition\":\"Clear\",\"precipitation\":0,\"precipitation_probability\":0,\"icon\":\"\"}]},\"provider\":\"openmeteo\"}",
                            "lastUpdate": "1772987419171",
                            "locationMode": "manual"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "com.mcc45tr.mweather",
                    "title": "MWeather"
                }
            ],
            "config": {
                "/": {
                    "ItemGeometries-1920x1080": "Applet-29:1312,0,608,288,0;",
                    "ItemGeometriesHorizontal": "Applet-29:1312,0,608,288,0;",
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
                    "Image": "/home/grzegorz/MEGA/Systemy/skel/GDWP-1091-Left-HD-No-Logo.jpg",
                    "SlidePaths": "/usr/share/wallpapers/"
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
                            "popupHeight": "586",
                            "popupWidth": "906"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "favoritesPortedToKAstats": "true",
                            "icon": "fedora-logo-icon",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.pager"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "buttonColorize": "true",
                            "buttonColorizeInactive": "true",
                            "forceStripes": "true",
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
                            "launchers": "preferred://filemanager,applications:org.kde.discover.desktop,applications:org.kde.konsole.desktop,preferred://browser,applications:org.mozilla.Thunderbird.desktop",
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
                    "plugin": "org.kde.plasma.systemtray"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "451",
                            "popupWidth": "396"
                        },
                        "/Appearance": {
                            "fontWeight": "400",
                            "showDate": "false"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
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
