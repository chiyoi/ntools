from azure.storage.blob import ContainerClient

def list_blobs(container_client: ContainerClient):
    print("blobs:")
    for blob_name in container_client.list_blob_names():
        print(blob_name)


def post(container_client: ContainerClient, blob_name: str, file_path: str):
    blob_client = container_client.get_blob_client(blob_name)
    with open(file_path, "rb") as f:
        blob_client.upload_blob(f)
    print("post completed.")


def fetch(container_client: ContainerClient, blob_name: str, file_path: str):
    with open(file_path, "wb") as f:
        container_client.download_blob(blob_name).readinto(f)
    print("fetch completed.")

def remove(container_client: ContainerClient, blob_name: str):
    container_client.delete_blob(blob_name)
    print("remove completed.")
