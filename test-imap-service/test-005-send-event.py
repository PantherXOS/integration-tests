import account_interface
import imap_service

def run():
    imap_service.send_event('imap', 'test_imap')
if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    run()
    exit(1)
