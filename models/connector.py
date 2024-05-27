
import os
import sys
from Adafruit_IO import MQTTClient
from dotenv import load_dotenv

load_dotenv()


class ADAFRUIT_CONNECTOR:
    # static variable
    AIO_FEED_IDS = ['nutnhan1', 'nutnhan2']
    AIO_USERNAME = os.getenv('ADAFRUIT_IO_USERNAME')
    AIO_KEY = os.getenv('ADAFRUIT_IO_PASSWORD')

    def __init__(self, AIO_FEED_IDS=None,
                 message_cb=None,
                 subscribe_cb=None,
                 connected_cb=None,
                 disconnected_cb=None,
                 ):
        self.AIO_FEED_IDS = AIO_FEED_IDS if AIO_FEED_IDS is not None \
            else ADAFRUIT_CONNECTOR.AIO_FEED_IDS
            
        self.connected_cb = connected_cb if connected_cb is not None \
            else self.default_connected_cb()
        self.disconnected_cb = disconnected_cb if disconnected_cb is not None \
            else self.default_disconnected_cb()
        self.message_cb = message_cb if message_cb is not None \
            else self.default_message_cb()
        self.subscribe_cb = subscribe_cb if subscribe_cb is not None \
            else self.default_subscribe_cb()

        self.client = MQTTClient(self.AIO_USERNAME, self.AIO_KEY)
        self.client.on_connect = self.connected_cb
        self.client.on_disconnect = self.disconnected_cb
        self.client.on_message = self.message_cb
        self.client.on_subscribe = self.subscribe_cb
        self.client.connect()
        self.client.loop_background()

    @classmethod
    def get_AIO_USERNAME(cls):
        return cls.AIO_USERNAME

    @classmethod
    def get_AIO_KEY(cls):
        return cls.AIO_KEY
    
    def default_connected_cb(self):
        def connected(client):
            print("Ket noi thanh cong ...")
            for topic in self.AIO_FEED_IDS:
                client.subscribe(topic)
        return connected

    def default_disconnected_cb(self):
        def disconnected(client):
            print("Ngat ket noi ...")
            sys.exit(1)
        return disconnected
    
    def default_message_cb(self):
        def message(client, feed_id, payload):
            print("Nhan du lieu: " + payload+" - tu: "+feed_id)
        return message
    
    def default_subscribe_cb(self):
        def subscribe(client, userdata, mid, granted_qos):
            print("Subscribe thanh cong ...")
        return subscribe

    def get_list_feed_ids(self):
        return self.AIO_FEED_IDS
    
    def set_connected_cb(self,connected_cb=None):
        self.connected_cb = connected_cb if connected_cb is not None \
            else self.default_connected_cb()
        self.client.on_connect = self.connected_cb
    
    def get_connected_cb(self):
        return self.connected_cb
    
    def set_disconnected_cb(self,disconnected_cb=None):
        self.disconnected_cb = disconnected_cb if disconnected_cb is not None \
            else self.default_disconnected_cb()
        self.client.on_disconnect = self.disconnected_cb

    def get_disconnected_cb(self):
        return self.disconnected_cb
    
    def set_message_cb(self,message_cb=None):
        self.message_cb = message_cb if message_cb is not None \
            else self.default_message_cb()
        self.client.on_message = self.message_cb
        
    def get_message_cb(self):
        return self.message_cb
    
    def set_subscribe_cb(self,subscribe_cb=None):
        self.subscribe_cb = subscribe_cb if subscribe_cb is not None \
            else self.default_subscribe_cb()
        self.client.on_subscribe = self.subscribe_cb
    
    def get_subscribe_cb(self):
        return self.subscribe_cb
        
    

    def sendData(self, target_feed_id, data=''):
        self.client.publish(target_feed_id, data)
        


a = ADAFRUIT_CONNECTOR(['cambien1',
                        'cambien2',
                        'cambien3',
                        'nutnhan1', 
                        'nutnhan2'])
def temp (client,feed_id,data):
    print('Bo m la: '+feed_id+' gia tri la: '+data)
    
a.set_message_cb(temp)
while True:
    pass


# def connected(client):
#     print("Ket noi thanh cong ...")
#     for topic in AIO_FEED_IDS:
#         client.subscribe(topic)


# def subscribe(client, userdata, mid, granted_qos):
#     print("Subscribe thanh cong ...")


# def disconnected(client):
#     print("Ngat ket noi ...")
#     sys.exit(1)


# def message(client, feed_id, payload):
#     print("Nhan du lieu: " + payload)


# client = MQTTClient(AIO_USERNAME, AIO_KEY)
# client.on_connect = connected
# client.on_disconnect = disconnected
# client.on_message = message
# client.on_subscribe = subscribe
# client.connect()
# client.loop_background()

# while True:
#     pass
