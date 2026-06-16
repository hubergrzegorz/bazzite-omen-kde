import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PC3
import org.kde.kirigami 2.20 as Kirigami
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.ksysguard.sensors 1.0 as Sensors
import Qt5Compat.GraphicalEffects

Item {
    id: fullSystemPanel
    implicitHeight: 120 // Un poco más de margen alto para albergar bien las etiquetas pequeñas

    property string osName: "Cargando..."
    property string kernelVer: "..."
    property string hwModel: "..."
    property int userShape: 32 // Definida variable que faltaba para el radio del avatar

    // Sensores de Hardware
    Sensors.Sensor { id: memUsed; sensorId: "memory/physical/used" }
    Sensors.Sensor { id: memTotal; sensorId: "memory/physical/total" }
    Sensors.Sensor { id: diskUsed; sensorId: "disk/all/used" }
    Sensors.Sensor { id: diskTotal; sensorId: "disk/all/total" }

    // Motor de datos (hostnamectl)
    P5Support.DataSource {
        id: infoSource
        engine: "executable"
        connectedSources: ["hostnamectl"]
        onNewData: function(sourceName, data) {
            var stdout = data["stdout"]
            if (stdout) {
                var osMatch = stdout.match(/Operating System: (.*)/)
                var kernelMatch = stdout.match(/Kernel: (.*)/)
                var modelMatch = stdout.match(/Hardware Model: (.*)/)

                if (osMatch) fullSystemPanel.osName = osMatch[1].trim()
                    if (kernelMatch) fullSystemPanel.kernelVer = kernelMatch[1].trim()
                        if (modelModel) fullSystemPanel.hwModel = modelMatch[1].trim()
            }
            disconnectSource("hostnamectl")
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        // --- SECCIÓN 1: IDENTIDAD ---
        KCoreAddons.KUser { id: kUser }

        ColumnLayout {
            // Se asume que kicker existe en el contexto global de Plasma, si no, puedes cambiarlo por un valor fijo
            visible: typeof kicker !== 'undefined' ? kicker.iconSize > 22 : true

            Rectangle {
                id: mask_icon
                width: 64
                height: 64
                visible: false
                radius: userShape
            }

            Kirigami.Icon {
                source: kUser.faceIconUrl // CORREGIDO: kUser con U mayúscula coincidiendo con el ID
                implicitWidth: 64
                implicitHeight: 64
                layer.enabled: true
                layer.effect: OpacityMask { maskSource: mask_icon }
            }
        }

        ColumnLayout {
            id: identityHeader
            spacing: 2
            Layout.fillWidth: true

            PC3.Label {
                text: kUser.fullName || kUser.loginName
                font.bold: true
                font.pointSize: 10
            }

            PC3.Label {
                text: "Perfil: " + (kUser.userId < 1001 ? "Administrador" : "Usuario Estándar")
                opacity: 0.8
                font.pointSize: 8
                elide: Text.ElideRight
                Layout.maximumWidth: 150
            }

            PC3.Label {
                text: fullSystemPanel.osName
                font.pixelSize: 11
                font.bold: true
                color: "#1793d1"
            }

            PC3.Label {
                text: fullSystemPanel.kernelVer
                font.pixelSize: 10
                opacity: 0.8
                elide: Text.ElideRight
                Layout.maximumWidth: 200
            }
        }

        // --- SECCIÓN 2 y 3: RENDIMIENTO (DISCO Y RAM) ---
        ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            Layout.minimumWidth: 180

            // --- ALMACENAMIENTO ---
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    PC3.Label { text: "Disco Duro"; font.bold: true; Layout.fillWidth: true; font.pixelSize: 10; }
                    PC3.Label {
                        // CORREGIDO: Conversión de KB a GB reales dividiendo por (1024 * 1024)
                        text: (diskTotal.value > 0) ? (Math.round(diskUsed.value / 1048576) + " GB / " + Math.round(diskTotal.value / 1048576) + " GB") : "Calculando..."
                        font.pixelSize: 9; opacity: 0.7
                    }
                }

                // Contenedor para asegurar que el texto del % siempre flote por encima de la barra
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 16

                    PC3.ProgressBar {
                        id: barD
                        anchors.fill: parent
                        value: isNaN(diskUsed.value / diskTotal.value) ? 0 : (diskUsed.value / diskTotal.value)
                        background: Rectangle { color: "#3d3d3d"; radius: 4 }
                        contentItem: Item {
                            Rectangle {
                                width: barD.visualPosition * parent.width
                                height: parent.height; radius: 4
                                color: "#3498db"
                            }
                        }
                    }
                    // CORREGIDO: El Label se extrae del ProgressBar y se posiciona en el Item contenedor (Capa superior)
                    PC3.Label {
                        anchors.centerIn: parent
                        text: Math.round(barD.position * 100) + "%"
                        font.bold: true
                        font.pixelSize: 10
                        color: "white"
                        z: 1 // Asegura el orden visual superior
                    }
                }
            }

            // --- RAM ---
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    PC3.Label { text: "Memoria RAM"; font.bold: true; Layout.fillWidth: true; font.pixelSize: 10; }
                    PC3.Label {
                        // Mantenemos la conversión a MB que ya tenías bien estructurada
                        text: (memTotal.value > 0) ? ((memUsed.value / 1024 / 1024).toFixed(1) + " / " + (memTotal.value / 1024 / 1024).toFixed(1) + " GB") : "Calculando..."
                        font.pixelSize: 9; opacity: 0.7
                    }
                }

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 16

                    PC3.ProgressBar {
                        id: barR
                        anchors.fill: parent
                        value: isNaN(memUsed.value / memTotal.value) ? 0 : (memUsed.value / memTotal.value)
                        background: Rectangle { color: "#3d3d3d"; radius: 4 }
                        contentItem: Item {
                            Rectangle {
                                width: barR.visualPosition * parent.width
                                height: parent.height; radius: 4
                                color: "#2ecc71" // Cambiado a verde para diferenciarlo visualmente del disco
                            }
                        }
                    }
                    // CORREGIDO: Label en capa superior para evitar que la barra lo tape
                    PC3.Label {
                        anchors.centerIn: parent
                        text: Math.round(barR.position * 100) + "%"
                        font.bold: true
                        font.pixelSize: 10
                        color: "white"
                        z: 1
                    }
                }
            }
        }
    }
}
