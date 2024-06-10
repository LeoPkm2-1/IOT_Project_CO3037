import 'package:flutter/material.dart';
import 'package:smart_farm/mqtt_manager.dart';
import 'package:smart_farm/pages/app_widgets.dart';
import 'package:smart_farm/pages/pg_home.dart';
import 'package:smart_farm/pages/pg_control.dart';
import 'package:smart_farm/pages/pg_calendar.dart';
import 'package:smart_farm/pages/pg_ai.dart';
import 'package:smart_farm/pages/pg_setting.dart';
import 'package:smart_farm/consts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AppPageHome(),
    AppPageControl(),
    AppPageCalendar(),
    AppPageAI(),
    AppPageSetting(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
