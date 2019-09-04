import socket
import sqlite3
import time
from concurrent.futures import as_completed
from concurrent.futures.thread import ThreadPoolExecutor
from os.path import expanduser
from sqlite3 import Error

import account_interface
import event_capnp
import requests
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

def create_item(sender, time, title, body):
    return Item(sender, time, title, body)

def my_job(arg):
    api_key = arg[0]
    eth_address = arg[1]
    ac = arg[2]

    result = Result(-1, -1, None, None)

    try:
        socket.setdefaulttimeout(5)
        url = 'http://api.etherscan.io/api?module=account&action=txlist&address=' + eth_address + '&startblock=0&endblock=99999999&sort=asc&apikey=' + api_key
        headers = {"Accept": "application/json"}
        # call get service with headers and params
        response = requests.get(url, data="")

        if str(response.status_code) == '200':
            result.status = 1
        transactions = response.json()['result']

        messages = []
        i = 0
        for trans in transactions:
            message = Item(trans['from'], int(trans['timeStamp']), "transaction", str(trans['value']))
            messages.append(message)
            i += 1
            if i == 10:
                break

        result.cnt = len(messages)
        result.account = ac
        result.items = messages

    except Exception as ex:
        print("Error in connecting to Etherscan Wallet, ", ex)
    finally:
        return result


def get_accounts_list():
    try:
        lst = account_interface.rpc_account_list([], ['cryptocurrency'])
        etherscan_accounts = []
        for acc in lst:
            result = account_interface.rpc_account_get(acc)
            if result.active and len(result.services[0].params) > 0:
                if result.services[0].params[1].value == 'eth':
                    etherscan_accounts.append(result)
        if etherscan_accounts:
            return etherscan_accounts
        else:
            return None
    except Exception as ex:
        print("Error in getting accounts from px-accounts-service, ", ex)
        return None


def get_prepared_info(etherscan_accounts):
    accounts_info = []
    try:
        for acc in etherscan_accounts:
            eth_address = acc.services[0].params[0].value
            api_key = secret_interface.rpc_api_key_get(acc.services[0].params[2].value, 'etherscan')
            temp = (api_key, eth_address, acc.title)
            accounts_info.append(temp)
        if accounts_info:
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
    c = conn.cursor()
    for item in items:
        data.append((item.sender, item.time, item.title, item.message))
    if len(data) > 0:
        c.executemany('INSERT INTO hub_message(sender, time, title, message) VALUES (?,?,?,?)', data)
    # for row in c.execute('SELECT * FROM hub_message'):
    #     print(row)
    return len(data)


def make_capnp_packet(acc, event):
    wallet_event = event_capnp.EventData.new_message()
    wallet_event.event = event
    wallet_event.source = "px-data-service-etherscan"
    wallet_event.time = int(time.time())
    wallet_event.topic = "wallet"
    params = wallet_event.init('params', 3)
    service = params[0]
    service.key = "service"
    service.value = "cryptocurrency"
    account = params[1]
    account.key = "account"
    account.value = acc
    curr_type = params[2]
    curr_type.key = "curr_type"
    curr_type.value = "eth"

    print("wallet(etherscan) event >>>> " + ipc_path + "\n\r" + str(wallet_event))
    return wallet_event


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
        print('There is not any etherscan-accounts')
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
                            count = save_item(conn, data.items)
                        # emit event to hub
                        if count is not 0:
                            send_event('etherscan', data.account)
                except Exception as exc:
                    print("Error in getting result from future object in thread, ", exc)

            time.sleep(20)
    except Exception as ex:
        print(ex)