import 'package:flutter/material.dart';
import 'package:smart_farm/pages/app_widgets.dart';

class AppPageSetting extends StatefulWidget {
  const AppPageSetting({super.key});

  @override
  State<AppPageSetting> createState() => _AppPageSettingState();
}

class _AppPageSettingState extends State<AppPageSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cài đặt"),
      body: Container(
        child: const Center(
          child: Text('Setting Page'),
        ),
      ),
    );
  }
}
