import QtQuick
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami
import org.kde.coreaddons 1.0 as KCoreAddons

Item {
    id: root

    KCoreAddons.KUser {
        id: kuser
    }

    property int avatarSize: height *0.7

    function capitalizeFirstLetter(string) {
        if (!string || string.length === 0)
            return "";
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    property string name: capitalizeFirstLetter(kuser.fullName)
    property url urlAvatar: kuser.faceIconUrl

    Column {
        anchors.centerIn: parent
        spacing: 16

        // Tamaño fijo del avatar

        Item {
            width: avatarSize
            height: avatarSize
            Rectangle {
                width: parent.width
                height: parent.height
                color: Kirigami.Theme.textColor
                anchors.centerIn: parent
                radius: width / 2
            }
            Rectangle {
                id: mask
                width: parent.width - 2
                height: parent.height -2
                anchors.centerIn: parent
                radius: width / 2
                visible: false
            }

            Image {
                width: parent.width - 2
                height: parent.height -2
                source: urlAvatar
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectCrop
                smooth: true

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
            }
        }


        Kirigami.Heading {
            id: nameUser
            level: 3
            width: avatarSize
            horizontalAlignment: Text.AlignHCenter
            text: name
            font.bold: true
            elide: Text.ElideRight
        }

    }
}
