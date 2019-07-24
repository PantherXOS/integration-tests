import account_interface

act = { 
    'title' : 'etherscan1',
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
