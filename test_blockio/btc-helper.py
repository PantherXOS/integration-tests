import sys
import account_helper

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

api_act_invalid = {
    'title': 'blockio1',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'blockio': {
            'api_key': '0339-af79-9a14-1426'
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
            'address': '3BvkFoFgqKV9HHmdkiY4UYK9FU4NTyETXe',
            'name': 'blockio1'
        }
    }
}

btc_act_invalid = {
    'title': 'btc_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'cryptocurrency': {
            'curr_type': 'btc',
            'address': 'EsfasfaV9HHmdkiY4UYK9FU4NTyETXe',
            'name': 'blockio1'
        }
    }
}


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
             
        elif cmd == 'check-apikey-api':
            rpc_act = account_helper.make_rpc_account(api_act_invalid)
            ret = account_helper.rpc_account_create(rpc_act)
            ret = not ret
        elif cmd == 'create-btc':
            rpc_act = account_helper.make_rpc_account(btc_act)
            ret = account_helper.rpc_account_create(rpc_act)

        elif cmd == 'check-address-btc':
            rpc_act = account_helper.make_rpc_account(btc_act_invalid)
            ret = account_helper.rpc_account_create(rpc_act)
            ret = not ret
        elif cmd == 'modify-btc':
            old_btc = account_helper.rpc_account_get(btc_act["title"])
            if old_btc is not None:
                new_btc = old_btc.as_builder()
                new_btc.title = 'my_btc_test'
                account_helper.rpc_account_edit(btc_act["title"], new_btc)
                saved_btc = account_helper.rpc_account_get(new_btc.title)
                if saved_btc.title == new_btc.title:
                    ret = True

        elif cmd == 'remove-btc':
            ret = account_helper.rpc_account_remove('my_btc_test')

    if ret:
        exit(0)
    else:
        exit(1)
