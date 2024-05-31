
# from controllers import connector
import sche
import _thread
import time
# import datetime
import threading



def print_abc5():
    print("abc5")
def abc(thread_name, delay1, delay2):
    print("RUN ABC")
    def print_abc2():
        print("abc2")
        threading.Timer(delay2, print_abc5).start()
    threading.Timer(delay1, print_abc2).start()

def deg(thread_name, delay1, delay2):
    print("deg")
    return 
sche.SCH_Init()
sche.SCH_Add_Task(abc, 1, "ThreadABC", 2, 5)
sche.SCH_Add_Task(deg, 6, "ThreadDEG", 2, 5)
sche.SCH_Add_Task(abc, 1, "Thread" , 2, 5)
count =0
while True:
    print ("count :",count)
    sche.SCH_Dispatch_Tasks()
    sche.SCH_Update()
    count +=1
    time.sleep(1)