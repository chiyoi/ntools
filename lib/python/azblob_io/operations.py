from azure.storage.blob import ContainerClient
from typing import Optional


def new_loading_anime():
    char = "|"
    while (True):
        yield char
        if char == "|":
            char = "/"
        elif char == "/":
            char = "-"
        elif char == "-":
            char = "\\"
        elif char == "\\":
            char = "|"


def progress_hook(current: int, total: Optional[int]):
    loading_anime = new_loading_anime()
    print("\r{}Running...{}".format(next(loading_anime), current if total is None else "{:.1f}%".format(current / total * 100)), end="")


def list_blobs(container_client: ContainerClient):
    print("blobs:")
    for blob_name in container_client.list_blob_names():
        print(blob_name)


def post(container_client: ContainerClient, blob_name: str, file_path: str):
    blob_client = container_client.get_blob_client(blob_name)
    with open(file_path, "rb") as f:
        blob_client.upload_blob(f, overwrite=True, progress_hook=progress_hook)
        print()
    print("post completed.")


def fetch(container_client: ContainerClient, blob_name: str, file_path: str):
    with open(file_path, "wb") as f:
        container_client.download_blob(blob_name, progress_hook=progress_hook).readinto(f)
        print()
    print("fetch completed.")


def remove(container_client: ContainerClient, blob_name: str):
    container_client.delete_blob(blob_name)
    print("remove completed.")
