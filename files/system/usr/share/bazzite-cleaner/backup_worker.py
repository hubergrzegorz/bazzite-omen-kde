from PySide6.QtCore import (
    QThread,
    Signal
)

from backup import BackupManager



class BackupWorker(QThread):
    """
    Wykonuje backup w osobnym wątku,
    aby GUI się nie zawieszało.
    """


    progress = Signal(int)

    status = Signal(str)

    finished = Signal(dict)



    def __init__(
        self,
        paths,
        compression="normal"
    ):

        super().__init__()

        self.paths = paths

        self.compression = compression



    def run(self):

        try:

            manager = BackupManager()



            self.status.emit(
                "Przygotowanie backupu..."
            )


            self.progress.emit(
                5
            )



            result = manager.create_backup(

                self.paths,

                compression=self.compression,

                progress_callback=self.update_progress

            )



            self.progress.emit(
                100
            )


            self.finished.emit(
                result
            )



        except Exception as e:


            self.finished.emit(

                {

                    "success": False,

                    "message": str(e),

                    "path": ""

                }

            )



    def update_progress(
        self,
        value,
        message
    ):


        self.progress.emit(
            value
        )


        self.status.emit(
            message
        )
