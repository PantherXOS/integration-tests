import sys
import yaml
import account_helper

def create_account(act):
    rpc_act = account_helper.make_rpc_account_new(act)
    return account_helper.rpc_account_create(rpc_act)
        
    
def get_account(title):
    rpc_act = account_helper.rpc_account_get(title)
    print(rpc_act)

def edit_account(title, act):
    rpc_act = account_helper.make_rpc_account_new(act)
    return account_helper.rpc_account_edit(title, rpc_act)

if __name__ == "__main__":
    
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        ret = False

        if cmd == 'create':
            act = yaml.load(sys.argv[2])
            ret = create_account(act)

        elif cmd == 'get':
            title = sys.argv[2]
            get_account(title)
            ret = True
        
        elif cmd == 'edit':
            title = sys.argv[2]
            act = yaml.load(sys.argv[3])
            ret = edit_account(title, act)
        
        else:
            print('Invalid command: ', cmd)
    
    if not ret:
        exit(1)

