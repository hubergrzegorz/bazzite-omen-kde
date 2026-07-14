from pathlib import Path
import shutil


from logger import AppLogger



try:

    from send2trash import send2trash

    HAS_TRASH = True


except ImportError:

    HAS_TRASH = False





class Cleaner:


    def __init__(self):


        self.home = Path.home()


        self.logger = AppLogger()



        #
        # absolutnie zabronione
        #

        self.forbidden_paths = [

            #
            # maszyny wirtualne
            #

            ".var/app/org.virt_manager.virt-manager",

            ".config/libvirt",

            ".local/share/libvirt",

            "VirtualMachines",

            "virtual-machines",



            #
            # steam gry
            #

            ".local/share/Steam/steamapps",

            ".local/share/Steam/userdata",

            ".local/share/Steam/compatdata",



            #
            # ważne dane użytkownika
            #

            ".ssh",

            ".gnupg",

            ".config",

            ".local/share"

        ]



        #
        # wyjątki:
        # te katalogi mogą być czyszczone
        #

        self.allowed_cache_paths = [

            ".cache",

            ".var/app"

        ]





    def is_safe(self, path):


        path = Path(path)


        full_path = str(

            path.resolve()

        )



        home = str(

            self.home.resolve()

        )



        #
        # musi być w HOME
        #

        if not full_path.startswith(home):

            return False



        #
        # nie wolno usuwać HOME
        #

        if full_path == home:

            return False



        #
        # twarda blokada
        #

        for blocked in self.forbidden_paths:


            if blocked in full_path:


                #
                # wyjątek:
                # cache flatpaków
                #

                if (

                    ".var/app" in full_path

                    and

                    "/cache" in full_path

                    and

                    "org.virt_manager.virt-manager"

                    not in full_path

                ):

                    continue



                return False



        return True





    def is_trash(self, path):


        return (

            ".local/share/Trash"

            in

            str(path)

        )





    def empty_trash(self):


        trash = (

            self.home

            /

            ".local/share/Trash"

        )


        if not trash.exists():

            return



        for item in trash.iterdir():


            try:


                if item.is_dir():

                    shutil.rmtree(

                        item

                    )


                else:

                    item.unlink()



            except Exception as e:


                self.logger.error(

                    f"Trash error {item}: {e}"

                )





    def remove_path(
        self,
        path,
        dry_run=False
    ):


        path = Path(path)



        if not self.is_safe(path):


            self.logger.warning(

                f"BLOCKED: {path}"

            )


            return {


                "success": False,

                "path": str(path),

                "message":

                "Blocked by safety rules"

            }





        #
        # symulacja
        #

        if dry_run:


            self.logger.info(

                f"DRY RUN: {path}"

            )


            return {


                "success": True,

                "path": str(path),

                "message":

                "Simulation only"

            }





        try:



            #
            # specjalny przypadek kosza
            #

            if self.is_trash(path):


                self.empty_trash()



                self.logger.info(

                    "Trash emptied"

                )



                return {


                    "success": True,

                    "path": str(path),

                    "message":

                    "Trash emptied"

                }





            #
            # normalne usuwanie
            #

            if HAS_TRASH:



                send2trash(

                    str(path)

                )


                action = (

                    "Moved to trash"

                )



            else:



                if path.is_dir():

                    shutil.rmtree(

                        path

                    )

                else:

                    path.unlink()



                action = (

                    "Deleted"

                )





            self.logger.info(

                f"{action}: {path}"

            )



            return {


                "success": True,

                "path": str(path),

                "message":

                action

            }





        except Exception as e:


            self.logger.error(

                f"Remove error {path}: {e}"

            )


            return {


                "success": False,

                "path": str(path),

                "message":

                str(e)

            }





    def remove_after_backup(
        self,
        paths,
        dry_run=False
    ):


        results = []



        for path in paths:


            results.append(


                self.remove_path(

                    path,

                    dry_run

                )

            )



        return results
