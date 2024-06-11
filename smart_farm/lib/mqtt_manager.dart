import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_farm/main.dart';
import 'package:smart_farm/values/app_styles.dart';
import 'consts.dart';
import 'dart:convert';
import 'package:smart_farm/data.dart';
import 'data_struct.dart';
import 'values/app_colors.dart';


class MqttManager {
  MqttServerClient? client;

  final String serverURI;
  final String username;
  final String password;
  final String id;
  final List<String> feeds;

  // Callback Function pointer
  Function onConnectedCb;
  Function onDisconnectedCb;
  Function(String) onSubscribedCb;
  Function(String, String) onMessageCb;

  MqttManager({
    required this.serverURI,
    required this.username,
    required this.password,
    required this.id,
    required this.feeds,

    // Callback functions
    this.onConnectedCb = onConnectedDefault,
    this.onDisconnectedCb = onDisconnectedDefault,
    this.onSubscribedCb = onSubscribedDefault,
    this.onMessageCb = messageReceivedDefault,
  });

  Future<void> connect() async {
    client = MqttServerClient(serverURI, username);
    client!.logging(on: false);
    client!.keepAlivePeriod = 20;

    // Setup the callback methods
    client!.onConnected = () => onConnectedCb();
    client!.onDisconnected = () => onDisconnectedCb();
    client!.onSubscribed = (String topic) => onSubscribedCb(topic);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(id)
        .startClean() // Non persistent session for testing
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .withWillQos(MqttQos.atLeastOnce)
        .authenticateAs(username, password);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
    } catch (e) {
      logger.i('Exception: $e');
      client!.disconnect();
    }

    // Check if we are connected
    if (client!.connectionStatus?.state == MqttConnectionState.connected) {
      logger.i('MQTT client connected');

      // Subscribe to the topics
      subscribeToTopics();

      // Set up a listener for incoming messages
      setupMessageListener();
    } else {
      logger.i('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client!.connectionStatus?.state}');
      client!.disconnect();
    }
  }

  void subscribeToTopics() {
    for (var feed in feeds) { client!.subscribe(feed, MqttQos.atLeastOnce); }
  }

  void setupMessageListener() {
    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      // Call the callback function
      onMessageCb(c[0].topic, pt);
    });
  }

  static void onConnectedDefault() { logger.i('Default Func: Connected'); }
  static void onDisconnectedDefault() { logger.i('Default Func: Disconnected'); }
  static void onSubscribedDefault(String topic) { logger.i('Default Func: Subscribed topic: $topic'); }
  static void messageReceivedDefault(String topic, String message) {
    logger.i('Default Func: Received message from $topic: $message');}

  void publish(String topic, String message, bool retainval) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: retainval);
  }
}

class CounterIdInstance {
  // Singleton instance
  int _counterId = 0;

  CounterIdInstance._privateConstructor();

  static final CounterIdInstance _instance = CounterIdInstance._privateConstructor();

  factory CounterIdInstance() {
    return _instance;
  }

  int get counterId => _counterId;

  void increment() {
    _counterId++;
  }
}
// commandId = CounterIdInstance().counterId.toString();
class CounterScheduleIdInstance {
  // Singleton instance
  int _counterScheduleId = 0;

  CounterScheduleIdInstance._privateConstructor();

  static final CounterScheduleIdInstance _instance = CounterScheduleIdInstance._privateConstructor();

  factory CounterScheduleIdInstance() {
    return _instance;
  }

  int get counterScheduleId => _counterScheduleId;

  void increment() {
    _counterScheduleId++;
  }
}

class MqttInstance extends ChangeNotifier {
  late MqttManager myMqtt;
  late Function(bool, String?) _onAddScheduleResult;

  MqttInstance._() {
    myMqtt = MqttManager(
      serverURI: 'io.adafruit.com',
      username: ADAFRUIT_IO_USERNAME,
      password: ADAFRUIT_IO_PASSWORD,
      id: 'SmartFarmApp',
      feeds: [LISTEN_IOT_GATE, RESPONSE_IOT_GATE],
      onConnectedCb: () => logger.i('Connected to MQTT'),
      onDisconnectedCb: () => logger.i('Disconnected from MQTT'),
      onSubscribedCb: (String topic) => logger.i('Subscribed to $topic'),
      onMessageCb: mqttOnMessage,
    );
    myMqtt.connect();
  }

  // Singleton instance
  static final MqttInstance _instance = MqttInstance._();

  // Factory constructor
  factory MqttInstance() => _instance;

  void publish(String message) {
    logger.i('Publishing message: $message');
    myMqtt.publish(LISTEN_IOT_GATE, message, true);
  }

  void mqttAddSchedule(
      String scheduleId,
      String scheduleName,
      int cycle,
      String scheduleStartTime,
      String scheduleEndTime,
      double flow1,
      double flow2,
      double flow3,
      int area,
      Function(bool, String?) onResult
      ) {

    final commandId = CounterIdInstance().counterId.toString();
    CounterIdInstance().increment();

    final command = {
      'command': 'ADD_SCHEDULE',
      'commandId': commandId,
      'payload': {
        'scheduleId': scheduleId,
        'scheduleName': scheduleName,
        'cycle': cycle.toString(),
        'scheduleStartTime': scheduleStartTime,
        'scheduleEndTime': cycle == 0 ? '' : scheduleEndTime,
        'flow1': flow1.toString(),
        'flow2': flow2.toString(),
        'flow3': flow3.toString(),
        'area': area.toString(),
      },
    };

    final message = jsonEncode(command);
    publish(message);

    _onAddScheduleResult = onResult;
  }

  void mqttGetTask(String taskId) {
    final commandId = CounterIdInstance().counterId.toString();
    CounterIdInstance().increment();

    final command = {
      'command': 'GET_TASK',
      'commandId': commandId,
      'payload': {
        'taskId': taskId,
      },
    };

    final message = jsonEncode(command);
    publish(message);
  }

  void mqttRemoveTask(String taskId) {
    final commandId = CounterIdInstance().counterId.toString();
    CounterIdInstance().increment();

    final command = {
      'command': 'REMOVE_TASK',
      'commandId': commandId,
      'payload': {
        'taskId': taskId,
      },
    };

    final message = jsonEncode(command);
    publish(message);
  }

  void mqttOnMessage(String topic, String message) {
    logger.i('Received message from $topic: $message');

    // Message return in a JSON format
    final Map<String, dynamic> data = jsonDecode(message);
    // Might be there no status key
    final String status = data.containsKey('status') ? data['status'] : 'NO_STATUS';
    final String command = data['command'];

    if (command == 'ADD_SCHEDULE') {
      if (status == 'NO_STATUS') {
        logger.i('Confirm successful: $message');
      } else if (status == 'SUCCESS') {
        // {
        // "status": "SUCCESS",
        // "commandId": "2",
        // "command": "ADD_SCHEDULE",
        // "message": "Insert schedule succesfully, the tasks id are",
        // "payload": ["0_1_2024_06_10_22_42_52_252785", "1_1_2024_06_10_22_42_52_252785", "2_1_2024_06_10_22_42_52_252785", "3_1_2024_06_10_22_42_52_252785"]
        // }
        final List<String> taskIds = List<String>.from(data['payload'].map((item) => item.toString()));
        logger.i('-----SUCCESS: Insert schedule successfully, the tasks id are');
        for (var taskId in taskIds) {
          logger.i('-----Task ID: $taskId');
          MqttInstance().mqttGetTask(taskId);
        }

        _onAddScheduleResult(true, null);

      } else if (status == 'ERROR') {
        // {
        // "status": "ERROR",
        // "commandId": "0",
        // "command": "ADD_SCHEDULE",
        // "message": "start time and end time not true",
        // "payload": {
        //   "scheduleId": "0",
        //   "scheduleName": "Schde 0",
        //   "cycle": "2",
        //   "scheduleStartTime": "2024-06-10 23:00:00",
        //   "scheduleEndTime": "2024-06-10 23:00:00",
        //   "flow1": "2.0",
        //   "flow2": "2.0",
        //   "flow3": "3.0",
        //   "area": "2"
        //   }
        // }


        // {
        //   "status": "ERROR",
        //   "commandId": "5",
        //   "command": "ADD_SCHEDULE",
        //   "message": "Schedule conflict with following tasks",
        //   "payload": ["0_0_2024_06_10_23_17_31_721889"]
        // }
        if (data['message'] == 'start time and end time not true') {
          logger.i('-----ERROR: Start time and end time not true');

          _onAddScheduleResult(false, 'Thời gian bắt đầu và kết thúc không hợp lệ');
        } else if (data['message'] == 'Schedule conflict with following tasks') {
          logger.i('-----ERROR: Schedule conflict with following tasks');

          final conflictTaskId = data['payload'][0];
          // Get the task name and time in EventDataSingleton
          final conflictTaskInfo = EventDataSingleton.instance.getEventBasicInfo(conflictTaskId);

          _onAddScheduleResult(false, 'Trùng lịch $conflictTaskInfo');
        }

        logger.i('-----ERROR: ${data['message']}');
      }
    }

    if (command == 'GET_TASK') {
      if (status == 'NO_STATUS') {
        // {
        // "command": "GET_TASK",
        // "commandId": "2",
        // "payload": {
        //   "taskId": "0_1_2024_06_10_23_05_37_049818"
        //   }
        // }
        logger.i('Confirm successful: $message');
      } else if (status == 'SUCCESS') {
        // {
        // "status": "SUCCESS",
        // "commandId": "2",
        // "command": "GET_TASK",
        // "message": "get task success",
        // "payload": {
        //   "taskId": "0_1_2024_06_10_23_05_37_049818",
        //   "scheduleId": "1",
        //   "scheduleName": "scjhkjasf dfsdjkddf",
        //   "cycle": 1,
        //   "flow1": 1.0,
        //   "flow2": 2.0,
        //   "flow3": 3.0,
        //   "area": 1,
        //   "startAt": "2024-06-11 07:00:00",
        //   "endAt": "2024-06-11 07:00:06",
        //   "presentStatus": "WAITING"
        //   }
        // }

        // Add event to EventDataSingleton
        final taskId = data['payload']['taskId'];
        final taskName = data['payload']['scheduleName'];
        final taskStartTime = data['payload']['startAt'];
        final taskEndTime = data['payload']['endAt'];
        final flow1E = data['payload']['flow1'].toString();
        final flow2E = data['payload']['flow2'].toString();
        final flow3E = data['payload']['flow3'].toString();
        final areaE = data['payload']['area'].toString();
        // Random color from 0 to 11 (12 colors)
        final color = AppColors.eventColorLists[taskId.hashCode % 12];

        final event = EventStruct(taskId: taskId, taskName: taskName, taskStartTime: taskStartTime, taskEndTime: taskEndTime, flow1: flow1E, flow2: flow2E, flow3: flow3E, area: areaE, color: color);
        EventDataSingleton.instance.addEvent(event);
      }
    }

    if (command == 'REMOVE_TASK') {
      if (status == 'NO_STATUS') {
        logger.i('Confirm successful: $message');
      } else if (status == 'SUCCESS') {
        // {
        //   "status": "SUCCESS",
        //   "commandId": "5",
        //   "command": "REMOVE_TASK",
        //   "message": "delete complete task 2_0_2024_06_11_00_19_07_092053",
        //   "payload": ""
        // }
        final taskId = data['message'].split(' ')[3];
        EventDataSingleton.instance.removeEvent(taskId);
        logger.i('-----SUCCESS: Remove task success');

        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Xóa lịch thành công', style: AppStyles.textRegular14.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (status == 'ERROR') {
        // {
        //   "status": "ERROR",
        //   "commandId": "2",
        //   "command": "REMOVE_TASK",
        //   "message": "task with id 0_0_2024_06_11_10_15_50_363476 is running so not remove",
        //   "payload": ""
        // }
        logger.i('-----ERROR remove task');
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Xóa lịch thất bại (lịch đã thực thi)', style: AppStyles.textRegular14.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    if (command == 'TASK_RUNNING') {
      // {
      //   "status": "SUCCESS",
      //   "commandId": "",
      //   "command": "TASK_RUNNING",
      //   "message": "Task with the following id is running",
      //   "payload": "0_0_2024_06_11_10_15_50_363476"
      // }
      // noti in form "daytime# message" the datetime in form "HH:MM:SS DD/MM/YYYY"
      // Message in form "Bắt đầu lịch: $taskName tại $area"
      logger.i('-----TASK_RUNNING: Task with the following id is running');
      final taskId = data['payload'];
      final taskName = EventDataSingleton.instance.getEventNameAndArea(taskId);
      String newNoti = '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}#Bắt đầu lịch: $taskName';

      NotificationsSingleton.instance.addNotification(newNoti);
    }
  }

  MqttManager get mqtt => myMqtt;
}







