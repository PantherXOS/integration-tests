import account_interface
import imap_service

def run():
    data = [('a@test', '12345', 'hi', 'test test')]
    database = r"data_service.db"
    conn = imap_service.create_connection(database)
    imap_service.create_table(conn)
    # save data in DB
    with conn:
         imap_service.save_item(conn, [imap_service.create_item('a@test', '12345', 'hi', 'test test')])
    c = conn.cursor()
    for row in c.execute('SELECT * FROM hub_message'):
        print('saved: ', row)        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    run()
    exit(1)
