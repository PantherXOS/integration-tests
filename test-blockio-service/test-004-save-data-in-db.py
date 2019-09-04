import account_interface
import blockio_service

def run():
    database = r"data_service.db"
    conn = blockio_service.create_connection(database)
    blockio_service.create_table(conn)
    # save data in DB
    with conn:
         blockio_service.save_item(conn, [blockio_service.create_item('1HB5XMLmzFVj8ALj6mfBsbifRoD4miY36v', '12345', 'transaction', '200000')])
    c = conn.cursor()
    for row in c.execute('SELECT * FROM hub_message'):
        print('saved: ', row)        

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    run()
    exit(1)
