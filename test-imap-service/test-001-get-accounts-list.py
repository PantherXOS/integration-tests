import account_interface
import imap_service

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


def run():
    result= imap_service.get_accounts_list()
    if result: 
       for acc in result:
           account_interface.rpc_account_remove(acc.title)
    rpc_act = account_interface.make_rpc_account(imap_act)
    result = account_interface.rpc_account_create(rpc_act)
    print("created this account: ", result)
    if result:
        return 0
    return 1        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    ret = run()
    exit(ret)
