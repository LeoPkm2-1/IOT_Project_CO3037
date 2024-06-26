import datetime
import math
import json
from datetime import timedelta
WATER_FOR_U_MIXER_1 = 1
WATER_FOR_U_MIXER_2 = 1
WATER_FOR_U_MIXER_3 = 2
WATER_SPEED = 9
DATE_TIME_FORMAT = "%Y-%m-%d %H:%M:%S"
LIST_OF_TASK =[]
LIST_OF_SCHEDULES =[]
WAITING_STATUS_TASK='WAITING'
DONE_STATUS_TASK='DONE'
RUNNING_STATUS_TASK='RUNNING'



class Utilization:
    @staticmethod
    def is_valid_date_time(dateTimeStr):
        dateTimeformat = "%Y-%m-%d %H:%M:%S"
        try:
            # Try to parse the time string according to the specified format
            datetime.datetime.strptime(dateTimeStr, dateTimeformat)
            return True
        except ValueError:
            # If a ValueError is raised, the time string is not valid
            return False
    @staticmethod
    def is_valid_number(value):
        try:
            float(value)
            return True
        except ValueError:
            return False
    
    @staticmethod
    def is_valid_int(value):
        try:
            int(value)
            return True
        except ValueError:
            return False
    @staticmethod
    def gen_response_message(status:str,command_id:str,command:str,msg,payload):
        resMsg = {
            "status":status,
            "commandId":command_id,
            "command":command,
            "message":msg,
            "payload":payload
        }
        return json.dumps(resMsg)
    
    @staticmethod
    def check_two_task_conflict(task1,task2):
        return task1.is_conflict_with(task2)
    
    @staticmethod
    def list_task_conflict_with_tasks1(tasks1):
        listOfNotDoneTasks = [task for task in LIST_OF_TASK if not task.isDone()]
        conflictTaskLst = []
        for task1 in tasks1:
            for task2 in listOfNotDoneTasks:
                if task1.is_conflict_with(task2):
                    conflictTaskLst.append(task2)
        return conflictTaskLst
     

class Schedule:
    DATE_TIME_FORMAT = "%Y-%m-%d %H:%M:%S"

    def __init__(self, scheduleId: str,
                 scheduleName: str,
                 cycle,
                 area:str,
                 scheduleStartTime: str,
                 scheduleEndTime: str,
                 flow1=0,
                 flow2=0,
                 flow3=0):
        
        self.scheduleId = scheduleId
        self.scheduleName = scheduleName
        self.cycle = int(cycle) if cycle.strip() else ''
        self.area = int(area) if Utilization.is_valid_int(area) else 0
        self.scheduleStartTime = datetime.datetime.strptime(
            scheduleStartTime, self.DATE_TIME_FORMAT) if scheduleStartTime.upper() !='NOW' else datetime.datetime.now() + datetime.timedelta(seconds=0.1)
        self.scheduleEndTime = datetime.datetime.strptime(
            scheduleEndTime, self.DATE_TIME_FORMAT
        ) if Utilization.is_valid_date_time(str(scheduleEndTime)) else ''
        self.flow1 = float(flow1) if Utilization.is_valid_number(flow1) else 0
        self.flow2 = float(flow2) if Utilization.is_valid_number(flow2) else 0
        self.flow3 = float(flow3) if Utilization.is_valid_number(flow3) else 0
        

    def __str__(self) -> str:
        return f"scheduleId:{self.scheduleId} - scheduleName:{self.scheduleName}\
             - cycle:{self.cycle} - area:{self.area}\
             - scheduleStartTime:{self.scheduleStartTime} - scheduleEndTime:{self.scheduleEndTime}\
             - flow1:{self.flow1} - flow2:{self.flow2} - flow3:{self.flow3}"

    def get_water_for_mix1(self):
        return self.flow1*WATER_FOR_U_MIXER_1
    
    def get_time_for_mix1(self):
        return math.ceil(self.get_water_for_mix1()/WATER_SPEED)

    def get_water_for_mix2(self):
        return self.flow2*WATER_FOR_U_MIXER_2
    
    def get_time_for_mix2(self):
        return math.ceil(self.get_water_for_mix2()/WATER_SPEED)

    def get_water_for_mix3(self):
        return self.flow3*WATER_FOR_U_MIXER_3
    
    def get_time_for_mix3(self):
        return math.ceil(self.get_water_for_mix3()/WATER_SPEED)

    def get_total_water(self):
        return self.get_water_for_mix1()+self.get_water_for_mix2()+self.get_water_for_mix3()

    def get_time_for_mix(self):
        return self.get_time_for_mix1() \
                +self.get_time_for_mix2() \
                +self.get_time_for_mix3()
        # return self.get_total_water()/WATER_SPEED

    def get_time_pump_out(self):
        return self.get_time_for_mix()

    def get_time_task_taking(self):
        return self.get_time_for_mix() + self.get_time_pump_out()
    
    def get_area(self):
        return self.area

class Task (Schedule):

    def __init__(self,
                 taskId='',
                 scheduleId='',
                 scheduleName= '',
                 cycle= '',
                 area= '',
                 scheduleStartTime=datetime.datetime.now().strftime(DATE_TIME_FORMAT),
                 scheduleEndTime= '',
                 flow1=0,
                 flow2=0,
                 flow3=0,
                 startAt=None,
                 endAt=None
                 ):
        super().__init__(scheduleId,
                         scheduleName,
                         cycle,
                         area,
                         scheduleStartTime,
                         scheduleEndTime,
                         flow1,
                         flow2,
                         flow3)
        self.startAt = startAt
        self.endAt = endAt
        self.taskId=taskId
        self.presentStatus = WAITING_STATUS_TASK

        # self.endAt = self.scheduleStartTime + datetime.timedelta(seconds=self.get_time_task_taking())
    
    def copySchedule(self,schedule:Schedule):
        self.scheduleId=schedule.scheduleId
        self.scheduleName=schedule.scheduleName
        self.cycle=schedule.cycle
        self.area=schedule.area
        self.scheduleStartTime=schedule.scheduleStartTime
        self.scheduleEndTime=schedule.scheduleEndTime
        self.flow1=schedule.flow1
        self.flow2=schedule.flow2
        self.flow3=schedule.flow3
        return self

    def get_dic_format(self):
        return {
            "taskId": self.taskId,
            "scheduleId": self.scheduleId,
            "scheduleName": self.scheduleName,
            "cycle": self.cycle,
            "flow1": self.flow1,
            "flow2": self.flow2,
            "flow3": self.flow3,
            "startAt": self.startAt.strftime(self.DATE_TIME_FORMAT),
            "endAt": self.endAt.strftime(self.DATE_TIME_FORMAT),
            "presentStatus": self.presentStatus,
            "timeForMix1": self.get_time_for_mix1(),
            "timeForMix2": self.get_time_for_mix2(),
            "timeForMix3": self.get_time_for_mix3(),
            "timeForSelectorAndPumpOut": self.get_time_pump_out(),
            "area":self.get_area(),
        }
    
    def get_json_string_format(self):
        task = self.get_dic_format();
        return json.dumps(task)

    def set_startAt(self, startAt):
        self.startAt = startAt

    def set_endAt(self, endAt):
        self.endAt = endAt

    def get_startAt(self):
        return self.startAt

    def get_endAt(self):
        return self.endAt
    def get_taskId(self):
        return self.taskId
    
    def set_status(self,status=WAITING_STATUS_TASK):
        status=status.upper()
        if status !=WAITING_STATUS_TASK \
                and status!=RUNNING_STATUS_TASK \
                and status != DONE_STATUS_TASK:
            raise Exception('TASK_STATUS_NOT_TRUE')
        
        self.presentStatus=status
    
    def switch_status_running(self):
        self.presentStatus = RUNNING_STATUS_TASK
    
    def switch_status_done(self):
        self.presentStatus =DONE_STATUS_TASK
    
    def switch_status_waiting(self):
        self.presentStatus = WAITING_STATUS_TASK
    
    def get_status(self):
        return self.presentStatus
    
    def set_taskId(self,taskId):
        self.taskId=taskId
    
    def isWaiting(self):
        return self.get_status() == WAITING_STATUS_TASK
    
    def isRunning(self):
        return self.get_status() == RUNNING_STATUS_TASK
    
    def isDone(self):
        return self.get_status() == DONE_STATUS_TASK
        
    def update_times_with_known_startTime(self, startTime):
        self.set_startAt(startTime)
        endAt = self.startAt + \
            datetime.timedelta(seconds=self.get_time_task_taking())
        self.set_endAt(endAt)
        return self
    def __str__(self) -> str:
        return f"taskId:{self.taskId} - scheduleId:{self.scheduleId} - scheduleName:{self.scheduleName}\
             - cycle:{self.cycle} - area:{self.area}\
             - scheduleStartTime:{self.scheduleStartTime} - scheduleEndTime:{self.scheduleEndTime}\
             - flow1:{self.flow1} - flow2:{self.flow2} - flow3:{self.flow3}\
             - startAt:{self.startAt} - endAt:{self.endAt}"   
    
    def is_conflict_with(self,task2) :
        if task2.get_endAt() <= self.get_startAt() or self.get_endAt() <= task2.get_startAt():
            return False
        return True

        

class HandleSchedule:
    def __init__(self, schedule: Schedule):
        self.schedule = schedule

    def get_list_of_tasks_startTime(self):
        timeList = []
        if not self.schedule.scheduleEndTime:
            timeList.append(self.schedule.scheduleStartTime)
        else:
            detalTime = (self.schedule.scheduleEndTime -
                         self.schedule.scheduleStartTime).total_seconds()
            numOfsteps = math.floor(
                (detalTime / (3600*24))//self.schedule.cycle)

            for i in range(numOfsteps+1):
                startTime = self.schedule.scheduleStartTime + \
                    timedelta(days=int(i*self.schedule.cycle))
                timeList.append(startTime)
        return timeList

    def get_list_of_tasks(self):
        listOfStartTimes = self.get_list_of_tasks_startTime()
        listOfTask = [
            Task().copySchedule(self.schedule)\
                .update_times_with_known_startTime(startTime=startTime)\
                for startTime in listOfStartTimes
        ]
        nowString = datetime.datetime.now().strftime("%Y_%m_%d_%H_%M_%S_%f")
        for order,task in enumerate(listOfTask):
            task.set_taskId(
                f"{order}_{self.schedule.scheduleId}_{nowString}"
            )
        return listOfTask


if __name__ == '__main__':

    startTime = "2024-05-10 10:00:00"
    endTime = "2024-05-12 10:00:00"
    
    sch = Schedule(1, 'lich temp', '1', '', startTime, endTime, 1, 1, 1)

    a = HandleSchedule(schedule=sch)
    b = a.get_list_of_tasks()
    for data in b:
        print(data,'\n')
