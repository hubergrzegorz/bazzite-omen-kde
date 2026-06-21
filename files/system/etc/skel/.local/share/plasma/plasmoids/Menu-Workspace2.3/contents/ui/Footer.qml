
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

RowLayout
{
    id:footerComponent
    //width: (rootItem.resizeWidth()  == 0 ? rootItem.calc_width : rootItem.resizeWidth())
    width: rootItem.space_width

    Sessions.SessionManagement
    {
        id: cmd_desk
    }
    //cmd commands
    P5Support.DataSource
    {   id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    RowLayout
    {
    Layout.alignment: Qt.AlignHcenter | Qt.AlignBottom
    Item { Layout.fillWidth: true}
            PC3.ToolButton
            {
                icon.name:   "system-shutdown"
                onClicked: cmd_desk.requestShutdown()
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Leave ...")
                visible: true !== "" && Plasmoid.configuration.shutDownEnabled
            }
            PC3.ToolButton
            {
                icon.name:   "system-reboot"
                visible:  true !== "" && Plasmoid.configuration.rebootEnabled
                onClicked: cmd_desk.requestReboot() //executable.exec(restartCMD)
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Reboot ...")
            }

            PC3.ToolButton
            {
                icon.name:  "system-log-out"
                visible:  true !== "" && Plasmoid.configuration.logOutEnabled
                onClicked: cmd_desk.requestLogout()//executable.exec(logOutCMD);
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Log Out")
            }

            PC3.ToolButton
            {
                icon.name: "system-suspend"
                visible: true !== "" && Plasmoid.configuration.sleepEnabled // Asegúrate de tener la configuración para habilitar la hibernación
                onClicked: cmd_desk.suspend() // Comando para hibernar el sistema
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Hibernate")
            }
            PC3.ToolButton
            {
                icon.name:  "system-lock-screen"
                visible:  true !== "" && Plasmoid.configuration.lockScreenEnabled
                onClicked: cmd_desk.lock()
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Lock Screen")
            }

            PC3.ToolButton
            {
                icon.name:  "user-home"
                visible:  true !== "" && Plasmoid.configuration.homeEnabled
                onClicked: executable.exec(homeCMD);
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("User Home")
            }
            PC3.ToolButton
            {
                icon.name: "system-software-install" // Ícono asociado con Plasma Discover
                visible: true !== "" && Plasmoid.configuration.appStoreEnabled
                onClicked: executable.exec(appStoreCMD) // Comando para abrir Plasma Discover
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Open Plasma Discover")
            }
            PC3.ToolButton
            {
                icon.name:  "configure"
                visible:  true !== "" && Plasmoid.configuration.systemPreferencesEnabled
                onClicked: executable.exec(systemPreferencesCMD);
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("System Preferences")
            }


            Kirigami.Separator {
                // Se mostrará SÓLO cuando el botón de configuración también sea visible
                visible: !Plasmoid.configuration.showInfoUser

                // Le decimos al RowLayout cómo debe comportarse el separador
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                color: Kirigami.Theme.textColor
                opacity:0.3
                // Márgenes opcionales para que no pegue a los iconos
                Layout.leftMargin: 6
                Layout.rightMargin: 6
                Layout.topMargin:6
                Layout.bottomMargin:6
            }
            PC3.ToolButton
            {
                icon.name:  "settings"
                visible:  !Plasmoid.configuration.showInfoUser
                onClicked: plasmoid.internalAction("configure").trigger()
                ToolTip.delay: 200
                ToolTip.timeout: 1000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Settings WorkSpace Menu")
            }
            PC3.ToolButton
            {
                id: pinButton
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                visible:  !Plasmoid.configuration.showInfoUser
                checkable: true
                checked: Plasmoid.configuration.pin
                icon.name: "window-pin"
                text: i18n("Keep Open")
                display: PC3.ToolButton.IconOnly
                PC3.ToolTip.text: text
                PC3.ToolTip.delay: Kirigami.Units.toolTipDelay
                PC3.ToolTip.visible: hovered
                Binding {
                    target: kicker
                    property: "hideOnWindowDeactivate"
                    value: !Plasmoid.configuration.pin
                    // there should be no other bindings, so don't waste resources
                }
                onToggled: Plasmoid.configuration.pin = checked
            }

       Item { Layout.fillWidth: true }
       }
    }

