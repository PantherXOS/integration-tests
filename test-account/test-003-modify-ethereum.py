import account_interface


def run():
    old_title = 'ethereum_test'
    new_title = 'ethereum_test_new'
    
    print('--- get old account:')
    act = account_interface.rpc_account_get(old_title)
    if act is None:
        return 1
    

    print('--- edit account title:')
    act = act.as_builder()
    act.title = new_title
    result = account_interface.rpc_account_edit(old_title, act)
    if not result:
        return 1

    print('--- get new account:')
    new_act = account_interface.rpc_account_get(new_title)
    print(new_act)
    if new_act is None:
        return 1
    if new_act.title != new_title:
        print('Error invlid account title:', new_act.title)
        return 1

    return 0




if __name__ == '__main__':
    ret = run()
    exit(ret)
