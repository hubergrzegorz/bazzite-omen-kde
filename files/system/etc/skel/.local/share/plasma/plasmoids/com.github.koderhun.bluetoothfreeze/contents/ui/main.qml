import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3
import org.kde.draganddrop as DND
import org.kde.kirigami as Kirigami
import org.kde.activities as Activities
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
  id: root
  width: Kirigami.Units.iconSizes.large
  height: Kirigami.Units.iconSizes.large

  Layout.maximumWidth: Infinity
  Layout.maximumHeight: Infinity
  Layout.preferredWidth: icon.width + Kirigami.Units.smallSpacing +
      (root.showActivityName ? name.implicitWidth + Kirigami.Units.smallSpacing : 0)
  Layout.minimumWidth: 0
  Layout.minimumHeight: 0

  readonly property bool inVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
  readonly property string baseUrl: Qt.resolvedUrl(".")
  readonly property string uiPath: {
    return baseUrl.replace(/^file:\/\//, '');
  }
  readonly property string minutes: Plasmoid.configuration.minutes;
  property bool toggleStatus: false


  // true = dark theme,
  // false = light theme
  readonly property bool isDarkTheme: Kirigami.Theme.backgroundColor.hslLightness < 0.5

  property string playIcon: isDarkTheme ? uiPath + "freeze-off-light.svg" :  uiPath + "freeze-off-dark.svg"
  property string stopIcon: isDarkTheme ? uiPath + "freeze-on-light.svg" : uiPath + "freeze-on-dark.svg"

  Component.onCompleted: {
    executable.execStart();
  }

  DND.DropArea {
    id: dropArea
    anchors.fill: parent

    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (!root.toggleStatus) {
          executable.execStart();
        } else {
          executable.execStop();
        }
      }
    }

    PlasmaCore.ToolTipArea {
      id: tooltip
      anchors.fill: parent
      mainText: root.toggleStatus ? i18n("Click to pause running bluetooth freezing") : i18n("Click to start bluetooth freezing")
      subText: root.toggleStatus ? i18n("Currently running") : i18n("Currently stopped")
    }

    Kirigami.Icon {
      id: icon
      height: Math.min(parent.height, parent.width)
      width: valid ? height : 0
      source: root.toggleStatus ? stopIcon : playIcon
    }
  }

  Plasma5Support.DataSource {
    id: executable
    engine: "executable"
    connectedSources: []

    readonly property string scriptPath: {
      let path = baseUrl.replace(/^file:\/\//, '');
      return path.replace("contents/ui/", "contents/code/sounding.sh");
    }

    function execStart() {
      const command = "bash " + scriptPath + " " + minutes;
      console.log("Executing start command: " + command);
      executable.connectSource(command);
      root.toggleStatus = true;
    }

    function execStop() {
      const command = "pkill -f " + scriptPath;
      console.log("Executing stop command: " + command);
      executable.connectSource(command);
      root.toggleStatus = false;
    }

    onNewData: function(source, data) {
      disconnectSource(source);
    }
  }
}
