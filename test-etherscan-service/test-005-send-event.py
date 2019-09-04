import account_interface
import ether_service

def run():
    ether_service.send_event('etherscan', 'test_ether')
if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    run()
    exit(1)
