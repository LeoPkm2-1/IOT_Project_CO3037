import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/data.dart';
import 'package:smart_farm/mqtt_manager.dart';
import 'package:smart_farm/pages/pg_calendar.dart';
import 'package:smart_farm/pages/pg_home.dart';
import 'package:smart_farm/pages/pg_control.dart';
import 'package:flutter/services.dart';
import 'package:smart_farm/pages/pg_main.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  MqttInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => EventDataSingleton.instance,
      child: const MyApp(),
    )
  );

  // Hide Status Bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
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

