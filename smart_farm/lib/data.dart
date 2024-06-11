import 'package:flutter/widgets.dart';
import 'data_struct.dart';
import 'main.dart';

class EventDataSingleton extends ChangeNotifier {
  final List<EventStruct> _eventList = [];

  EventDataSingleton._privateConstructor();

  static final EventDataSingleton _instance = EventDataSingleton._privateConstructor();

  static EventDataSingleton get instance => _instance;

  List<EventStruct> get getEvents => _eventList;

  Future<void> addEvent(EventStruct event) async {
    int insertIndex = _eventList.indexWhere((existingEvent) => existingEvent.taskStartTime.compareTo(event.taskStartTime) > 0);
    if (insertIndex == -1) {
      _eventList.add(event);
    } else {
      _eventList.insert(insertIndex, event);
    }

    notifyListeners();
  }

  Future<void> removeEvent(String taskId) async {
    logger.i('Remove event: $taskId');
    _eventList.removeWhere((event) => event.taskId == taskId);

    notifyListeners();
  }

  String getEventBasicInfo(String taskId) {
    // Find the event with taskId and return its basic info
    EventStruct event = _eventList.firstWhere((event) => event.taskId == taskId);
    return '${event.area} - ${event.taskName}: ${event.taskStartTime} - ${event.taskEndTime}';
  }

  String getEventNameAndArea(String taskId) {
    // Find the event with taskId and return its name and area
    EventStruct event = _eventList.firstWhere((event) => event.taskId == taskId);
    return '${event.taskName} tại KV${event.area}';
  }
}

// Create a notification singleton to manage notifications, each noti is a string
class NotificationsSingleton extends ChangeNotifier {
  final List<NotiItem> _notifications = [];
  int _unreadNoti = 0;

  NotificationsSingleton._privateConstructor();

  static final NotificationsSingleton _instance = NotificationsSingleton._privateConstructor();

  static NotificationsSingleton get instance => _instance;

  List<NotiItem> get getNotifications => _notifications;
  int get getUnreadNoti => _unreadNoti;

  Future<void> addNotification(String noti) async {
    _notifications.add(NotiItem(message: noti, isRead: false));
    _unreadNoti++;
    notifyListeners();
  }

  void markedAsReadAll() {
    _unreadNoti = 0;
    for (var noti in _notifications) {
      noti.isRead = true;
    }
    notifyListeners();
  }
}