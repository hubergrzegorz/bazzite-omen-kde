from PySide6.QtWidgets import (
    QDialog,
    QVBoxLayout,
    QLabel,
    QListWidget,
    QPushButton
)



class SimulationWindow(QDialog):

    def __init__(
        self,
        results,
        total_size
    ):

        super().__init__()


        self.setWindowTitle(
            "Wynik symulacji"
        )


        self.resize(
            700,
            500
        )


        layout = QVBoxLayout()



        success_count = len(
            [
                x for x in results
                if x["success"]
            ]
        )


        layout.addWidget(

            QLabel(

                f"<b>Symulacja zakończona</b><br><br>"
                f"Elementy: {success_count}<br>"
                f"Możliwe odzyskanie: {total_size}<br><br>"
                f"Nic nie zostało usunięte."

            )

        )



        self.list_widget = QListWidget()


        layout.addWidget(
            self.list_widget
        )



        for item in results:


            self.list_widget.addItem(

                item["path"]

            )



        button = QPushButton(
            "Zamknij"
        )


        button.clicked.connect(
            self.close
        )


        layout.addWidget(
            button
        )


        self.setLayout(
            layout
        )
