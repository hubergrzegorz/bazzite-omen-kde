from PySide6.QtCore import Qt, QUrl
from pathlib import Path


from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QPushButton,
    QMessageBox,
    QProgressBar,
    QCheckBox,
    QRadioButton,
    QButtonGroup,
    QTreeWidget,
    QTreeWidgetItem
)


from PySide6.QtCore import QUrl
from PySide6.QtGui import QDesktopServices


from scanner import Scanner
from cleaner import Cleaner

from utils import human_size

from backup_worker import BackupWorker
from backup_window import BackupWindow
from simulation_window import SimulationWindow




class MainWindow(QWidget):


    def __init__(self):

        super().__init__()


        self.scanner = Scanner()

        self.cleaner = Cleaner()


        self.backup_worker = None


        self.backup_window = None


        self.simulation_window = None


        self.pending_paths = []


        self.items = []



        self.setup_ui()



    def setup_ui(self):

        self.setWindowTitle(
            "Bazzite Cleaner"
        )


        self.resize(
            950,
            700
        )


        layout = QVBoxLayout()



        layout.addWidget(

            QLabel(
                "<h2>Bazzite Cleaner</h2>"
            )

        )



        self.tree = QTreeWidget()


        self.tree.setHeaderLabels(

            [

                "Element",

                "Rozmiar"

            ]

        )


        self.tree.itemChanged.connect(

            self.update_total

        )


        layout.addWidget(
            self.tree
        )



        self.total_label = QLabel(

            "Wybrane: 0 B"

        )


        layout.addWidget(

            self.total_label

        )



        self.progress = QProgressBar()


        layout.addWidget(

            self.progress

        )



        self.status = QLabel(
            ""
        )


        layout.addWidget(
            self.status
        )



        #
        # tryb testowy
        #

        self.dry_run = QCheckBox(

            "Tryb symulacji (nic nie usuwa)"

        )


        layout.addWidget(
            self.dry_run
        )



        #
        # kompresja
        #

        layout.addWidget(

            QLabel(

                "Kompresja backupu:"

            )

        )


        self.fast = QRadioButton(
            "Szybka"
        )


        self.normal = QRadioButton(
            "Normalna"
        )


        self.maximum = QRadioButton(
            "Maksymalna"
        )


        self.normal.setChecked(
            True
        )


        group = QButtonGroup(
            self
        )


        group.addButton(
            self.fast
        )

        group.addButton(
            self.normal
        )

        group.addButton(
            self.maximum
        )


        layout.addWidget(
            self.fast
        )


        layout.addWidget(
            self.normal
        )


        layout.addWidget(
            self.maximum
        )



        #
        # wybór
        #

        row = QHBoxLayout()



        self.select_all_button = QPushButton(

            "Zaznacz wszystko"

        )


        self.select_all_button.clicked.connect(

            self.select_all

        )


        self.select_all_button.setEnabled(
            False
        )


        row.addWidget(

            self.select_all_button

        )



        self.deselect_button = QPushButton(

            "Odznacz wszystko"

        )


        self.deselect_button.clicked.connect(

            self.deselect_all

        )


        self.deselect_button.setEnabled(
            False
        )


        row.addWidget(

            self.deselect_button

        )



        layout.addLayout(
            row
        )



        #
        # akcje
        #

        row2 = QHBoxLayout()



        self.scan_button = QPushButton(

            "Analizuj"

        )


        self.scan_button.clicked.connect(

            self.scan

        )


        row2.addWidget(

            self.scan_button

        )



        self.clean_button = QPushButton(

            "Backup i czyszczenie"

        )


        self.clean_button.clicked.connect(

            self.clean

        )


        self.clean_button.setEnabled(
            False
        )


        row2.addWidget(

            self.clean_button

        )



        self.backup_button = QPushButton(

            "Backupy"

        )


        self.backup_button.clicked.connect(

            self.show_backups

        )


        row2.addWidget(

            self.backup_button

        )



        self.log_button = QPushButton(

            "Log"

        )


        self.log_button.clicked.connect(

            self.open_log

        )


        row2.addWidget(

            self.log_button

        )


        layout.addLayout(
            row2
        )


        self.setLayout(
            layout
        )



    def scan(self):


        self.tree.clear()


        self.items.clear()



        scanner = Scanner()


        results = scanner.scan()



        categories = {

            "CACHE": [],

            "FLATPAK CACHE": [],

            "TRASH": [],

            "OTHER": []

        }



        for item in results:


            category = scanner.category(

                item["path"]

            )


            categories[category].append(

                item

            )



        for name, elements in categories.items():


            if not elements:

                continue



            parent = QTreeWidgetItem(

                [

                    name,

                    ""

                ]

            )


            parent.setFlags(

                parent.flags()

                |

                Qt.ItemIsUserCheckable

            )


            parent.setCheckState(

                0,

                Qt.Unchecked

            )


            self.tree.addTopLevelItem(

                parent

            )



            for element in elements:


                child = QTreeWidgetItem(

                    [

                        element["name"],

                        human_size(
                            element["size"]
                        )

                    ]

                )


                child.setFlags(

                    child.flags()

                    |

                    Qt.ItemIsUserCheckable

                )


                child.setCheckState(

                    0,

                    Qt.Unchecked

                )


                child.setData(

                    0,

                    Qt.UserRole,

                    str(
                        element["path"]
                    )

                )


                child.setData(

                    0,

                    Qt.UserRole + 1,

                    int(
                        element["size"]
                    )

                )


                parent.addChild(

                    child

                )


                self.items.append(

                    child

                )



        self.tree.expandAll()



        enabled = len(

            self.items

        ) > 0



        self.select_all_button.setEnabled(

            enabled

        )


        self.deselect_button.setEnabled(

            enabled

        )


        self.clean_button.setEnabled(

            enabled

        )



    def select_all(self):


        for item in self.items:

            item.setCheckState(

                0,

                Qt.Checked

            )



    def deselect_all(self):


        for item in self.items:

            item.setCheckState(

                0,

                Qt.Unchecked

            )



    def update_total(self):


        total = 0



        for item in self.items:


            if item.checkState(0) == Qt.Checked:


                total += int(

                    item.data(

                        0,

                        Qt.UserRole + 1

                    )

                )



        self.total_label.setText(

            f"Wybrane: {human_size(total)}"

        )



    def selected_paths(self):


        result = []



        for item in self.items:


            if item.checkState(0) == Qt.Checked:


                result.append(

                    item.data(

                        0,

                        Qt.UserRole

                    )

                )


        return result



    def selected_compression(self):


        if self.fast.isChecked():

            return "fast"



        if self.maximum.isChecked():

            return "maximum"



        return "normal"



    def clean(self):


        paths = self.selected_paths()



        if not paths:

            return



        self.pending_paths = paths



        if self.dry_run.isChecked():


            result = self.cleaner.remove_after_backup(

                paths,

                dry_run=True

            )


            total = 0



            for item in self.items:


                if item.checkState(0) == Qt.Checked:


                    total += int(

                        item.data(

                            0,

                            Qt.UserRole + 1

                        )

                    )



            self.simulation_window = SimulationWindow(

                result,

                human_size(total)

            )


            self.simulation_window.show()


            return



        self.start_backup()



    def start_backup(self):


        self.clean_button.setEnabled(

            False

        )


        self.backup_worker = BackupWorker(

            self.pending_paths,

            self.selected_compression()

        )


        self.backup_worker.progress.connect(

            self.progress.setValue

        )


        self.backup_worker.status.connect(

            self.status.setText

        )


        self.backup_worker.finished.connect(

            self.backup_finished

        )


        self.backup_worker.start()



    def backup_finished(self,result):


        if result["success"]:


            self.cleaner.remove_after_backup(

                self.pending_paths

            )


            QMessageBox.information(

                self,

                "Gotowe",

                "Backup wykonany i dane usunięte."

            )


            self.scan()


        else:


            QMessageBox.warning(

                self,

                "Błąd",

                result["message"]

            )



        self.clean_button.setEnabled(

            True

        )



    def show_backups(self):


        if self.backup_window is None:

            self.backup_window = BackupWindow()


        self.backup_window.show()



    def open_log(self):


        path = (

            Path.home()

            /

            ".Bazzite-Cleaner-Backups"

            /

            "cleaner.log"

        )


        if path.exists():

            QDesktopServices.openUrl(

                QUrl.fromLocalFile(

                    str(path)

                )

            )
