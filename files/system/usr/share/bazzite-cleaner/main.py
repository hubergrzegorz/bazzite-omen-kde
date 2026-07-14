import sys
import traceback

from PySide6.QtWidgets import (
    QApplication,
    QMessageBox
)

from PySide6.QtGui import QIcon

from gui import MainWindow


APP_NAME = "Bazzite Cleaner"


def exception_handler(exc_type, exc_value, exc_traceback):
    """
    Globalna obsługa błędów.
    Zamiast cichego zamknięcia pokazuje komunikat.
    """

    error = "".join(
        traceback.format_exception(
            exc_type,
            exc_value,
            exc_traceback
        )
    )


    QMessageBox.critical(
        None,
        "Błąd aplikacji",
        error
    )



def main():

    sys.excepthook = exception_handler


    app = QApplication(
        sys.argv
    )


    app.setApplicationName(
        APP_NAME
    )


    app.setOrganizationName(
        "Bazzite Cleaner Project"
    )


    # Przyjazny wygląd Qt
    app.setStyle(
        "Fusion"
    )


    window = MainWindow()


    window.show()


    sys.exit(
        app.exec()
    )



if __name__ == "__main__":

    main()
