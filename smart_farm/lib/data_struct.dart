// {
// "command": "ADD_SCHEDULE"
// ,"commandId": string
// ,"payload": {
// "scheduleId": string
// ,"scheduleName": string
// ,"cycle": number in string format
// ,"scheduleStartTime": date time in string format OR "NOW"
// ,"scheduleEndTime": date time in string format OR empty string
// ,"flow1": number in string format
// ,"flow2": number in string format
// ,"flow3": number in string format
// , "area": number in string format
// }
// }

// Create a struct of the data. And a struct of the command.
import 'package:flutter/material.dart';
import 'package:smart_farm/values/app_colors.dart';
import 'package:smart_farm/values/app_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class ScheduleStruct {
  String scheduleId;
  String scheduleName;
  String cycle;
  String scheduleStartTime;
  String scheduleEndTime;
  String flow1;
  String flow2;
  String flow3;
  String area;

  ScheduleStruct({
    required this.scheduleId,
    required this.scheduleName,
    required this.cycle,
    required this.scheduleStartTime,
    required this.scheduleEndTime,
    required this.flow1,
    required this.flow2,
    required this.flow3,
    required this.area,
  });

  factory ScheduleStruct.fromJson(Map<String, dynamic> json) {
    return ScheduleStruct(
      scheduleId: json['scheduleId'],
      scheduleName: json['scheduleName'],
      cycle: json['cycle'],
      scheduleStartTime: json['scheduleStartTime'],
      scheduleEndTime: json['scheduleEndTime'],
      flow1: json['flow1'],
      flow2: json['flow2'],
      flow3: json['flow3'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'scheduleName': scheduleName,
      'cycle': cycle,
      'scheduleStartTime': scheduleStartTime,
      'scheduleEndTime': scheduleEndTime,
      'flow1': flow1,
      'flow2': flow2,
      'flow3': flow3,
      'area': area,
    };
  }
}

class EventStruct {
  String taskId;
  String taskName;
  String taskStartTime; // yyyy-mm-dd hh:mm:ss
  String taskEndTime; // yyyy-mm-dd hh:mm:ss
  String flow1;
  String flow2;
  String flow3;
  String area;
  Color color;

  EventStruct({
    required this.taskId,
    required this.taskName,
    required this.taskStartTime,
    required this.taskEndTime,
    required this.flow1,
    required this.flow2,
    required this.flow3,
    required this.area,
    required this.color,
  });

  factory EventStruct.fromJson(Map<String, dynamic> json) {
    return EventStruct(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskStartTime: json['taskStartTime'],
      taskEndTime: json['taskEndTime'],
      flow1: json['flow1'],
      flow2: json['flow2'],
      flow3: json['flow3'],
      area: json['area'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskStartTime': taskStartTime,
      'taskEndTime': taskEndTime,
      'flow1': flow1,
      'flow2': flow2,
      'flow3': flow3,
      'area': area,
      'color': color.value,
    };
  }

  static String listToJson(List<EventStruct> eventList) {
    final List<Map<String, dynamic>> jsonData = eventList.map((item) => item.toJson()).toList();
    return jsonEncode(jsonData);
  }

  // Static method to convert a string to a list of EventStruct objects
  static List<EventStruct> fromString(String str) {
    final List<dynamic> jsonData = jsonDecode(str);
    return jsonData.map((item) => EventStruct.fromJson(item)).toList();
  }



  String reformatTime(String time) {
    // yyyy-mm-dd hh:mm:ss to hh:mm:ss dd/mm/yyyy
    List<String> timeList = time.split(' ');
    List<String> dateList = timeList[0].split('-');
    return '${timeList[1]} ${dateList[2]}/${dateList[1]}/${dateList[0]}';
  }

  Widget buildEventWidget() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Khu vực $area - $taskName',
                  style: AppStyles.textBold14.copyWith(color: AppColors.white),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Row(
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset('assets/icons/ic_clock.svg', height: 20, color: AppColors.white,)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${reformatTime(taskStartTime)} - ${reformatTime(taskEndTime)}',
                        style: AppStyles.textRegular14.copyWith(color: AppColors.white),
                      ),
                    ]
                )
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Đạm: ${flow1}kg; Lân: ${flow2}kg; Kali: ${flow3}kg',
                  style: AppStyles.textRegular14.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// task != schedule
// submit schedule => success, receive a task_id[] => get_task + id
// => save to local storage

// add schedule
// remove task
// get task


// gui het string
// ko co data ""
// scheduleId
// scheduleName
// cycle
// scheduleStartTime
// => estimateTime
// scheduleEndTime
// flow1
// flow2
// flow3
// area
// => color