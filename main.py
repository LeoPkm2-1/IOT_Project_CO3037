from  controllers import connector
from controllers.handleEvent import HandleEvent

def main():
    iotServerConnect = connector.ADAFRUIT_CONNECTOR()
    iotServerConnect.set_message_cb(HandleEvent.default_message_cb(iotServerConnect))
    while True:
        pass
    
if __name__ =='__main__':
    main()




