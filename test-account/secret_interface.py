import socket
from os.path import expanduser

import capnp
from Secret_capnp import RPCSecretService

secret_path = expanduser('~') + '/.userdata/rpc/secret'


def _create_client(path):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    rpc_client = capnp.TwoPartyClient(sock)
    client = rpc_client.bootstrap().cast_as(RPCSecretService)
    return client


def rpc_account_get(title):
    try:
        client = _create_client(secret_path)
        # get     @1 (title: Text) -> (account: Account);
        request = client.get_request()
        request.title = title
        response = request.send().wait()
        print(response)
        return response.account
    except Exception as ex:
        print(ex)
    return None


def rpc_account_list(provider_filters=None, service_filters=None):
    try:
        client = _create_client(secret_path)
        # list    @0 (providerFilter: List(Text), serviceFilter: List(Text)) -> (accounts: List(Text));
        request = client.list_request()
        if provider_filters is not None:
            request.providerFilter = provider_filters
        if service_filters is not None:
            request.serviceFilter = service_filters
        response = request.send().wait()
        result = list()
        for act in response.accounts:
            result.append(act)
        print(response)
        return result
    except Exception as ex:
        print(ex)
    return None


def rpc_account_set_status(title, status):
    try:
        rpc_stat = _convert_status(status)
        if rpc_stat is None:
            print('Error: Invalid Status:', status)
            return False

        client = _create_client(secret_path)
        # setStatus @2 (title: Text, stat: Account.Status) -> (result: Bool);
        request = client.setStatus_request()
        request.title = title
        request.status = rpc_stat
        response = request.send().wait()
        print(response)
        return response.result
    except Exception as ex:
        print(ex)
    return False


def rpc_account_get_status(title):
    try:
        client = _create_client(secret_path)
        # getStatus @3 (title: Text) -> (status: Account.Status);
        request = client.getStatus_request()
        request.title = title
        response = request.send().wait()
        print(response)
        return _status_string(response.status)
    except Exception as ex:
        print(ex)
    return None


def rpc_account_create(act):
    try:
        client = _create_client(secret_path)
        # add @0 (account: Account) -> (result: Bool);
        request = client.add_request()
        request.account = act
        response = request.send().wait()
        print(response)
        if response.result == True:
            return True
    except Exception as ex:
        print(ex)
    return False


def rpc_account_edit(title, act):
    try:
        client = _create_client(secret_path)
        # edit @1 (title: Text, account: Account) -> (result: Bool);
        request = client.edit_request()
        request.title = title
        request.account = act
        response = request.send().wait()
        print(response)
        if response.result == True:
            return True
    except Exception as ex:
        print(ex)
    return False


def rpc_account_remove(title):
    try:
        client = _create_client(secret_path)
        # remove @2 (title: Text) -> (result: Bool);
        request = client.remove_request()
        request.title = title
        response = request.send().wait()
        print(response)
        if response.result == True:
            return True
    except Exception as ex:
        print(ex)
    return False
