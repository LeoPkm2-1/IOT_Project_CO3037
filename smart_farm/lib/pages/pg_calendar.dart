import 'package:flutter/material.dart';
import 'package:smart_farm/pages/app_widgets.dart';
import 'package:smart_farm/values/app_assets.dart';
import 'package:smart_farm/values/app_colors.dart';
import 'package:smart_farm/pages/pg_calendar_add_schedule.dart';


class AppPageCalendar extends StatefulWidget {
  const AppPageCalendar({super.key});

  @override
  State<AppPageCalendar> createState() => _AppPageCalendarState();
}

class _AppPageCalendarState extends State<AppPageCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Lịch tưới"),
      body: Container(
        child: CalendarWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSchedule()),
          );
        },
        child: AppIcons.icPlus,
        backgroundColor: AppColors.primaryGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
