import socket
from os.path import expanduser

import capnp
from Account_capnp import Account
from AccountWriter_capnp import AccountWriter


account_path = expanduser('~') + '/.userdata/rpc/accounts'


def make_rpc_account(act):
    rpc_act = Account.new_message(title=act['title'],
                                  provider=act['provider'],
                                  active=act['active'])
    if len(act['settings']) > 0:
        rpc_settings = rpc_act.init('settings', len(act['settings']))
        i = 0
        for key in act['settings']:
            rpc_settings[i].key = key
            rpc_settings[i].value = act['settings'][key]
            i += 1
    if len(act['services']) > 0:
        rpc_services = rpc_act.init('services', len(act['services']))
        i = 0
        for key in act['services']:
            rpc_services[i].name = key
            if len(act['services'][key]) > 0:
                rpc_params = rpc_services[i].init(
                    'params', len(act['services'][key]))
                j = 0
                for param_key in act['services'][key]:
                    rpc_params[j].key = param_key
                    rpc_params[j].value = act['services'][key][param_key]
                    j += 1
            i += 1
    return rpc_act


def _create_client(path):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    rpc_client = capnp.TwoPartyClient(sock)
    act_client = rpc_client.bootstrap().cast_as(AccountWriter)
    return act_client


def _convert_status(status):
    if status == 'none':
        return Account.Status.none
    elif status == 'online':
        return Account.Status.online
    elif status == 'offline':
        return Account.Status.offline
    elif status == 'error':
        return Account.Status.error
    else:
        return None


def _status_string(status):
    if status == Account.Status.none:
        return 'none'
    elif status == Account.Status.online:
        return 'online'
    elif status == Account.Status.offline:
        return 'offline'
    elif status == Account.Status.error:
        return 'error'
    else:
        return None


def rpc_account_get(title):
    try:
        client = _create_client(account_path)
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
        client = _create_client(account_path)
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

        client = _create_client(account_path)
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
        client = _create_client(account_path)
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
        client = _create_client(account_path)
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
        client = _create_client(account_path)
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
        client = _create_client(account_path)
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
