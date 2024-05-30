import threading
import _thread
SCH_MAX_TASKS = 10  # Define this as per your requirement
SCH_tasks_G = [None] * SCH_MAX_TASKS
current_index_task = 0
Error_code_G = 0

class Task:
    def __init__(self, pTask=None, Delay=0, RunMe=0):
        self.pTask = pTask
        self.Delay = Delay
        self.RunMe = RunMe

def SCH_Init():
    for i in range(SCH_MAX_TASKS):
        SCH_Delete_Task(i)

def SCH_Add_Task(pFunction, DELAY):
    global current_index_task
    if current_index_task < SCH_MAX_TASKS:
        SCH_tasks_G[current_index_task] = Task(pFunction, DELAY,0)
        current_index_task = current_index_task + 1
        return 0  # RETURN_NORMAL
    else:
        #Error_code_G = 1  # ERROR_SCH_TOO_MANY_TASKS
        return 1  # RETURN_ERRO
    
def SCH_Update():
    global current_index_task
    for i in range (current_index_task):
        if SCH_tasks_G[i].Delay > 1:
            SCH_tasks_G[i].Delay -= 1
            #print("task:", i, "delay:", SCH_tasks_G[i].Delay)
        else:
            SCH_tasks_G[i].RunMe += 1
            
def SCH_Dispatch_Tasks():
    if current_index_task > 0:
        i=0
        while (i < current_index_task ):
            if SCH_tasks_G[i].RunMe>0:
                # print("RUN TASK:" ,i)
                #_thread.start_new_thread(target =SCH_tasks_G[i].pTask())
                SCH_tasks_G[i].pTask() # Run function
                SCH_Delete_Task(i)
                # print("DEL SUCCESS TASK", i)
                # print(" CON LAI ",current_index_task, "TASK")
                # print(SCH_tasks_G)
                i-=1
            i+=1
    else:
        return
            

def SCH_Delete_Task(TASK_INDEX):
    global current_index_task
    if current_index_task <= 0 or current_index_task >= SCH_MAX_TASKS:
        Error_code_G = 1  # ERROR_SCH_CANNOT_DELETE_TASK
        return 1  # RETURN_ERROR
    else:
        # print(SCH_tasks_G)
        del(SCH_tasks_G[TASK_INDEX])
        current_index_task -= 1
        return 0  # RETURN_NORMAL
    