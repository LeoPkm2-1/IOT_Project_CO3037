# Add schedule
1. structure:
```json
{
    "command": "ADD_SCHEDULE"
    ,"commandId": string
    ,"payload": {
        "scheduleId": string
        ,"scheduleName": string
        ,"cycle": number in string format
        ,"scheduleStartTime": date time in string format OR "NOW"
        ,"scheduleEndTime": date time in string format OR empty string
        ,"flow1": number in string format
        ,"flow2": number in string format
        ,"flow3": number in string format
    }
}
```


2. Example
```json
{
    "command": "ADD_SCHEDULE"
    ,"commandId":"commandId_ahihi_1"
    ,"payload": {
        "scheduleId": "1"
        ,"scheduleName": "heheh"
        ,"cycle": "1"
        ,"scheduleStartTime": "NOW"
        ,"scheduleEndTime": "2023-6-2 0:35:50"
        ,"flow1": "0"
        ,"flow2": "0"
        ,"flow3": "1"
    }
}
```



# Get task
1. structure:
```json
{
    "command": "GET_TASK"
    ,"commandId": string
    ,"payload": {
        "taskId":string
    }
}
```

2. Example:
```json
{
    "command": "GET_TASK"
    ,"commandId":"commandId_ahihi_1"
    ,"payload": {
        "taskId":"12223"
    }
}
```

# Delete task

1. structure:
```json
{
    "command": "REMOVE_TASK"
    ,"commandId": string
    ,"payload": {
        "taskId": string
    }
}
```


2. Example:
```json
{
    "command": "REMOVE_TASK"
    ,"commandId":"commandId_ahihi_1"
    ,"payload": {
        "taskId":"0_1_2024_06_05_23_53_47_247527"
    }
}
```