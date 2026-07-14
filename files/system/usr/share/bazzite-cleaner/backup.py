from pathlib import Path
import tarfile
import json
import tempfile
from datetime import datetime
import os


class BackupManager:
    """
    Zarządzanie backupami przed czyszczeniem.

    Obsługuje:
    - tar.gz
    - poziom kompresji
    - raportowanie postępu
    - manifest
    - weryfikację archiwum
    """


    def __init__(self):

        self.home = Path.home()

        self.backup_dir = (
            self.home /
            ".Bazzite-Cleaner-Backups"
        )

        self.backup_dir.mkdir(
            exist_ok=True
        )



    def create_backup_name(self):

        timestamp = datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S"
        )

        return (
            self.backup_dir /
            f"backup_cache_{timestamp}.tar.gz"
        )



    def create_manifest(
        self,
        paths
    ):

        files = []


        for path in paths:

            path = Path(path)


            try:

                relative = (
                    path.relative_to(
                        self.home
                    )
                )


            except ValueError:

                relative = path.name



            files.append(
                {
                    "original": str(path),
                    "backup": str(relative)
                }
            )



        return {

            "created":
                datetime.now()
                .strftime(
                    "%Y-%m-%d %H:%M:%S"
                ),

            "system":
                "Bazzite",

            "files":
                files

        }



    def write_manifest(
        self,
        directory,
        manifest
    ):

        manifest_file = (
            directory /
            "manifest.json"
        )


        with open(
            manifest_file,
            "w",
            encoding="utf-8"
        ) as file:

            json.dump(
                manifest,
                file,
                indent=4,
                ensure_ascii=False
            )


        return manifest_file



    def count_files(
        self,
        paths
    ):

        """
        Liczy pliki dla paska postępu.
        """

        total = 0


        for path in paths:

            path = Path(path)


            if not path.exists():

                continue


            if path.is_file():

                total += 1


            else:

                for _, _, files in os.walk(path):

                    total += len(files)


        return max(
            total,
            1
        )



    def compression_settings(
        self,
        compression
    ):

        """
        Ustawienia gzip.

        tarfile używa:
        w:gz
        w:gz (default)
        """

        if compression == "fast":

            return 1


        if compression == "maximum":

            return 9


        return 6



    def create_backup(
        self,
        paths,
        compression="normal",
        progress_callback=None
    ):

        """
        Tworzy backup.

        progress_callback:

        callback(procent, komunikat)

        """

        backup_file = (
            self.create_backup_name()
        )


        paths = [
            Path(p)
            for p in paths
        ]


        def update(
            percent,
            message
        ):

            if progress_callback:

                progress_callback(
                    percent,
                    message
                )



        try:

            update(
                5,
                "Przygotowanie..."
            )


            total_files = (
                self.count_files(
                    paths
                )
            )


            processed = 0



            with tempfile.TemporaryDirectory() as tmp:


                tmp_path = Path(tmp)



                manifest = (
                    self.create_manifest(
                        paths
                    )
                )


                manifest_file = (
                    self.write_manifest(
                        tmp_path,
                        manifest
                    )
                )



                level = (
                    self.compression_settings(
                        compression
                    )
                )



                with tarfile.open(

                    backup_file,

                    mode="w:gz",

                    compresslevel=level

                ) as archive:



                    archive.add(

                        manifest_file,

                        arcname="manifest.json"

                    )



                    for path in paths:


                        if not path.exists():

                            continue



                        update(

                            10,

                            f"Kopiowanie: {path}"

                        )



                        if path.is_file():


                            archive.add(

                                path,

                                arcname=str(

                                    path.relative_to(
                                        self.home
                                    )

                                )

                            )


                            processed += 1



                        else:


                            for root, dirs, files in os.walk(path):


                                root_path = Path(
                                    root
                                )


                                for file in files:


                                    file_path = (
                                        root_path /
                                        file
                                    )


                                    archive.add(

                                        file_path,

                                        arcname=str(

                                            file_path.relative_to(
                                                self.home
                                            )

                                        )

                                    )


                                    processed += 1



                                    percent = int(

                                        10 +

                                        (
                                            processed /
                                            total_files
                                        )
                                        *
                                        80

                                    )


                                    update(

                                        min(
                                            percent,
                                            90
                                        ),

                                        f"Kopiowanie: {file}"

                                    )



            update(
                95,
                "Sprawdzanie archiwum..."
            )



            if self.verify_backup(
                backup_file
            ):


                update(
                    100,
                    "Backup gotowy"
                )


                return {

                    "success":
                        True,

                    "path":
                        str(
                            backup_file
                        ),

                    "message":
                        "Backup utworzony poprawnie"

                }



            else:


                backup_file.unlink(
                    missing_ok=True
                )


                return {

                    "success":
                        False,

                    "path":
                        str(
                            backup_file
                        ),

                    "message":
                        "Backup uszkodzony"

                }



        except Exception as e:


            if backup_file.exists():

                backup_file.unlink(
                    missing_ok=True
                )


            return {

                "success":
                    False,

                "path":
                    str(
                        backup_file
                    ),

                "message":
                    str(e)

            }



    def verify_backup(
        self,
        backup_file
    ):

        try:

            with tarfile.open(
                backup_file,
                "r:gz"
            ) as archive:

                archive.getmembers()


            return True


        except Exception:

            return False



    def list_backups(self):

        return sorted(

            self.backup_dir.glob(
                "backup_cache_*.tar.gz"
            ),

            reverse=True

        )
