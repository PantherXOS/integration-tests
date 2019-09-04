import account_interface
import blockio_service

api_act = {
    'title': 'blockio1',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'blockio': {
            'api_key': '0339-af79-9a14-e1d5'
        }
    }
}

btc_act = {
    'title': 'btc_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'cryptocurrency': {
            'curr_type': 'btc',
            'address': '1HB5XMLmzFVj8ALj6mfBsbifRoD4miY36v',
            'name': 'blockio1'
        }
    }
}


def run():
    result= blockio_service.get_accounts_list()
    if result: 
       for acc in result:
           account_interface.rpc_account_remove(acc.title)
    rpc_act = account_interface.make_rpc_account(api_act)
    ret = account_interface.rpc_account_create(rpc_act)
    
    print("created api account: ", ret)

    rpc_act = account_interface.make_rpc_account(btc_act)
    ret = account_interface.rpc_account_create(rpc_act)

    print("created btc account: ", ret)

    if ret:
        return 0
    return 1        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    ret = run()
    exit(ret)
