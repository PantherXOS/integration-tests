import sys
import yaml
import socket
from os.path import expanduser

import capnp
from Account_capnp import Account
from AccountWriter_capnp import AccountWriter


account_path = expanduser('~') + '/.userdata/rpc/accounts'


def make_rpc_account(actObj):
    act = actObj['account']
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
        for svc in act['services']:
            for key in svc:
                rpc_services[i].name = key
                if len(svc[key]) > 0:
                    rpc_params = rpc_services[i].init(
                        'params', len(svc[key]))
                    j = 0
                    for param_key in svc[key]:
                        rpc_params[j].key = param_key
                        rpc_params[j].value = svc[key][param_key]
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
    client = _create_client(account_path)
    # get     @1 (title: Text) -> (account: Account);
    request = client.get_request()
    request.title = title
    response = request.send().wait()
    return response.account  


def rpc_account_list(provider_filters=None, service_filters=None):
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
        result.append(str(act))
    return result


def rpc_account_set_status(title, status):
    rpc_stat = _convert_status(status)
    if rpc_stat is None:
        print('Error: Invalid Status:', status)
        return False

    client = _create_client(account_path)
    # setStatus @2 (title: Text, stat: Account.Status) -> (result: Bool);
    request = client.setStatus_request()
    request.title = title
    request.stat = rpc_stat
    response = request.send().wait()
    return response.result


def rpc_account_get_status(title):
    client = _create_client(account_path)
    # getStatus @3 (title: Text) -> (status: Account.Status);
    request = client.getStatus_request()
    request.title = title
    response = request.send().wait()
    return _status_string(response.status)


def rpc_account_create(act):
    client = _create_client(account_path)
    # add @0 (account: Account) -> (result: Bool);
    request = client.add_request()
    request.account = act
    response = request.send().wait()
    for wrn in response.warnings:
        print(wrn)
    return response.result


def rpc_account_edit(title, act):
    client = _create_client(account_path)
    # edit @1 (title: Text, account: Account) -> (result: Bool);
    request = client.edit_request()
    request.title = title
    request.account = act
    response = request.send().wait()
    for wrn in response.warnings:
        print(wrn)
    return response.result


def rpc_account_remove(title):
    client = _create_client(account_path)
    # remove @2 (title: Text) -> (result: Bool);
    request = client.remove_request()
    request.title = title
    response = request.send().wait()
    return response.result


if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        ret = False

        if cmd == 'create':
            act = yaml.load(sys.argv[2], Loader=yaml.FullLoader)
            rpc_act = make_rpc_account(act)
            ret = rpc_account_create(rpc_act)

        elif cmd == 'edit':
            title = sys.argv[2]
            act = yaml.load(sys.argv[3], Loader=yaml.FullLoader)
            rpc_act = make_rpc_account(act)
            ret = rpc_account_edit(title, rpc_act)

        elif cmd == 'delete':
            title = sys.argv[2]
            ret = rpc_account_remove(title)

        elif cmd == 'list':
            print(rpc_account_list())
            ret = True

        elif cmd == 'get':
            title = sys.argv[2]
            rpc_act = rpc_account_get(title)
            print(rpc_act)
            ret = True

        elif cmd == 'set_status':
            title = sys.argv[2]
            status = sys.argv[3]
            ret = rpc_account_set_status(title, status)

        elif cmd == 'get_status':
            title = sys.argv[2]
            status = rpc_account_get_status(title)
            print(status)
            ret = True
        
        else:
            print('Invalid command: ', cmd)
    
    if not ret:
        exit(1)

