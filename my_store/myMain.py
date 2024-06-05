import sche_V3
import time
import threading






count = 0
sche_V3.SCH_Init() # khởi tạo scheduler

# =========================== define task ==================
def tron(thread_name,mix_1_delay):
    print("\t\tRUN tron 1")
    def pump_out_fun():
        print('\t\tOFF tron 1')
        return
    threading.Timer(mix_1_delay,pump_out_fun).start()

def mix(thread_name,mix_1_delay):
    print("'\t===Mix1 1")
    def executor():
        print(f"\t======OFF Mix")
    threading.Timer(mix_1_delay,executor).start()
    
def delete_task(thread_name,task_name):
    sche_V3.SCH_Delete_Task_Name(task_name);
    return 

# def delete_task(task_name):
#     sche_V3.SCH_Delete_Task_Name(task_name);
#     return 
    
    
    
    

# ======================== add start there====================
sche_V3.SCH_Add_Task(tron,"tron", 2, "ThreadTron", 2)
sche_V3.SCH_Add_Task(mix,"mix", 3, "ThreadTron", 2)
# sche_V3.SCH_Add_Task(delete_task,"xinchao", 1, "ThreadTron", 'tron')

# =============== Main zone======================================

while True:
    print("count :",count)
    sche_V3.SCH_Dispatch_Tasks()
    sche_V3.SCH_Update()
    count +=1
    time.sleep(1)
    