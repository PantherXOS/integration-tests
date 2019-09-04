import account_interface
import blockio_service

def run():
    blockio_service.send_event('blockio', 'test_btc')
if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    run()
    exit(1)
