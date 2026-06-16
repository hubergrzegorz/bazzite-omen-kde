import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.ksvg 1.0 as KSvg

Item {

    ToolsButtons {
        id: buttons
        width: 66 + (Kirigami.Units.smallSpacing*2)
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (parent.height - 8)/2 + 22
    }
    FaceUser {
        id: faceuser
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height - 8
    }

    KSvg.FrameSvgItem {
        id: backgroundSvg
        imagePath: "widgets/plasmoidheading"
        prefix: "header"  // Cambiar según ubicación

        anchors {
            fill: parent
            // El mismo truco de márgenes negativos, pero con KSvg
            leftMargin: -backgroundSvg.margins.left
            rightMargin: -backgroundSvg.margins.right
        }

        Item {
            id: contentItem
            anchors {
                fill: parent
                margins: backgroundSvg.margins
            }
        }
    }
}
