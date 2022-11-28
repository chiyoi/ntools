from configparser import ConfigParser, NoSectionError, NoOptionError
from typing import Literal, Union
import os.path as path
import sys

from azure.storage.blob import BlobServiceClient, ContainerClient
from azure.core.credentials import AzureNamedKeyCredential


class Data:
    container_client: ContainerClient
    cmd: Literal["post", "fetch", "remove", "list", "help"]
    blob_name: str
    file_path: str


def init() -> Union[Data, int]:
    d = Data()
    cfg = ConfigParser()
    cfg.read(path.expanduser("~/.ntools.cfg"))

    try:
        account_name = cfg.get("azblob-io", "AccountName")
        account_key = cfg.get("azblob-io", "AccountKey")
        blob_service_url = cfg.get("azblob-io", "BlobServiceUrl")
    except (NoSectionError, NoOptionError) as err:
        print(err)
        return 2

    if (argc := len(sys.argv)) in (2, 3):
        pass
    elif argc == 4:
        d.blob_name = sys.argv[3]
    elif argc == 5:
        d.blob_name = sys.argv[3]
        d.file_path = sys.argv[4]
    else:
        print("error number of args: got {}, expected (2, 3, 4, 5)".format(argc))
        return 1

    if (cmd := sys.argv[1]) in ("post", "fetch", "list", "remove"):
        d.cmd = cmd
    elif cmd in ("help", "--help"):
        d.cmd = "help"
    else:
        print("unknown command {}, type `azblob-io help` to learn more.".format(cmd))
        return 1

    containerName = sys.argv[2]

    credential = AzureNamedKeyCredential(account_name, account_key)
    blob_service_client = BlobServiceClient(blob_service_url, credential)
    d.container_client = blob_service_client.get_container_client(
        containerName
    )
    return d
