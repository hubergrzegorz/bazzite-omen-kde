
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.plasma5support as Plasma5Support

KCM.SimpleKCM {

  property int cfg_minutes: minutes.value
  property int cfg_minutesDefault: 10 // Установите свое значение по умолчанию здесь

  Kirigami.FormLayout {
    SpinBox {
      id: minutes
      Kirigami.FormData.label: i18nc("@label:textbox", "Minuts Bluetooth Freezing:")
      value: Plasmoid.configuration.minutes
      from: 1
      to: 60 // max
      stepSize: 1
      onValueChanged: {
        cfg_minutes = minutes.value
      }
    }
  }
}
