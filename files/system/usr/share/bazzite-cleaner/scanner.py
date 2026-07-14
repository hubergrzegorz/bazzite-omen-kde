from pathlib import Path
import os



class Scanner:


    def __init__(self):

        self.home = Path.home()



        self.categories = {

            "CACHE": [],

            "FLATPAK CACHE": [],

            "TRASH": [],

            "OTHER": []

        }



        self.blocked = [

            #
            # system
            #

            ".config",

            ".local/share",

            ".ssh",

            ".gnupg",



            #
            # steam / gry
            #

            "steamapps",

            "userdata",

            "compatdata",



            #
            # VM
            #

            ".var/app/org.virt_manager.virt-manager",

            "VirtualMachines",

            "virtual-machines"

        ]



    def is_blocked(
        self,
        path
    ):

        path = str(path)



        for item in self.blocked:


            if item in path:

                return True



        return False



    def get_size(
        self,
        path
    ):

        total = 0


        try:


            if path.is_file():

                return path.stat().st_size



            for root, dirs, files in os.walk(
                path,
                followlinks=False
            ):


                for file in files:


                    try:


                        total += (

                            Path(root)
                            /
                            file

                        ).stat().st_size


                    except Exception:

                        pass



        except Exception:

            pass



        return total



    def category(
        self,
        path
    ):


        text = str(path)



        if ".local/share/Trash" in text:

            return "TRASH"



        if ".var/app" in text:

            return "FLATPAK CACHE"



        if ".cache" in text:

            return "CACHE"



        return "OTHER"



    def scan_directory(
        self,
        directory
    ):


        results = []


        if not directory.exists():

            return results



        try:


            for item in directory.iterdir():


                if self.is_blocked(item):

                    continue



                if item.name.startswith("."):


                    # ukryte katalogi:
                    # tylko cache

                    if ".cache" not in str(item):

                        continue



                size = self.get_size(
                    item
                )



                if size <= 0:

                    continue



                results.append(

                    {

                        "name":
                        item.name,

                        "path":
                        item,

                        "size":
                        size

                    }

                )



        except PermissionError:

            pass



        return results



    def remove_duplicates(
        self,
        items
    ):


        result = []


        seen = set()



        for item in items:


            path = str(
                item["path"]
            )


            if path not in seen:


                seen.add(
                    path
                )


                result.append(
                    item
                )



        return result



    def scan(self):


        results = []



        #
        # główny cache
        #

        cache = (

            self.home
            /
            ".cache"

        )


        results.extend(

            self.scan_directory(
                cache
            )

        )



        #
        # flatpak cache
        #

        flatpak = (

            self.home
            /
            ".var"
            /
            "app"

        )


        if flatpak.exists():


            for app in flatpak.iterdir():


                cache_dir = (

                    app
                    /
                    "cache"

                )


                if cache_dir.exists():


                    results.append(

                        {

                            "name":

                            f"{app.name}/cache",


                            "path":

                            cache_dir,


                            "size":

                            self.get_size(
                                cache_dir
                            )

                        }

                    )



        #
        # kosz
        #

        trash = (

            self.home
            /
            ".local"
            /
            "share"
            /
            "Trash"

        )


        if trash.exists():


            results.append(

                {

                    "name":
                    "Trash",


                    "path":
                    trash,


                    "size":
                    self.get_size(
                        trash
                    )

                }

            )



        #
        # usuwanie duplikatów
        #

        results = self.remove_duplicates(
            results
        )



        #
        # sortowanie od największych
        #

        results.sort(

            key=lambda x:
            x["size"],

            reverse=True

        )


        return results
