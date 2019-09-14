import account_interface


imap_act = {
    'title': 'imap_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'imap': {
            'host': 'imap.fastmail.com',
            'port': '993',
            'ssl': 'True',
            'username': 'test2@fastmail.de',
            'password': 'h6wgvfd4us38qrm8'
        }
    }
}

api_act1 = {
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

api_act2 = {
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

def get_blockio_accounts_list():
    try:
        lst = account_interface.rpc_account_list([], ['cryptocurrency'])
        accounts = []
        for acc in lst:
            result = account_interface.rpc_account_get(acc)
            if result.active and len(result.services[0].params) > 0:
                if result.services[0].params[1].value == 'btc':
                    accounts.append(result)
        if accounts:
            return accounts
        else:
            return None
    except Exception as ex:
        print("Error in getting accounts from px-accounts-service, ", ex)
        return None



def create_blockio_account():
    result= get_blockio_accounts_list()
    if result: 
       for acc in result:
           account_interface.rpc_account_remove(acc.title)
    rpc_act = account_interface.make_rpc_account(api_act2)
    ret = account_interface.rpc_account_create(rpc_act)
    
    print("created api account: ", ret)

    rpc_act = account_interface.make_rpc_account(btc_act)
    ret = account_interface.rpc_account_create(rpc_act)

    print("created btc account: ", ret)
    return ret
  

def get_etherscan_accounts_list():
    try:
        lst = account_interface.rpc_account_list([], ['cryptocurrency'])
        etherscan_accounts = []
        for acc in lst:
            result = account_interface.rpc_account_get(acc)
            if result.active and len(result.services[0].params) > 0:
                if result.services[0].params[1].value == 'eth':
                    etherscan_accounts.append(result)
        if etherscan_accounts:
            return etherscan_accounts
        else:
            return None
    except Exception as ex:
        print("Error in getting accounts from px-accounts-service, ", ex)
        return None


def create_etherscan_account():
    result= get_etherscan_accounts_list()
    if result: 
       for acc in result:
           account_interface.rpc_account_remove(acc.title)
    rpc_act = account_interface.make_rpc_account(api_act1)
    ret = account_interface.rpc_account_create(rpc_act)
    
    print("created api account: ", ret)

    rpc_act = account_interface.make_rpc_account(eth_act)
    ret = account_interface.rpc_account_create(rpc_act)

    print("created eth account: ", ret)

    return ret

def get_imap_accounts_list():
    try:
        lst = account_interface.rpc_account_list([], ["imap"])
        imap_accounts = []
        for acc in lst:
            result = account_interface.rpc_account_get(acc)
            imap_accounts.append(result)
        if imap_accounts:
            return imap_accounts
        else:
            return None
    except Exception as ex:
        print("Error in getting accounts from px-accounts-service, ", ex)
        return None


def create_imap_account():
    result= get_imap_accounts_list()
    if result: 
       for acc in result:
           account_interface.rpc_account_remove(acc.title)
    rpc_act = account_interface.make_rpc_account(imap_act)
    result = account_interface.rpc_account_create(rpc_act)
    print("created imap account: ", result)
    
    return result  




def main():
    res1 = create_blockio_account()
    res2 = create_etherscan_account()
    res3 = create_imap_account()

    if res1 and res2 and res3:
        exit(1)
    else:
        exit(0)

main()