import threading
import _thread

SCH_MAX_TASKS = 3  # Define this as per your requirement
SCH_tasks_G = [None] * SCH_MAX_TASKS
current_index_task = 0
Error_code_G = 0

class Task:
    def __init__(self, pTask=None , Name=None, Delay=0, RunMe=0, *args, **kwargs):
        self.pTask = pTask
        self.Delay = Delay
        self.RunMe = RunMe
        self.args = args
        self.kwargs = kwargs
        self.Name = Name


def SCH_Init():
    for i in range(SCH_MAX_TASKS):
        SCH_Delete_Task(i)

def SCH_Add_Task(pFunction, Name, DELAY, *args, **kwargs):
    global current_index_task
    if current_index_task < SCH_MAX_TASKS:
        SCH_tasks_G[current_index_task] = Task(pFunction, Name, DELAY, 0, *args, **kwargs)
        current_index_task = current_index_task + 1
        return 0  # RETURN_NORMAL
    else:
        #Error_code_G = 1  # ERROR_SCH_TOO_MANY_TASKS
        return 1  # RETURN_ERROR
    
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
                _thread.start_new_thread(SCH_tasks_G[i].pTask, SCH_tasks_G[i].args, SCH_tasks_G[i].kwargs)
                # print("Task:", SCH_tasks_G[i].Name, "Started")
                SCH_Delete_Task(i)
                i-=1
            i+=1    
    else:
        return
            
def SCH_Delete_Task_Name(TASK_Name):
    global current_index_task
    i = 0
    while (i < current_index_task):
        # print ("Loop :" ,i)
        if SCH_tasks_G[i].Name == TASK_Name:
            del(SCH_tasks_G[i])
            current_index_task -= 1
            i=i-1
            return 0  # RETURN_NORMAL
        else :i += 1
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
    