from  controllers import connector
from controllers.handleEvent import HandleEvent
from controllers import sche
import _thread
import time 
import threading

def main():
    count =0    # count varible 
    sche.SCH_Init()     # init scheduler
    iotServerConnect = connector.ADAFRUIT_CONNECTOR()
    iotServerConnect.set_message_cb(HandleEvent.default_message_cb(iotServerConnect))
    while True:
        print ("count :",count)
        sche.SCH_Dispatch_Tasks()
        sche.SCH_Update()
        count +=1
        time.sleep(1)
    
if __name__ =='__main__':
    main()




