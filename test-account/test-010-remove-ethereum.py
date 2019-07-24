import account_interface


def run():
    accounts = [
        'ethereum_test',
        'ethereum_test_new',
        'etherscan1'
    ]
    for title in accounts:
        result = account_interface.rpc_account_remove(title)
        if result == False:
            return 1
        print('--- {} deleted'.format(title))
    return 0


if __name__ == '__main__':
    ret = run()
    exit(ret)
