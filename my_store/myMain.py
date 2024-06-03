import sche_V3
import time
import threading






count = 0
sche_V3.SCH_Init() # khởi tạo scheduler

# =========================== define task ==================
def tron(thread_name,mix_1_delay):
    print("\tRUN MIXER 1")
    def pump_out_fun():
        print('\t\tOFF MIX 1')
        return
    threading.Timer(mix_1_delay,pump_out_fun).start()
    
    

# ======================== add start there====================
sche_V3.SCH_Add_Task(tron,"tron", 1, "ThreadTron", 2)

# =============== Main zone======================================

while True:
    print("count: ",count)
    sche_V3.SCH_Dispatch_Tasks()
    sche_V3.SCH_Update()
    count+=1
    if count %6 ==0:
        sche_V3.SCH_Add_Task(tron,"tron", 1, "ThreadTron", 2)
    time.sleep(1)
    