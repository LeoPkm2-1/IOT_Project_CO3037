
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


def tron(thread_name, delay1, delay2, delay3):
    print("RUN MIXER 1")
    def MIXER2():
        print("MIXER 2")
        def MIXER3():
            print("MIXER 3")
            def END_MIXER3():
                print("END MIXER 3")
                return
            threading.Timer(delay3, END_MIXER3).start()
        threading.Timer(delay2, MIXER3).start()
    threading.Timer(delay1, MIXER2).start()



sche.SCH_Init()
sche.SCH_Add_Task(tron, 5, "ThreadTron", 2, 3,1)
#sche.SCH_Add_Task(abc, 1, "ThreadABC", 2, 5)
# sche.SCH_Add_Task(deg, 6, "ThreadDEG", 2, 5)
# sche.SCH_Add_Task(abc, 1, "Thread" , 2, 5)
count =0
while True:
    print ("count :",count)
    sche.SCH_Dispatch_Tasks()
    sche.SCH_Update()
    count +=1
    time.sleep(1)