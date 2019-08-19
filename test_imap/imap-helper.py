import sys
import account_helper

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

imap_act1 = {
    'title': 'imap_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'imap': {
            'host': 'imap1.fastmail.com',
            'port': '993',
            'ssl': 'True',
            'username': 'test2@fastmail.de',
            'password': 'h6wgvfd4us38qrm8'
        }
    }
}

imap_act2 = {
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
            'username': '11test2@fastmail.de',
            'password': 'h6wgvfd4us38qrm8'
        }
    }
}

imap_act3 = {
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
            'password': 'h6wgvfd4us38q'
        }
    }
}



if __name__ == '__main__':
    ret = False
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == 'create-imap':
            rpc_act = account_helper.make_rpc_account(imap_act)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'check-invalid-host':
            rpc_act = account_helper.make_rpc_account(imap_act1)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'check-invalid-username':
            rpc_act = account_helper.make_rpc_account(imap_act2)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'check-invalid-password':
            rpc_act = account_helper.make_rpc_account(imap_act3)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'modify-imap':
            old_imap = account_helper.rpc_account_get(imap_act["title"])
            if old_imap is not None:
                new_imap = old_imap.as_builder()
                new_imap.title = 'my_imap_test'
                result = account_helper.rpc_account_edit(imap_act["title"], new_imap)
                saved_imap = account_helper.rpc_account_get(new_imap.title)
                saved_title = saved_imap.title
                if saved_title == new_imap.title:
                    ret = True
        elif cmd == 'remove-imap':
            ret = account_helper.rpc_account_remove('my_imap_test')

    if ret:
        exit(0)
    else:
        exit(1)
