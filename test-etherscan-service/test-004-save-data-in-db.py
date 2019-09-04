import account_interface
import ether_service

def run():
    database = r"data_service.db"
    conn = ether_service.create_connection(database)
    ether_service.create_table(conn)
    # save data in DB
    with conn:
         ether_service.save_item(conn, [ether_service.create_item('0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a', '12345', 'transaction', '200000')])
    c = conn.cursor()
    for row in c.execute('SELECT * FROM hub_message'):
        print('saved: ', row)        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    run()
    exit(1)
