import account_interface
import blockio_service
import time
from concurrent.futures import as_completed
from concurrent.futures.thread import ThreadPoolExecutor


def run():
    accounts_info = [('0339-af79-9a14-e1d5', '1HB5XMLmzFVj8ALj6mfBsbifRoD4miY36v', 'btc_test')]
    executor = ThreadPoolExecutor(max_workers=1)
    while True:
            future_to_res = {executor.submit(blockio_service.my_job, acc): acc for acc in accounts_info}
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
                except Exception as exc:
                    print("Error in getting result from future object in thread, ", exc)
                    return 0
            time.sleep(20)      

if __name__ == '__main__':
    print("--------------------------------------------------------------------")
    ret = run()
    exit(ret)
