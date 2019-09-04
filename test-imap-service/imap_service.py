import email
import imaplib
import socket
import sqlite3
import time
from concurrent.futures import as_completed
from concurrent.futures.thread import ThreadPoolExecutor
from os.path import expanduser
from sqlite3 import Error

import account_interface
import event_capnp
import secret_interface
from pynng import Push0

ipc_path = "ipc://" + expanduser("~") + "/.userdata/rpc/events"


class Item:
    def __init__(self, sender, time, title, message):
        self.sender = sender
        self.time = time
        self.title = title
        self.message = message


class Result:
    def __init__(self, status, cnt, account, items):
        self.cnt = cnt
        self.status = status
        self.account = account
        self.items = items


def my_job(arg):
    address = arg[0]
    passd = arg[1]
    host = arg[2]
    port = arg[3]
    ssl = arg[4]
    ac = arg[5]
    result = Result(-1, -1, None, None)

    try:
        socket.setdefaulttimeout(5)
        if ssl in ["true", "True", True, ]:
            mail = imaplib.IMAP4_SSL(host, int(port))
        else:
            mail = imaplib.IMAP4(host, int(port))

        mail.login(address, passd)
        mail.list()
        mail.select("inbox")
        (retcode, messages) = mail.search(None, '(UNSEEN)')
        if retcode == 'OK':
            unread_msg_nums = len(messages[0].split())
            result.cnt = unread_msg_nums
            result.status = 1
            result.account = ac
            items = []
            for num in messages[0].split():
                print('Processing ')
                typ, data = mail.fetch(num, '(RFC822)')
                for response_part in data:
                    if isinstance(response_part, tuple):
                        original = email.message_from_bytes(response_part[1])
                        sender = original['From']
                        title = original['Subject']
                        body = (original.get_payload()[0])._payload
                        date_tuple = email.utils.parsedate_tz(original['Date'])
                        time = email.utils.mktime_tz(date_tuple)
                        item = Item(sender, time, title, body)
                        items.append(item)
                result.items = items
        mail.close()
    except Exception as ex:
        print("Error in connecting to IMAP, ", ex)
    finally:
        return result


def get_accounts_list():
    try:
        lst = account_interface.rpc_account_list([], ["imap"])
        imap_accounts = []
        for acc in lst:
            result = account_interface.rpc_account_get(acc)
            # if result.active and len(result.services[0].params) > 0:
            #     if result.services[0].name == 'imap':
            imap_accounts.append(result)
        if imap_accounts:
            return imap_accounts
        else:
            return None
    except Exception as ex:
        print("Error in getting accounts from px-accounts-service, ", ex)
        return None


def get_prepared_info(imap_accounts):
    accounts_info = []
    try:
        for acc in imap_accounts:
            host = acc.services[0].params[0].value
            port = acc.services[0].params[1].value
            ssl = acc.services[0].params[2].value
            username = acc.services[0].params[3].value
            password = secret_interface.rpc_password_get(acc.title, acc.services[0].name)
            temp = (username, password, host, port, ssl, acc.title)
            accounts_info.append(temp)
        if accounts_info and password:
            return accounts_info
        else:
            return None
    except Exception as ex:
        print("Error in getting protected params from px-secret-service, ", ex)
        return None


def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print("Error in creating DB connection", e)
    return conn


def create_item(sender, time, title, body):
    return Item(sender, time, title, body)


def create_table(conn):
    create_table_sql = '''CREATE TABLE IF NOT EXISTS hub_message
                     (id INTEGER PRIMARY KEY,
                      sender varchar(20) NOT NULL,
                      time integer NOT NULL,
                      title varchar(20) NOT NULL,
                      message text NOT NULL
                      )'''
    try:
        c = conn.cursor()
        c.execute(create_table_sql)
    except Error as e:
        print("Error in creating hub_message table", e)


def save_item(conn, items):
    data = []
    for item in items:
        data.append((item.sender, item.time, item.title, item.message))
    cur = conn.cursor()
    conn.executemany('INSERT INTO hub_message(sender, time, title, message) VALUES (?,?,?,?)', data)
    return cur.lastrowid


def make_capnp_packet(acc, event):
    mail_event = event_capnp.EventData.new_message()
    mail_event.event = event
    mail_event.source = "px-data-service-etherscan"
    mail_event.time = int(time.time())
    mail_event.topic = "mail"
    params = mail_event.init('params', 2)
    service = params[0]
    service.key = "service"
    service.value = "imap"
    account = params[1]
    account.key = "account"
    account.value = acc
    print("mail(imap) event >>>> " + ipc_path + "\n\r" + str(mail_event))
    return mail_event


def send_event(event, account):
    with Push0(dial=ipc_path) as push:
        pass
        # give some time to connect
        time.sleep(0.01)
        push.send(make_capnp_packet(account, event).to_bytes())
        time.sleep(0.01)


if __name__ == "__main__":
    database = r"data_service.db"
    conn = create_connection(database)
    create_table(conn)
    executor = ThreadPoolExecutor(max_workers=1)

    # get accounts list from px-accounts-service
    lst = get_accounts_list()
    if lst is None:
        print('There is not any imap-accounts')
        exit(1)

    # get password from px-secret-service for each account
    accounts_info = get_prepared_info(lst)
    if accounts_info is None:
        print("cannot fetch password from px-secret-service")
        exit(1)

    try:
        # send required information to a job to done periodically

        while True:
            future_to_res = {executor.submit(my_job, acc): acc for acc in accounts_info}
            for future in as_completed(future_to_res):
                input_params = future_to_res[future]
                # print(input_params)
                try:
                    data = future.result()
                    if data.status == -1:
                        print('It cannot fetch data. Please check your network connection ')
                    if data.cnt == 0:
                        print('there is no new message')
                    elif data.cnt > 0:
                        print('there is', data.cnt, 'new message')
                        # save data  in DB
                        with conn:
                            save_item(conn, data.items)
                        # emit event to hub
                        send_event('imap', data.account)
                except Exception as exc:
                    print("Error in getting result from future object in thread, ", exc)

            time.sleep(20)
    except Exception as ex:
        print(ex)
