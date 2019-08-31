import account_interface

act = { 
    'title' : 'ethereum_test',
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

def run():
    rpc_act = account_interface.make_rpc_account(act)
    print(rpc_act)

    result = account_interface.rpc_account_create(rpc_act)
    if result:
        return 0
    return 1


if __name__ == '__main__':
    ret = run()
    exit(ret)
