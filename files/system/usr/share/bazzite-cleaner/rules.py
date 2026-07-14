from pathlib import Path


HOME = Path.home()


SAFE_DIRECTORIES = [

    {
        "name": "User Cache",
        "path": HOME / ".cache",
    },

    {
        "name": "Trash",
        "path": HOME / ".local/share/Trash",
    },

    {
        "name": "Thumbnail Cache",
        "path": HOME / ".cache/thumbnails",
    },

]


SAFE_NAMES = [
    "cache",
    ".cache",
    "shadercache",
    "htmlcache",
    "thumbnails",
]


FORBIDDEN_NAMES = [
    "data",
    "config",
    "documents",
    "downloads",
]
