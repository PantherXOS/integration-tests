import socket
from os.path import expanduser
import getpass

import capnp
from Secret_capnp import RPCSecretService

secret_path = expanduser('~') + '/.userdata/rpc/secret'


def _create_client(path):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    rpc_client = capnp.TwoPartyClient(sock)
    client = rpc_client.bootstrap().cast_as(RPCSecretService)
    return client


def rpc_password_get(title, name):
    try:
        client = _create_client(secret_path)
        #getParam         @3 (wallet : Text, application   : Text, paramKey : Text)       -> (paramValue  : Text);
        request = client.getParam_request()
        request.wallet = getpass.getuser()
        request.application = title
        request.paramKey = name + '_password'
        rcp_result = request.send().wait()
        response = rcp_result.paramValue
        return response
    except Exception as ex:
        print(ex)
    return None

def rpc_api_key_get(title, name):
    try:
        client = _create_client(secret_path)
        #getParam         @3 (wallet : Text, application   : Text, paramKey : Text)       -> (paramValue  : Text);
        request = client.getParam_request()
        request.wallet = getpass.getuser()
        request.application = title
        request.paramKey = name + '_api_key'
        rcp_result = request.send().wait()
        response = rcp_result.paramValue
        return response
    except Exception as ex:
        print(ex)
    return None
