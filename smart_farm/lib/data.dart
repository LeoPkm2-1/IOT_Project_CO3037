import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_struct.dart';

class EventDataSingleton extends ChangeNotifier {
  List<EventStruct> _eventList = [];

  EventDataSingleton._privateConstructor() {
    _loadData();
  }

  static final EventDataSingleton _instance = EventDataSingleton._privateConstructor();

  static EventDataSingleton get instance => _instance;

  List<EventStruct> get getEvents => _eventList;

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('eventList');
    if (data != null) {
      _eventList = EventStruct.fromString(data);
    }
  }

  Future<void> addEvent(EventStruct event) async {
    int insertIndex = _eventList.indexWhere((existingEvent) => existingEvent.taskStartTime.compareTo(event.taskStartTime) > 0);
    if (insertIndex == -1) {
      _eventList.add(event);
    } else {
      _eventList.insert(insertIndex, event);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = EventStruct.listToJson(_eventList);
    await prefs.setString('eventList', data);

    notifyListeners();
  }
}

// List<EventStruct> testEvents = [
//   EventStruct(
//     taskId: '1001',
//     taskName: 'Tưới sáng định kỳ 1',
//     taskStartTime: '2024-05-30 7:30:00',
//     taskEndTime: '2024-05-30 7:55:00',
//     flow1: '11',
//     flow2: '22',
//     flow3: '35',
//     area: '1',
//     color: AppColors.eventColor1,
//   ),
//   EventStruct(
//     taskId: '1002',
//     taskName: 'Tưới sáng định kỳ 2',
//     taskStartTime: '2024-05-30 7:30:00',
//     taskEndTime: '2024-05-30 7:55:00',
//     flow1: '11',
//     flow2: '22',
//     flow3: '35',
//     area: '1',
//     color: AppColors.eventColor2,
//   ),
//   EventStruct(
//     taskId: '1003',
//     taskName: 'Tưới sáng định kỳ 3',
//     taskStartTime: '2024-05-30 7:30:00',
//     taskEndTime: '2024-05-30 7:55:00',
//     flow1: '11',
//     flow2: '22',
//     flow3: '35',
//     area: '1',
//     color: AppColors.eventColor3,
//   ),
//   EventStruct(
//     taskId: '1004',
//     taskName: 'Tưới sáng định kỳ 4',
//     taskStartTime: '2024-05-30 7:30:00',
//     taskEndTime: '2024-05-30 7:55:00',
//     flow1: '11',
//     flow2: '22',
//     flow3: '35',
//     area: '1',
//     color: AppColors.eventColor4,
//   ),
//   EventStruct(
//     taskId: '1005',
//     taskName: 'Tưới sáng định kỳ 5',
//     taskStartTime: '2024-05-30 7:30:00',
//     taskEndTime: '2024-05-30 7:55:00',
//     flow1: '11',
//     flow2: '22',
//     flow3: '35',
//     area: '1',
//     color: AppColors.eventColor5,
//   ),
//   EventStruct(
//     taskId: '1006',
//     taskName: 'Tưới sáng định kỳ 6',
//     taskStartTime: '2024-05-30 7:30:00',
//     taskEndTime: '2024-05-30 7:55:00',
//     flow1: '11',
//     flow2: '22',
//     flow3: '35',
//     area: '1',
//     color: AppColors.eventColor6,
//   ),
// ];