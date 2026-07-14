from datetime import datetime


def human_size(size):
    """
    Zamienia bajty na czytelny format.

    Przykład:
    1536000 -> 1.5 MB
    """

    if size is None:
        return "0 B"


    size = float(size)


    units = [
        "B",
        "KB",
        "MB",
        "GB",
        "TB"
    ]


    for unit in units:

        if size < 1024:

            return f"{size:.1f} {unit}"


        size /= 1024


    return f"{size:.1f} PB"



def timestamp():
    """
    Aktualny czas do logów.
    """

    return datetime.now().strftime(
        "%Y-%m-%d %H:%M:%S"
    )



def format_result(result):
    """
    Formatuje wynik z Cleaner.

    Przydatne do GUI.
    """

    if result["success"]:

        return (
            f"[OK] {result['path']} - "
            f"{result['message']}"
        )

    else:

        return (
            f"[ERROR] {result['path']} - "
            f"{result['message']}"
        )
