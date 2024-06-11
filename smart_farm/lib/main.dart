import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/data.dart';
import 'package:smart_farm/mqtt_manager.dart';
import 'package:smart_farm/pages/pg_calendar.dart';
import 'package:smart_farm/pages/pg_home.dart';
import 'package:smart_farm/pages/pg_control.dart';
import 'package:flutter/services.dart';
import 'package:smart_farm/pages/pg_main.dart';
import 'package:logger/logger.dart';

var logger = Logger();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  MqttInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EventDataSingleton>(
          create: (context) => EventDataSingleton.instance,
        ),
        ChangeNotifierProvider<NotificationsSingleton>(
          create: (context) => NotificationsSingleton.instance,
        ),
      ],
      child: const MyApp(),
    ),
  );

  // Hide Navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: [SystemUiOverlay.top]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: MainPage(),
    );
  }
}

