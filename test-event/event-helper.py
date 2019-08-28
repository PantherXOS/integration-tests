import time
import capnp
from event_capnp import EventData
from pynng import Sub0, Push0

if __name__ == "__main__":
    subscriber = Sub0(dial='ipc:///root/.userdata/event/channels/account')
    subscriber.subscribe(b'')
    print('subscriber connected')
    print('------')

    publisher = Push0()
    publisher.dial('ipc:///root/.userdata/rpc/events')
    print('publisher connected')
    print('------')

    evt = EventData.new_message()
    evt.topic = 'account'
    evt.source = 'test app'
    evt.time = int(time.time()*1000.0)
    evt.event = 'aaaaaaa'
    evt.init('params', 2)
    evt.params[0].key = 'first'
    evt.params[0].value = 'first val'
    evt.params[1].key = 'second'
    evt.params[1].value = 'second val'
    print(evt)
    print('------')

    publisher.send(evt.to_bytes())
    data = subscriber.recv()
    received_evt = EventData.from_bytes(data)
    print(received_evt)
    print('------')

    publisher.close()
    subscriber.close()
    print('everything done')
    print('------')
