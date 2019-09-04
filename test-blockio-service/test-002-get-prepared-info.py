import account_interface
import blockio_service

def run():
    result= blockio_service.get_accounts_list()
    if result:
       info = blockio_service.get_prepared_info(result)
       if info:
          print(info)
       else:
          print("cannot fetch api_key from px-secret-service")
    if result:
        return 0
    return 1        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    ret = run()
    exit(ret)
