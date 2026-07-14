from pathlib import Path
import tarfile
import json
import shutil
import tempfile


class RestoreManager:
    """
    Obsługa przywracania backupów.

    Backupy znajdują się w:

    ~/Bazzite-Cleaner-Backups/

    """



    def __init__(self):

        self.home = Path.home()

        self.backup_dir = (
            self.home /
            ".Bazzite-Cleaner-Backups"
        )



    def list_backups(self):

        """
        Zwraca listę dostępnych backupów.
        """

        if not self.backup_dir.exists():

            return []


        return sorted(
            self.backup_dir.glob(
                "backup_cache_*.tar.gz"
            ),
            reverse=True
        )



    def verify_backup(
        self,
        backup_file
    ):

        """
        Sprawdza czy archiwum jest poprawne.
        """

        try:

            with tarfile.open(
                backup_file,
                "r:gz"
            ) as archive:

                archive.getmembers()


            return True


        except Exception:

            return False



    def read_manifest(
        self,
        backup_file
    ):

        """
        Odczytuje listę oryginalnych ścieżek.
        """

        try:

            with tarfile.open(
                backup_file,
                "r:gz"
            ) as archive:


                manifest = (
                    archive.extractfile(
                        "manifest.json"
                    )
                )


                if manifest is None:

                    return None



                return json.loads(
                    manifest.read()
                    .decode("utf-8")
                )



        except Exception:

            return None



    def restore_backup(
        self,
        backup_file
    ):

        """
        Przywraca cały backup.

        Zabezpieczenia:

        - tylko katalog domowy,
        - brak nadpisywania bez zgody,
        - sprawdzanie manifestu.
        """


        backup_file = Path(
            backup_file
        )


        if not backup_file.exists():

            return {

                "success": False,

                "message":
                "Backup nie istnieje"

            }



        if not self.verify_backup(
            backup_file
        ):

            return {

                "success": False,

                "message":
                "Uszkodzone archiwum"

            }



        manifest = (
            self.read_manifest(
                backup_file
            )
        )


        if not manifest:


            return {

                "success": False,

                "message":
                "Brak manifestu"

            }



        restored = []



        try:


            with tempfile.TemporaryDirectory() as tmp:


                tmp_path = Path(tmp)



                with tarfile.open(
                    backup_file,
                    "r:gz"
                ) as archive:


                    archive.extractall(
                        tmp_path
                    )



                for item in manifest["files"]:


                    original = Path(
                        item["original"]
                    )


                    relative = Path(
                        item["backup"]
                    )


                    source = (
                        tmp_path /
                        relative
                    )



                    if not source.exists():

                        continue



                    #
                    # zabezpieczenie
                    #

                    if not str(
                        original
                    ).startswith(
                        str(self.home)
                    ):

                        continue



                    if original.exists():

                        # nie nadpisujemy automatycznie
                        continue



                    original.parent.mkdir(
                        parents=True,
                        exist_ok=True
                    )



                    shutil.move(
                        source,
                        original
                    )


                    restored.append(
                        str(original)
                    )



            return {

                "success": True,

                "restored":
                restored,

                "message":
                (
                    f"Przywrócono "
                    f"{len(restored)} elementów"
                )

            }



        except Exception as e:


            return {

                "success": False,

                "message": str(e)

            }
