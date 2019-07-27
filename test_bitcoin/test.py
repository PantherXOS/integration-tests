import sys
import os
import time
import socket
import yaml
from os.path import expanduser
from socket import error as socket_error

import capnp
from Account_capnp import Account
from AccountWriter_capnp import AccountWriter


def read_account(path):
    try:
        with open(path, 'r') as stream:
            data = yaml.load(stream)
            data_act = data['account']
            data_stg = data_act['settings']
            data_svc = data_act['services']

            act = Account.new_message(title=data_act['title'],
                                      provider=data_act['provider'],
                                      active=data_act['active'])

            if data_stg is not None and len(data_act) > 0:
                settings = act.init('settings', len(data_stg))
                i = 0
                for k in data_stg:
                    settings[i].key = k
                    settings[i].value = data_stg[k]
                    i += 1

            if data_svc is not None and len(data_svc) > 0:
                services = act.init('services', len(data_svc))
                for i in range(0, len(data_svc)):
                    for svc_key in data_svc[i]:
                        services[i].name = svc_key
                        if len(data_svc[i][svc_key]) > 0:
                            svc_params = services[i].init(
                                'params', len(data_svc[i][svc_key]))
                            j = 0
                            for k in data_svc[i][svc_key]:
                                svc_params[j].key = k
                                svc_params[j].value = data_svc[i][svc_key][k]
                                j += 1
            return act
    except yaml.YAMLError as yerr:
        print("YAML Error: ")
        print(yerr)
    except FileNotFoundError:
        print("Invalid File Name: ", path)
    return None


def run_test(path):
    act = read_account(path)
    print(act)
    print("======================")

    server_path = expanduser('~') + '/.userdata/rpc/accounts'
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(server_path)
    rpc_client = capnp.TwoPartyClient(sock)
    account_client = rpc_client.bootstrap().cast_as(AccountWriter)
    request = account_client.add_request()
    request.account = act
    result = request.send().wait()
    print('Add Account Result: ', result)


if __name__ == '__main__':

    # workaround for FileNotFoundError
    try:
        FileNotFoundError
    except NameError:
        FileNotFoundError = IOError

    if len(sys.argv) != 2:
        print('Usage: python test.py path_to_account_definition.yaml')
    else:
        run_test(sys.argv[1])
