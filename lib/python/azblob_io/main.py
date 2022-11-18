from .init import init
from .operations import list_blobs, post, fetch, remove

usage = """usage: azblob-io command [<container_name>] [<blob_name>] [<file_path>]
    connect to azure-storage-blob and post/fetch blobs
commands:
    post   - upload to storage account
             <container_name>, <blob_name>, <file_path> required
    fetch  - download from storage account
             <container_name>, <blob_name>, <file_path> required
    remove - remove blob from account
             <container_name>, <blob_name> required
    list   - list blobs in container
             <container_name> required
    help   - show this usage message
returns:
    0 - ok
    1 - usage error
    2 - config error
files:
    $HOME/.ntools.cfg
        [azblob-io]
            AccountName
            AccountKey
            BlobServiceUrl"""


def main():
    d = init()
    if isinstance(d, int):
        if d == 1:
            print(usage)
        exit(d)

    try:
        if (cmd := d.cmd) == "help":
            print(usage)
        elif cmd == "list":
            list_blobs(d.container_client)
        elif cmd == "post":
            post(d.container_client, d.blob_name, d.file_path)
        elif cmd == "fetch":
            fetch(d.container_client, d.blob_name, d.file_path)
        elif cmd == "remove":
            remove(d.container_client, d.blob_name)
    except AttributeError as err:
        print("missing arg: {}".format(err))
