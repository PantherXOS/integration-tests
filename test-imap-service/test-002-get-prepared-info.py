import account_interface
import imap_service

def run():
    result= imap_service.get_accounts_list()
    if result:
       info = imap_service.get_prepared_info(result)
       if info:
          print(info)
       else:
          print("cannot fetch password from px-secret-service")
    if result:
        return 0
    return 1        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    ret = run()
    exit(ret)
