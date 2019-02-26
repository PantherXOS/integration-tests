#!/run/current-system/profile/bin/env python2

import sys, os, time
import socket
import yaml
from os.path import expanduser
from socket import error as sock_error

import capnp
from Account_capnp import Account               # pylint: disable=E0401
from AccountWriter_capnp import AccountWriter   # pylint: disable=E0401


def start_test(cfg_path):
    try:
        with open(cfg_path, 'r') as stream:
            data = yaml.load(stream)
            # print(data)
            act = Account.new_message(title=data['account']['title'],
                                      provider=data['account']['provider'],
                                      active=data['account']['active'])

            if data['account']['settings'] is not None and len(data['account']['settings']) > 0:
                act_settings = act.init('settings', len(data['account']['settings']))
                i = 0
                for k in data['account']['settings']:
                    act_settings[i].key = k
                    act_settings[i].value = data['account']['settings'][k]
                    i += 1
            if len(data['account']['services']) > 0:
                act_services = act.init('services', len(data['account']['services']))
                for i in range(0, len(data['account']['services'])):
                    for svc in data['account']['services'][i]:
                        act_services[i].name = svc
                        if len(data['account']['services'][i][svc]) > 0:
                            svc_params = act_services[i].init('params', len(data['account']['services'][i][svc]))
                            j = 0
                            for k in data['account']['services'][i][svc]:
                                svc_params[j].key = k
                                svc_params[j].value = data['account']['services'][i][svc][k]
                                j += 1

            print('Account to add:')
            print(act)
            print('')
        
            server_path = expanduser('~') + '/.userdata/rpc/accounts'
            sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            sock.connect(server_path)
            rpc_client = capnp.TwoPartyClient(sock)                         # pylint: disable=E1101
            account_client = rpc_client.bootstrap().cast_as(AccountWriter)
            request = account_client.add_request()
            request.account = act
            result = request.send().wait()
            print('Add account result:', result)

    except yaml.YAMLError as yerr:
        print ("YamlError: ")
        print (yerr)

    except FileNotFoundError:
        print("Invalid file name")


if __name__ == '__main__':
    try:
        FileNotFoundError
    except NameError:
        FileNotFoundError = IOError
    if len(sys.argv) != 2:
        print("Usage: python3 test_script.py path_to_file.yaml")
    else:
        start_test(sys.argv[1])
