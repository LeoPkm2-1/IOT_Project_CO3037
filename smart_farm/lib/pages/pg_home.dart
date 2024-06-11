import 'package:flutter/material.dart';
import 'package:smart_farm/pages/app_widgets.dart';
import 'package:smart_farm/values/app_colors.dart';

class AppPageHome extends StatefulWidget {
  const AppPageHome({super.key});

  @override
  State<AppPageHome> createState() => _AppPageHomeState();
}

class _AppPageHomeState extends State<AppPageHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Home Page"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,

                // Stroke
                border: Border.all(color: AppColors.strokeColor, strokeAlign: BorderSide.strokeAlignOutside, width: 2.0),

                // Shadow
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const WeatherWidget()
            ),
          ),

          const Divider(color: Color(0xFFDDDDDD), height: 2, thickness: 2),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: StatusWidget(),
          ),

          const Divider(color: Color(0xFFDDDDDD), height: 2, thickness: 2),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: QuickAccess(),
          ),

          const Divider(color: Color(0xFFDDDDDD), height: 2, thickness: 2),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: ScheduledEvent(),
          ),
        ],
      ),
    );
  }
}
