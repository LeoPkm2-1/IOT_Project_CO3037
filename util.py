
class EventInfor:
    id = ""
    eventName = ""

    # loop
    cycle = 1
    cycleType = "day" # hours, day, week, month, year
    endTime = ""

    flow1 = 0
    flow2 = 0
    flow3 = 0

    startTime = ""
    endTime = ""

    def __init__(self, id, eventName, cycle, endTime, count, flow1, flow2, flow3, startTime):
        self.id = id
        self.eventName = eventName
        self.cycle = cycle
        self.endTime = endTime
        self.count = count
        self.flow1 = flow1
        self.flow2 = flow2
        self.flow3 = flow3
        self.startTime = startTime
        self.endTime = endTime

class EventList:
    EventList = []

    def __init__(self):
        self.EventList = []
    
    def addEvent(self, event):
        # check trùng, trả được id lịch trùng

        # add event in order start time
        for i in range(len(self.EventList)):
            if event.startTime < self.EventList[i].startTime:
                self.EventList.insert(i, event)
                return
        self.EventList.append(event)
    
    def printList(self): # form eventName : startTime
        for i in range(len(self.EventList)):
            print(self.EventList[i].eventName + " : " + self.EventList[i].startTime.strftime("%Y-%m-%d %H:%M:%S"))

Event1 = EventInfor(
                        "1", 
                        "LichTuoi1", 
                        1, 
                        datetime.strptime("2020-01-01 00:00:00", "%Y-%m-%d %H:%M:%S"),
                        0, 
                        10, 
                        20, 
                        30, 
                        datetime.strptime("2020-01-15 00:00:00", "%Y-%m-%d %H:%M:%S")
                    )
Event2 = EventInfor(
                        "2", 
                        "LichTuoi2", 
                        1, 
                        datetime.strptime("2018-01-01 00:00:00", "%Y-%m-%d %H:%M:%S"),
                        0, 
                        10, 
                        20, 
                        30, 
                        datetime.strptime("2020-01-14 00:00:00", "%Y-%m-%d %H:%M:%S")
                    )
Event3 = EventInfor(
                        "3", 
                        "LichTuoi3", 
                        1, 
                        datetime.strptime("2020-01-01 00:00:00", "%Y-%m-%d %H:%M:%S"),
                        0, 
                        10, 
                        20, 
                        30, 
                        datetime.strptime("2020-01-31 00:00:00", "%Y-%m-%d %H:%M:%S")
                    )

print("Hello")
EventList = EventList()
EventList.addEvent(Event1)
EventList.addEvent(Event2)
EventList.addEvent(Event3)

EventList.printList()



