from .setting import HandleSchedule,Task,Schedule,LIST_OF_TASK,LIST_OF_SCHEDULES
from .setting import Utilization
from .connector import ADAFRUIT_CONNECTOR,RESPONSE_IOT_GATE,LISTEN_IOT_GATE
import datetime
import json
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
                        # for id,task in enumerate(LIST_OF_TASK):
                        #     print(id,task)
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
    