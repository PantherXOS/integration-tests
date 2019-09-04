import account_interface
import ether_service

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
            'address': '0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a',
            'name': 'etherscan1'
        }
    }
}


def run():
    result= ether_service.get_accounts_list()
    if result: 
       for acc in result:
           account_interface.rpc_account_remove(acc.title)
    rpc_act = account_interface.make_rpc_account(api_act)
    ret = account_interface.rpc_account_create(rpc_act)
    
    print("created api account: ", ret)

    rpc_act = account_interface.make_rpc_account(eth_act)
    ret = account_interface.rpc_account_create(rpc_act)

    print("created eth account: ", ret)

    if ret:
        return 0
    return 1        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    ret = run()
    exit(ret)
