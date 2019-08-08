import sys
import account_helper

api_act = {
    'title': 'etherscan1',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'etherscan': {
            'api_key': 'EZCEI7C9IYA7QXAZZPFY34E2WV56SRKRNH'
        }
    }
}

eth_act = {
    'title': 'eth_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'cryptocurrency': {
            'curr_type': 'eth',
            'address': '0x2a65Aca4D5fC5B5C859090a6c34d164135398226',
            'name': 'etherscan1'
        }
    }
}


def check():
    recv_act = account_helper.rpc_account_get(act['title'])
    print(recv_act)
    if act['title'] != recv_act.title \
            or act['provider'] != recv_act.provider \
            or act['active'] != recv_act.active:
        return False
    return True


if __name__ == '__main__':
    ret = False
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == 'create-api':
            rpc_act = account_helper.make_rpc_account(api_act)
            ret = account_helper.rpc_account_create(rpc_act)

        elif cmd == 'check-api':
            recv_act = account_helper.rpc_account_get(api_act['title'])
            if api_act['title'] == recv_act.title \
                    and api_act['provider'] == recv_act.provider \
                    and api_act['active'] == recv_act.active:
                ret = True

        elif cmd == 'create-eth':
            rpc_act = account_helper.make_rpc_account(eth_act)
            ret = account_helper.rpc_account_create(rpc_act)

        elif cmd == 'modify-eth':
            old_eth = account_helper.rpc_account_get(eth_act["title"])
            if old_eth is not None:
                new_eth = old_eth.as_builder()
                new_eth.title = 'my_eth_test'
                account_helper.rpc_account_edit(eth_act["title"], new_eth)
                saved_eth = account_helper.rpc_account_get(new_eth.title)
                if saved_eth.title == new_eth.title:
                    ret = True

        elif cmd == 'remove-eth':
            ret = account_helper.rpc_account_remove('my_eth_test')

    if ret:
        exit(0)
    else:
        exit(1)
