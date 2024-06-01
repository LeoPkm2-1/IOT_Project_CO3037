import sche_V3
import time
import threading






count = 0
sche_V3.SCH_Init() # khởi tạo scheduler

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
sche_V3.SCH_Add_Task(tron,"tron", 5, "ThreadTron", 2, 3)

# =============== Main zone======================================

while True:
    print("count: ",count)
    sche_V3.SCH_Dispatch_Tasks()
    sche_V3.SCH_Update()
    count+=1
    time.sleep(1)
    