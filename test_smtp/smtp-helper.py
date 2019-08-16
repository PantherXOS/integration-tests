import sys
import account_helper

smtp_act = {
    'title': 'smtp_test',
    'provider': '',
    'active': True,
    'settings': {
    },
    'services': {
        'smtp': {
            'sender': "test2@fastmail.de",
            'receivers': 'javaprogrammer93@gmail.com, halb@limg.moc, ',
            'host': "smtp.fastmail.com",
            'username': "test2@fastmail.de",
            'password': "h6wgvfd4us38qrm8",
            'port': '465',
            'message': "   From: From Person <from@fromdomain.com> To: To Person <to@todomain.com> Subject: SMTP e-mail test This is a test e-mail message."
        }
    }
}

if __name__ == '__main__':
    ret = False
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == 'create-smtp':
            rpc_act = account_helper.make_rpc_account(smtp_act)
            ret = account_helper.rpc_account_create(rpc_act)
        elif cmd == 'modify-smtp':
            old_smtp = account_helper.rpc_account_get(smtp_act["title"])
            if old_smtp is not None:
                new_smtp = old_smtp.as_builder()
                new_smtp.title = 'my_smtp_test'
                result = account_helper.rpc_account_edit(smtp_act["title"], new_smtp)
                saved_smtp = account_helper.rpc_account_get(new_smtp.title)
                saved_title = saved_smtp.title
                if saved_title == new_smtp.title:
                    ret = True
        elif cmd == 'remove-smtp':
            ret = account_helper.rpc_account_remove('my_smtp_test')

    if ret:
        exit(0)
    else:
        exit(1)
