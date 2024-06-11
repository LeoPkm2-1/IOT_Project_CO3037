import 'package:flutter/material.dart';
import 'package:smart_farm/pages/app_widgets.dart';
import 'package:smart_farm/values/app_styles.dart';

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
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Ngôn ngữ', style: AppStyles.textSemiBold14.copyWith(color: Colors.black, fontSize: 18)),
              subtitle: const Text('Tiếng Việt', style: AppStyles.textRegular14), // Replace with your variable
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Navigate to Language settings page
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Phiên bản ứng dụng', style: AppStyles.textSemiBold14.copyWith(color: Colors.black, fontSize: 18)),
              subtitle: const Text('1.0.0', style: AppStyles.textRegular14), // Replace with your variable
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // Navigate to App Version page
              },
            ),
          ),
          // Add more cards for more settings
        ],
      ),
    );
  }
}