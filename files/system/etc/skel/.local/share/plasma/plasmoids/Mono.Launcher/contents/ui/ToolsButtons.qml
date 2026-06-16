import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.sessions as Sessions
import org.kde.plasma.plasma5support 2.0 as P5Support

Item {
    id: root

    Sessions.SessionManagement {
        id: sm
    }

    property string toogleListApps: view-list-icons
    P5Support.DataSource {
        id: executable
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

    Row {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            width: 22
            height: width
            source: "system-shutdown"

            MouseArea {
                anchors.fill: parent
                onClicked: sm.requestLogoutPrompt()
            }
        }
        Kirigami.Icon {
            width: 22
            height: width
            source: "configure"

            MouseArea {
                anchors.fill: parent
                onClicked: executable.exec("systemsettings")
            }
        }
        Kirigami.Icon {
            width: 22
            height: width
            source: activeFullListApps ? "view-list-icons" : "favorites"

            MouseArea {
                anchors.fill: parent
                onClicked: activeFullListApps = !activeFullListApps
            }
        }
    }
}
