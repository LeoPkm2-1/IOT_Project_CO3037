import sche
import time
import threading






count = 0
sche.SCH_Init() # khởi tạo scheduler

# =========================== define task ==================
def tron(thread_name,mix_1_delay,pump_out_delay):
    print("\tRUN MIXER 1")
    print("\tPUMP IN")
    def pump_out_fun():
        print('\t\toff mix 1')
        print('\t\toff pump in')
        print('\t\tPump OUT')
        def end_pump_out_fun():
            print("=== end pump out")
            return
        threading.Timer(pump_out_delay,end_pump_out_fun).start()
    threading.Timer(mix_1_delay,pump_out_fun).start()
    
    

# ======================== add start there====================
sche.SCH_Add_Task(tron,2,"xin chao",1,3)

# =============== Main zone======================================

while True:
    print("count: ",count)
    sche.SCH_Dispatch_Tasks()
    sche.SCH_Update()
    count+=1
    time.sleep(1)
    