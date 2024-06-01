from .setting import HandleSchedule,Task,Schedule,LIST_OF_TASK,LIST_OF_SCHEDULES
from .setting import Utilization
from .connector import ADAFRUIT_CONNECTOR,RESPONSE_IOT_GATE,LISTEN_IOT_GATE
from  .sche import SCH_Add_Task,SCH_Delete_Task_Name
import datetime
import json
import _thread
import time 
import threading

class HandleTask:
    @staticmethod
    def add_task_into_scheduler(task:Task):
        # waitingTime = (task.get_startAt() - datetime.datetime.now()).total_seconds()
        # waitingTime = waitingTime if waitingTime>0 else 0
        waitingTime = 1
        def excutor(threadName,
                    TimeForMix1,
                    TimeForMix2,
                    TimeForMix3,
                    TimeForPumpOut):
            pumpOpened=False
            if task.get_time_for_mix1()>0:
                # pumpOpened
                pumpOpened =True
                print(f"  {task.get_status()}",'Open Pump')
                task.switch_status_running()
                print('    Run Mix-1',task.get_status())
            def mix_2():
                nonlocal pumpOpened
                if task.get_time_for_mix2()>0:
                    if task.isWaiting(): task.switch_status_running()
                    if not pumpOpened: print(f"  {task.get_status()}",'Open Pump')
                    print('\t   End Mix-1 + Run Mix-2',task.get_status())
                    pumpOpened =True 
                def mix_3():
                    nonlocal pumpOpened
                    if task.get_time_for_mix3()>0:
                        if task.isWaiting(): task.switch_status_running()
                        if not pumpOpened: print(f"  {task.get_status()}",'Open Pump')
                        print('\t\tEnd Mix-2 + Run Mix-3',task.get_status())
                        pumpOpened =True
                    def pump_out():
                        if task.get_time_pump_out()>0:
                            print('\t \t End Mix-3,Pump-in + selector,Pump out',task.get_status())
                        def wait_pump_out():
                            if task.get_time_pump_out()>0:
                                task.switch_status_done()
                                print('\t\t\tend pump out',task.get_status())
                            return
                        threading.Timer(TimeForPumpOut,wait_pump_out).start()
                    threading.Timer(TimeForMix3,pump_out).start()
                threading.Timer(TimeForMix2,mix_3).start()                
            threading.Timer(TimeForMix1,mix_2).start()
            return
        SCH_Add_Task(excutor,task.get_taskId(),
                     waitingTime,
                     f"thread_{task.get_taskId()}",
                     task.get_time_for_mix1(),
                     task.get_time_for_mix2(),
                     task.get_time_for_mix3(),
                     task.get_time_pump_out()
                     )
        
class HandleEvent:
    @staticmethod
    def default_message_cb(connectorObj:ADAFRUIT_CONNECTOR):
        def executor(client, feed_id, payload):
            try:
                if feed_id == LISTEN_IOT_GATE:
                    eventData = json.loads(payload)
                    # Thêm lịch 
                    if eventData['command'].upper()=='ADD_SCHEDULE':
                        schedule=Schedule(**eventData['payload'])
                        if schedule.scheduleStartTime < datetime.datetime.now():
                            raise Exception("START_TIME_IN_PASS")
                        if schedule.scheduleEndTime and schedule.scheduleEndTime <= schedule.scheduleStartTime:
                            raise Exception("END_TIME_AND_START_TIME_NOT_TRUE")
                        listOfTasks = HandleSchedule(schedule).get_list_of_tasks()
                        LIST_OF_TASK.extend(listOfTasks)
                        connectorObj.sendData(RESPONSE_IOT_GATE,
                            Utilization.gen_response_message('SUCCESS',
                                                             'ADD_SCHEDULE',
                                                             'schedule ok',
                                                             eventData['payload']))
                        for task in listOfTasks:
                            print(task.get_time_for_mix1(),
                                  task.get_time_for_mix2(),
                                  task.get_time_for_mix3(),
                                  task.get_time_pump_out())
                            HandleTask.add_task_into_scheduler(task)
                        # for task in LIST_OF_TASK:
                        #     print(task.get_taskId())
                        
                        # def acb(thread_name,deylay1):
                        #     print('\tRun mix 1')
                        #     def mix2():
                        #         print("\t\tend mix 1")
                        #         return
                        #     threading.Timer(deylay1,mix2).start()
                        # def task_temp(thread_name,delay1,delay2):
                        #     print('\t===RUN MIX 2')
                        #     def mix():
                        #         print('\t===END_M2')
                        #         def func():
                        #             print('\t===ahihi')
                        #             return;
                        #         threading.Timer(delay2,func).start()
                        #     threading.Timer(delay1,mix).start()
                        # def delete_task_by_name(thread_name,task_name):
                        #     SCH_Delete_Task_Name(task_name)
                        #     return
                        # SCH_Add_Task(acb,'task_name_1',0,"thread_name_1",0)
                        # SCH_Add_Task(task_temp,"task_name_2",0,'thread_name_2',2,2)
                        # SCH_Add_Task(delete_task_by_name,'dell_ahihi',3,'thread_name_3',"task_name_1")
                    # xoá lịch
                    elif eventData['command'].upper()=='REMOVE_SCHEDULE':
                        pass
                    elif eventData['command'].upper()=='REMOVE_TASK':
                        pass
                    elif eventData['command'].upper()=='GET_HISTORY':
                        pass
            except Exception as error:
                error_message = str(error)
                print(error_message,type(error_message))
                # xử lý khi thời gian bắt đầu là thời điểm trong quá khứ
                if error_message =='START_TIME_IN_PASS':
                    connectorObj.sendData(RESPONSE_IOT_GATE,
                        Utilization.gen_response_message("ERROR",
                                                         'ADD_SCHEDULE',
                                                         'start time of schedule in pass',
                                                         eventData['payload']))
                elif error_message =='END_TIME_AND_START_TIME_NOT_TRUE':
                    connectorObj.sendData(RESPONSE_IOT_GATE,
                        Utilization.gen_response_message("ERROR",
                                                         'ADD_SCHEDULE',
                                                         'start time and end time not true',
                                                         eventData['payload']))                    
            
        return executor
    