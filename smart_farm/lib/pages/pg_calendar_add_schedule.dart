import 'package:flutter/material.dart';
import 'package:smart_farm/data.dart';
import 'package:smart_farm/mqtt_manager.dart';
import 'package:smart_farm/pages/app_widgets.dart';
import 'package:smart_farm/values/app_colors.dart';
import 'package:smart_farm/values/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:smart_farm/data_struct.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _cycle = '0';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  String _flow1 = '0';
  String _flow2 = '0';
  String _flow3 = '0';
  Set<String> selectedArea = {'1'};

  void addSchedule() {
    // Add new schedule to the list
    // Save the list to SharedPreferences
    String scheduleId = CounterScheduleIdInstance().counterScheduleId.toString();
    CounterScheduleIdInstance().increment();
    final scheduleName = _title;
    final cycle = int.parse(_cycle);
    final scheduleStartTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(_startTime);
    // if cycle is 0, endtime is empty
    String scheduleEndTime = "";
    if (cycle != 0) {
      scheduleEndTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(_endTime);
    }
    final flow1 = double.parse(_flow1);
    final flow2 = double.parse(_flow2);
    final flow3 = double.parse(_flow3);
    final area = int.parse(selectedArea.first);

    print('-----------------------------------------------');
    print('scheduleId: $scheduleId');
    print('scheduleName: $scheduleName');
    print('cycle: $cycle');
    print('scheduleStartTime: $scheduleStartTime');
    print('scheduleEndTime: $scheduleEndTime');
    print('flow1: $flow1');
    print('flow2: $flow2');
    print('flow3: $flow3');
    print('area: $area');
    print('-----------------------------------------------');

    MqttInstance().mqttAddSchedule(scheduleId, scheduleName, cycle, scheduleStartTime, scheduleEndTime, flow1, flow2, flow3, area);

    // Test event
    final taskId = CounterIdInstance().counterId.toString();
    CounterIdInstance().increment();
    final taskName = scheduleName;
    final taskStartTime = scheduleStartTime;
    final taskEndTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(_startTime.add(const Duration(hours: 2)));
    final flow1E = flow1.toString();
    final flow2E = flow2.toString();
    final flow3E = flow3.toString();
    final areaE = area.toString();
    final color = AppColors.eventColor1;

    final event = EventStruct(taskId: taskId, taskName: taskName, taskStartTime: taskStartTime, taskEndTime: taskEndTime, flow1: flow1E, flow2: flow2E, flow3: flow3E, area: areaE, color: color);
    EventDataSingleton.instance.addEvent(event);
  }


  Future<DateTime?> selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) {
      return null;
    }

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm lịch tưới", style: AppStyles.title1.copyWith(color: AppColors.black, fontSize: 24)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightGrey,
        toolbarHeight: 78,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.strokeColor,
            height: 1.0,
          ),
        )
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.white,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: AppColors.darkGrey, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '1. Tiêu đề lịch',
                                style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: AppStyles.textRegular14.copyWith(fontSize: 15),
                                  textAlignVertical: TextAlignVertical.bottom,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '',
                                    hintStyle: AppStyles.textRegular14.copyWith(fontSize: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Không được trống';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value;
                                    });
                                  },
                                  initialValue: _title,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: AppColors.darkGrey, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '2. Thời gian bắt đầu',
                                style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime? selectedDateTime = await selectDateTime(context);
                                  if (selectedDateTime != null) {
                                    setState(() {
                                      _startTime = selectedDateTime;
                                      if (_endTime.isBefore(_startTime)) {
                                        _endTime = _startTime;
                                      }
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      DateFormat('dd-MM-yyyy HH:mm').format(_startTime),
                                      style: AppStyles.textRegular14.copyWith(fontSize: 15),
                                      ),
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                CustomFormField(label: '3. Chu kỳ tưới (ngày)', initialValue: _cycle, onChanged: (value) {
                  setState(() {
                    _cycle = value;
                  });
                }),
                // Add TimePicker for startTime and endTime here
                // Add TextFormField for flow1, flow2, flow3 here
                SizedBox(height: 10.0),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: AppColors.darkGrey, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '4. Kết thúc chu kỳ tưới',
                                style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? selectedDateTime = await selectDateTime(context);
                                    if (selectedDateTime != null) {
                                      setState(() {
                                        _endTime = selectedDateTime;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        DateFormat('dd-MM-yyyy HH:mm').format(_endTime),
                                        style: AppStyles.textRegular14.copyWith(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                CustomFormField(label: '5.1 Đạm (kg)', initialValue: _flow1, onChanged: (value) {
                  setState(() {
                    _flow1 = value;
                  });
                }),
                // ADD A SPACE BETWEEN FIELDS
                SizedBox(height: 10.0),
                CustomFormField(label: '5.2 Lân (kg)', initialValue: _flow2, onChanged: (value) {
                  setState(() {
                    _flow2 = value;
                  });
                }),
                SizedBox(height: 10.0),
                CustomFormField(label: '5.3 Kali (kg)', initialValue: _flow3, onChanged: (value) {
                  setState(() {
                    _flow3 = value;
                  });
                }),
                SizedBox(height: 10.0),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: AppColors.darkGrey, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '6. Khu vực tưới',
                                style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SegmentedButton(
                                  showSelectedIcon: false,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                                      return states.contains(WidgetState.selected)
                                          ? AppColors.primaryGreen
                                          : AppColors.white;
                                    }),
                                    foregroundColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                                      return states.contains(WidgetState.selected)
                                          ? AppColors.white
                                          : AppColors.black;
                                    }),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    alignment: const Alignment(0, -0.3),
                                  ),
                                  segments:
                                  const <ButtonSegment<String>>[
                                    ButtonSegment<String>(
                                      value: '1',
                                      label: Text('1', style: AppStyles.textBold14),
                                    ),
                                    ButtonSegment<String>(
                                      value: '2',
                                      label: Text('2'),
                                    ),
                                    ButtonSegment<String>(
                                      value: '3',
                                      label: Text('3'),
                                    ),
                                  ],
                                  selected: selectedArea,
                                  onSelectionChanged: (value) {
                                    setState(() {
                                      selectedArea = value;
                                    });
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Add new schedule to the list
                      // Save the list to SharedPreferences
                      addSchedule();

                      // Show a snackbar to notify the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đang xử lý')),
                      );
                    }
                  },
                  child: Text('Thêm lịch', style: AppStyles.textSemiBold14.copyWith(color: AppColors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}