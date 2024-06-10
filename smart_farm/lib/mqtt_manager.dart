import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';
import 'consts.dart';
import 'dart:convert';


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
      print('Exception: $e');
      client!.disconnect();
    }

    // Check if we are connected
    if (client!.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT client connected');

      // Subscribe to the topics
      subscribeToTopics();

      // Set up a listener for incoming messages
      setupMessageListener();
    } else {
      print('ERROR: MQTT client connection failed - '
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

  static void onConnectedDefault() { print('Default Func: Connected'); }
  static void onDisconnectedDefault() { print('Default Func: Disconnected'); }
  static void onSubscribedDefault(String topic) { print('Default Func: Subscribed topic: $topic'); }
  static void messageReceivedDefault(String topic, String message) {
    print('Default Func: Received message from $topic: $message');}

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

  List<String> _fiveLastMessages = [];

  MqttInstance._() {
    myMqtt = MqttManager(
      serverURI: 'io.adafruit.com',
      username: ADAFRUIT_IO_USERNAME,
      password: ADAFRUIT_IO_PASSWORD,
      id: 'SmartFarmApp',
      feeds: [LISTEN_IOT_GATE, RESPONSE_IOT_GATE],
      onConnectedCb: () => print('Connected to MQTT'),
      onDisconnectedCb: () => print('Disconnected from MQTT'),
      onSubscribedCb: (String topic) => print('Subscribed to $topic'),
      onMessageCb: mqttOnMessage,
    );
    myMqtt.connect();
  }

  // Singleton instance
  static final MqttInstance _instance = MqttInstance._();

  // Factory constructor
  factory MqttInstance() => _instance;

  void publish(String message) {
    print('Publishing message: $message');
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
      int area) {
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
        'scheduleEndTime': scheduleEndTime,
        'flow1': flow1.toString(),
        'flow2': flow2.toString(),
        'flow3': flow3.toString(),
        'area': area.toString(),
      },
    };

    final message = jsonEncode(command);
    publish(message);

    // Save the last 5 messages
    if (_fiveLastMessages.length >= 5) {
      _fiveLastMessages.removeAt(0);
    }
    _fiveLastMessages.add(message);
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

    // Save the last 5 messages
    if (_fiveLastMessages.length >= 5) {
      _fiveLastMessages.removeAt(0);
    }
    _fiveLastMessages.add(message);
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

    // Save the last 5 messages
    if (_fiveLastMessages.length >= 5) {
      _fiveLastMessages.removeAt(0);
    }
    _fiveLastMessages.add(message);
  }

  void mqttOnMessage(String topic, String message) {
    print('Received message from $topic: $message');
  }

  MqttManager get mqtt => myMqtt;
}




