from pathlib import Path
from datetime import datetime



class AppLogger:


    def __init__(self):

        self.log_dir = (

            Path.home()

            /

            ".Bazzite-Cleaner-Backups"

        )


        self.log_dir.mkdir(

            parents=True,

            exist_ok=True

        )


        self.log_file = (

            self.log_dir

            /

            "cleaner.log"

        )



    def write(
        self,
        level,
        message
    ):


        timestamp = datetime.now().strftime(

            "%Y-%m-%d %H:%M:%S"

        )


        line = (

            f"[{timestamp}] "

            f"{level}: "

            f"{message}"

        )


        with open(

            self.log_file,

            "a",

            encoding="utf-8"

        ) as file:


            file.write(

                line + "\n"

            )



    def info(
        self,
        message
    ):


        self.write(

            "INFO",

            message

        )



    def warning(
        self,
        message
    ):


        self.write(

            "WARNING",

            message

        )



    def error(
        self,
        message
    ):


        self.write(

            "ERROR",

            message

        )
