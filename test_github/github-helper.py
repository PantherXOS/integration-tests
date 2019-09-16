import sys
import account_helper

github_act = {
    'title': 'github_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'github': {
            'username': 'test1github002',
            'password': 'h6wgvfd4us38qrm8'
        }
    }
}

invalid_username_act = {
    'title': 'github_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'github': {
            'username': '1test1github002',
            'password': 'h6wgvfd4us38qrm8'
        }
    }
}


invalid_password_act = {
    'title': 'github_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'github': {
            'username': 'test1github002',
            'password': 'h6wgvfd4us38qrm823'
        }
    }
}



if __name__ == '__main__':
    ret = False
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == 'create-github':
            rpc_act = account_helper.make_rpc_account(github_act)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'check-invalid-username':
            rpc_act = account_helper.make_rpc_account(invalid_username_act)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'check-invalid-password':
            rpc_act = account_helper.make_rpc_account(invalid_password_act)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'modify-github':
            old_github = account_helper.rpc_account_get(github_act["title"])
            if old_github is not None:
                new_github = old_github.as_builder()
                new_github.title = 'my_github_test'
                result = account_helper.rpc_account_edit(github_act["title"], new_github)
                saved_github= account_helper.rpc_account_get(new_github.title)
                saved_title = saved_github.title
                if saved_title == new_github.title:
                    ret = True
        elif cmd == 'remove-github':
            ret = account_helper.rpc_account_remove('my_github_test')

    if ret:
        exit(0)
    else:
        exit(1)
