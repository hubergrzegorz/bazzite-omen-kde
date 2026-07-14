from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QPushButton,
    QListWidget,
    QListWidgetItem,
    QMessageBox
)

from restore import RestoreManager
from utils import human_size



class BackupWindow(QWidget):

    def __init__(self):

        super().__init__()

        self.restore_manager = (
            RestoreManager()
        )

        self.backups = []

        self.setup_ui()

        self.load_backups()



    def setup_ui(self):

        self.setWindowTitle(
            ".Bazzite Cleaner - Backupy"
        )


        self.resize(
            700,
            450
        )


        layout = QVBoxLayout()


        title = QLabel(
            "<h2>Backupy cache</h2>"
        )


        layout.addWidget(
            title
        )



        self.list_widget = QListWidget()


        layout.addWidget(
            self.list_widget
        )



        buttons = QHBoxLayout()



        self.restore_button = QPushButton(
            "Przywróć"
        )


        self.restore_button.clicked.connect(
            self.restore
        )


        buttons.addWidget(
            self.restore_button
        )



        self.delete_button = QPushButton(
            "Usuń backup"
        )


        self.delete_button.clicked.connect(
            self.delete_backup
        )


        buttons.addWidget(
            self.delete_button
        )



        self.refresh_button = QPushButton(
            "Odśwież"
        )


        self.refresh_button.clicked.connect(
            self.load_backups
        )


        buttons.addWidget(
            self.refresh_button
        )



        layout.addLayout(
            buttons
        )


        self.setLayout(
            layout
        )



    def load_backups(self):

        self.list_widget.clear()


        self.backups = (
            self.restore_manager
            .list_backups()
        )


        for backup in self.backups:


            size = backup.stat().st_size


            item = QListWidgetItem(

                f"{backup.name}\n"
                f"Rozmiar: {human_size(size)}"

            )


            self.list_widget.addItem(
                item
            )



    def selected_backup(self):

        index = (
            self.list_widget.currentRow()
        )


        if index < 0:

            return None


        return self.backups[index]



    def restore(self):

        backup = (
            self.selected_backup()
        )


        if backup is None:


            QMessageBox.warning(
                self,
                "Brak wyboru",
                "Wybierz backup."
            )

            return



        answer = QMessageBox.question(

            self,

            "Przywracanie",

            (
                "Czy przywrócić wybrany backup?\n\n"
                f"{backup.name}\n\n"
                "Istniejące pliki NIE zostaną nadpisane."
            )

        )


        if answer != QMessageBox.Yes:

            return



        result = (
            self.restore_manager
            .restore_backup(
                backup
            )
        )



        if result["success"]:


            QMessageBox.information(

                self,

                "Gotowe",

                result["message"]

            )


        else:


            QMessageBox.warning(

                self,

                "Błąd",

                result["message"]

            )



        self.load_backups()



    def delete_backup(self):

        backup = (
            self.selected_backup()
        )


        if backup is None:


            QMessageBox.warning(
                self,
                "Brak wyboru",
                "Wybierz backup."
            )

            return



        answer = QMessageBox.question(

            self,

            "Usuwanie",

            (
                "Usunąć backup?\n\n"
                f"{backup.name}\n\n"
                "Tej operacji nie można cofnąć."
            )

        )


        if answer != QMessageBox.Yes:

            return



        try:

            backup.unlink()


            QMessageBox.information(

                self,

                "Usunięto",

                "Backup został usunięty."

            )


        except Exception as e:


            QMessageBox.warning(

                self,

                "Błąd",

                str(e)

            )



        self.load_backups()
