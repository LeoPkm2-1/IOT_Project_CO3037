import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_farm/consts.dart';
import 'package:smart_farm/mqtt_manager.dart';
import 'package:smart_farm/values/app_colors.dart';
import 'package:smart_farm/values/app_styles.dart';
import 'package:smart_farm/values/app_assets.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:smart_farm/data_struct.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/data.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == "Home Page"
        ? RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'smart',
                style: AppStyles.title1.copyWith(color: AppColors.black),
              ),
              TextSpan(
                text: 'F',
                style: AppStyles.title1.copyWith(color: AppColors.primaryGreen),
              ),
              TextSpan(
                text: 'arm',
                style: AppStyles.title1.copyWith(color: AppColors.black),
              ),
            ]
          ),
        )
        : Text(
          title,
          style: AppStyles.title1.copyWith(color: AppColors.black, fontSize: 24),
        ),
      centerTitle: true,
      backgroundColor: AppColors.lightGrey,
      leading: IconButton(
          onPressed: () {
            // do nothing
          },
          icon: AppIcons.icMenu
      ),
      actions: [
        IconButton(
            onPressed: () {
              // do nothing
            },
            icon: AppIcons.icNoti
        ),
      ],
      toolbarHeight: 78,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.strokeColor,
          height: 1.0,
        ),
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(78.0);
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});

  BottomNavigationBarItem buildBottomNavigationBarItem(String assetName, String label, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
        child: SvgPicture.asset(
          assetName,
          height: 24,
          color: currentIndex == index ? AppColors.tabChoose : AppColors.tabUnChoose,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78.0,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryGreen,
        selectedLabelStyle: AppStyles.iconTitle.copyWith(fontSize: 16),
        unselectedLabelStyle: AppStyles.iconTitle,
        selectedItemColor: AppColors.tabChoose,
        unselectedItemColor: AppColors.tabUnChoose,
        items: [
          buildBottomNavigationBarItem('assets/icons/ic_house.svg', 'Trang chủ', 0),
          buildBottomNavigationBarItem('assets/icons/ic_screwdriver_wrench.svg', 'Điều khiển', 1),
          buildBottomNavigationBarItem('assets/icons/ic_calendar.svg', 'Lịch tưới', 2),
          buildBottomNavigationBarItem('assets/icons/ic_bugs.svg', 'Chẩn bệnh', 3),
          buildBottomNavigationBarItem('assets/icons/ic_setting.svg', 'Cài đặt', 4),
        ],
        onTap: onTap,
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _timer = Timer.periodic(const Duration(minutes: 3), (Timer t) => _fetchWeather());
  }

  Future<Position> _getCurrentLocation() async {
    // Check permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is denied forever');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  void _fetchWeather() async {
    Position position = await _getCurrentLocation();

    print('=========================Fetch weather=========================');
    print('Latitude: ${position.latitude}');
    _wf.currentWeatherByLocation(position.latitude, position.longitude).then((weather) {
      print(weather);
      setState(() {
        _weather = weather;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: double.infinity,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 4),
          child: Column(
            children: [
              Expanded(
                flex: 50,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 24,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex:1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    DateFormat.yMMMMEEEEd().format(DateTime.now()),
                                    style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _weather?.areaName ?? "null",
                                    style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                                  ),
                                ),
                              )
                            ]
                          )
                        ),
                      ),
                      Expanded(
                        flex: 36,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            _weather?.weatherDescription ?? "null",
                            style: AppStyles.textBold14.copyWith(color: AppColors.black, fontSize: 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Color(0xFFDDDDDD), height: 2),
              Expanded(
                flex: 50,
                child: Container(
                  child: Row(
                    children: [
                      // Nhiet do
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 22,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Nhiệt độ',
                                    style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 15),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 37,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      (_weather?.temperature?.celsius?.toStringAsFixed(1) ?? '?') + '°C',
                                    style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 26),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      ),

                      // Do am
                      Expanded(
                        flex: 1,
                        child: Container(
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 22,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      'Độ ẩm',
                                      style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 37,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (_weather?.humidity?.toStringAsFixed(1) ?? '?') + '%',
                                      style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 26),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),

                      // Gio
                      Expanded(
                        flex: 1,
                        child: Container(
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 22,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      'Gió',
                                      style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 37,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${_weather?.windSpeed?.toStringAsFixed(1) ?? '?'} m/s',
                                      style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 26),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ]
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      color: AppColors.primaryGreen,
      child: Image.asset(AppImages.img_hethong, fit: BoxFit.cover),
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final Color color;
  final SvgPicture icon;
  final VoidCallback onTap;
  final String label;

  const QuickAccessButton({
    required this.color,
    required this.icon,
    required this.onTap,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Expanded(
            flex: 50,
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: color,
                  child: icon,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Text(
              label,
              style: AppStyles.textRegular14.copyWith(
                color: AppColors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAccess extends StatelessWidget {
  const QuickAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      child: Row(
        children: [
          QuickAccessButton(
            color: AppColors.lightGreen,
            icon: AppIcons.icPlus,
            onTap: () => print("=======On Tap Tao Lich Tuoi========="),
            label: 'Tạo lịch tưới',
          ),
          QuickAccessButton(
            color: AppColors.lightBlue,
            icon: AppIcons.icGlassWater,
            onTap: () => print("=======On Tap Them Phan========="),
            label: 'Thêm phân',
          ),
          QuickAccessButton(
            color: AppColors.lightRed,
            icon: AppIcons.icWrench,
            onTap: () => print("=======On Tap Tuoi Thu Cong========="),
            label: 'Tưới thủ công',
          ),
          QuickAccessButton(
            color: AppColors.lightYellow,
            icon: AppIcons.icLog,
            onTap: () => print("=======On Tap Tao Lich Tuoi========="),
            label: 'Lịch sử tưới',
          ),
        ],
      ),
    );
  }
}

class ScheduledEvent extends StatefulWidget {
  const ScheduledEvent({super.key});

  @override
  State<ScheduledEvent> createState() => _ScheduledEventState();
}

class _ScheduledEventState extends State<ScheduledEvent> {
  int _displayedEventCount = 3;

  @override
  Widget build(BuildContext context) {
    final eventDataSingleton = Provider.of<EventDataSingleton>(context);

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'LỊCH TƯỚI SẮP DIỄN RA',
            style: AppStyles.title2.copyWith(color: AppColors.primaryGreen),
          ),
          Container(
            child: Column(
              children: [
                const SizedBox(height: 10),
                for (var i = 0; i < min(_displayedEventCount, eventDataSingleton.getEvents.length); ++i)
                  Column(
                    children: [
                      eventDataSingleton.getEvents[i].buildEventWidget(),
                      const SizedBox(height: 10),
                    ],
                  ),
                if (_displayedEventCount < eventDataSingleton.getEvents.length)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _displayedEventCount += 2;
                      });
                    },
                    child: Text('Xem thêm', style: AppStyles.textRegular14.copyWith(color: AppColors.black)),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MixedTankInfor extends StatefulWidget {
  const MixedTankInfor({super.key});

  @override
  State<MixedTankInfor> createState() => _MixedTankInforState();
}

class _MixedTankInforState extends State<MixedTankInfor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      child: Row(
        children: [
          Expanded(
            flex: 137,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ĐANG DIỄN RA',
                        textAlign: TextAlign.center,
                        style: AppStyles.title3.copyWith(color: AppColors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 100,
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 203,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'THÔNG TIN THÙNG TRỘN',
                        textAlign: TextAlign.center,
                        style: AppStyles.title3.copyWith(color: AppColors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: AppColors.primaryGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 90,
                                      child: Text('Lượng đạm:', textAlign: TextAlign.right, style: AppStyles.textRegular16.copyWith(color: AppColors.white)),
                                    ),
                                    Expanded(
                                      flex: 80,
                                      child: Text('8.0 kg', textAlign: TextAlign.center, style: AppStyles.textBold14.copyWith(fontSize: 16, color: AppColors.white)),
                                    )
                                  ]
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                    children: [
                                      Expanded(
                                        flex: 90,
                                        child: Text('Lượng lân:', textAlign: TextAlign.right, style: AppStyles.textRegular16.copyWith(color: AppColors.white)),
                                      ),
                                      Expanded(
                                        flex: 80,
                                        child: Text('0.7 kg', textAlign: TextAlign.center, style: AppStyles.textBold14.copyWith(fontSize: 16, color: AppColors.white)),
                                      )
                                    ]
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                    children: [
                                      Expanded(
                                        flex: 90,
                                        child: Text('Lượng kali:', textAlign: TextAlign.right, style: AppStyles.textRegular16.copyWith(color: AppColors.white)),
                                      ),
                                      Expanded(
                                        flex: 80,
                                        child: Text('12.0 kg', textAlign: TextAlign.center, style: AppStyles.textBold14.copyWith(fontSize: 16, color: AppColors.white)),
                                      )
                                    ]
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                    children: [
                                      Expanded(
                                        flex: 90,
                                        child: Text('Lượng nước:', textAlign: TextAlign.right, style: AppStyles.textRegular16.copyWith(color: AppColors.white)),
                                      ),
                                      Expanded(
                                        flex: 80,
                                        child: Text('20.0 lít', textAlign: TextAlign.center, style: AppStyles.textBold14.copyWith(fontSize: 16, color: AppColors.white)),
                                      )
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ButtonCreator extends StatefulWidget {
  final String textShow;
  final bool value;
  final Function(bool) onChanged;

  const ButtonCreator({
    required this.textShow,
    required this.value,
    required this.onChanged
  });

  @override
  State<ButtonCreator> createState() => _ButtonCreatorState();
}

class _ButtonCreatorState extends State<ButtonCreator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
          alignment: Alignment.center,
          child: Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.darkGrey, width: 3.0),
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
                padding: const EdgeInsets.only(left: 6, right: 0),
                child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          widget.textShow,
                          style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Switch(
                          value: widget.value,
                          onChanged: widget.onChanged,
                          activeTrackColor: AppColors.primaryGreen,
                          activeColor: Colors.white,
                        ),
                      )
                    ]
                ),
              )
          )
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;

  CustomFormField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    label,
                    style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: AppStyles.textRegular14.copyWith(fontSize: 15),
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: AppStyles.textRegular14.copyWith(fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        final double? number = double.tryParse(value);
                        if (number == null || number < 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                      onChanged: onChanged,
                      initialValue: initialValue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManualControl extends StatefulWidget {
  const ManualControl({super.key});

  @override
  State<ManualControl> createState() => _ManualControlState();
}

class _ManualControlState extends State<ManualControl> {

  final _formKey = GlobalKey<FormState>();
  String _flow1 = '0';
  String _flow2 = '0';
  String _flow3 = '0';

  Set<String> selectedArea = {'1'};

  void _addEventNow() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Flow 1: $_flow1');
      print('Flow 2: $_flow2');
      print('Flow 3: $_flow3');
      print('Area: $selectedArea');

      final scheduleId = CounterScheduleIdInstance().counterScheduleId.toString();
      CounterScheduleIdInstance().increment();
      final scheduleName = 'Tuoi thu cong';
      final cycle = 0;
      final scheduleStartTime = "NOW";
      final scheduleEndTime = "NOW";
      final flow1 = double.parse(_flow1);
      final flow2 = double.parse(_flow2);
      final flow3 = double.parse(_flow3);
      final area = int.parse(selectedArea.first);
      MqttInstance().mqttAddSchedule(
          scheduleId,
          scheduleName,
          cycle,
          scheduleStartTime,
          scheduleEndTime,
          flow1,
          flow2,
          flow3,
          area,
          (bool isSuccess, String? message) {}
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'ĐIỀU KHIỂN THỦ CÔNG',
            style: AppStyles.title2.copyWith(color: AppColors.primaryGreen),
          ),
          Container(
            height: 164,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomFormField(
                                label: '1. Đạm (kg)',
                                initialValue: _flow1,
                                onChanged: (String value) {
                                  _flow1 = value == '' ? '0' : value;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomFormField(
                                label: '2. Lân (kg)',
                                initialValue: _flow2,
                                onChanged: (String value) {
                                  _flow2 = value == '' ? '0' : value;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomFormField(
                                label: '3. Kali (kg)',
                                initialValue: _flow3,
                                onChanged: (String value) {
                                  _flow3 = value == '' ? '0' : value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 102,
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
                                    child: Column(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '4. Khu vực tưới',
                                                style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0.0, left: 6.0, right: 6.0, bottom: 6.0),
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
                                                    alignment: const Alignment(0, 0.3),
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
                                            ),
                                          ),
                                        ]
                                    )
                                )
                            ),
                          ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            width: 110,
                            height: 20,
                            child: ElevatedButton(
                              onPressed: _addEventNow,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryGreen),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              child: Text('5. Tưới', style: AppStyles.textRegular14.copyWith(color: AppColors.white, fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }
}


class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        child: SfCalendar(
          view: CalendarView.schedule,
          showTodayButton: true,
          allowViewNavigation: true,
          allowedViews: const <CalendarView>[
            CalendarView.schedule,
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
          ],
          headerDateFormat: 'MM/yyyy',
          headerStyle: CalendarHeaderStyle(
            textAlign: TextAlign.left,
            backgroundColor: AppColors.white,
            textStyle: AppStyles.textBold14.copyWith(color: AppColors.black),
          ),

          scheduleViewSettings: ScheduleViewSettings(
            appointmentItemHeight: 90,
            hideEmptyScheduleWeek: false,
            weekHeaderSettings: WeekHeaderSettings(
              startDateFormat: 'Tuần dd/MM',
              endDateFormat: ' dd/MM',
              height: 30,
              backgroundColor: AppColors.grey,
              textAlign: TextAlign.center,
              weekTextStyle: AppStyles.textRegular14.copyWith(color: AppColors.black),
            ),
            monthHeaderSettings: MonthHeaderSettings(
              height: 70,
              monthFormat: 'MM/yyyy',
              backgroundColor: AppColors.white,
              textAlign: TextAlign.left,
              monthTextStyle: AppStyles.textBold14.copyWith(fontSize: 20, color: AppColors.black),
            ),
          ),
          firstDayOfWeek: 1,
          todayHighlightColor: AppColors.primaryGreen,
          dataSource: EventDataSource(getAppointment(context)),

          appointmentBuilder: appointmentBuilder,
        ),
      ),
    );
  }
}

Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
  final appointment = calendarAppointmentDetails.appointments.first;
  // i want the appointment show Subject \n StartTime - EndTime \n Notes, and clickable
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800, maxHeight: 470),
                child: AlertDialog(
                  contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
                  titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
                  title: Text(
                      'Chi tiết lịch tưới',
                      style: AppStyles.textBold14.copyWith(fontSize: 20, color: AppColors.black),
                      textAlign: TextAlign.center,
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tên lịch:', style: AppStyles.textBold14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${appointment.subject.split(' - ')[1]}', style: AppStyles.textRegular14, textAlign: TextAlign.right)
                      ),
                      const SizedBox(height: 10),
                      Text('Thời gian bắt đầu:', style: AppStyles.textBold14),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('${DateFormat('HH:mm:ss dd/MM/yyyy').format(appointment.startTime)}', style: AppStyles.textRegular14, textAlign: TextAlign.right)
                      ),
                      const SizedBox(height: 10),
                      Text('Thời gian kết thúc:', style: AppStyles.textBold14),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('${DateFormat('HH:mm:ss dd/MM/yyyy').format(appointment.endTime)}', style: AppStyles.textRegular14, textAlign: TextAlign.right)
                      ),
                      const SizedBox(height: 10),
                      Text('Khu vực:', style: AppStyles.textBold14),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('${appointment.subject.split(' - ')[0]}', style: AppStyles.textRegular14, textAlign: TextAlign.right)
                      ),
                      const SizedBox(height: 10),
                      Text('Lượng tưới:', style: AppStyles.textBold14),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('${appointment.notes}', style: AppStyles.textRegular14, textAlign: TextAlign.right)
                      ),
                    ],
                  ),
                  // scrollable: true,
                  actionsPadding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Delete the appointment
                        MqttInstance().mqttRemoveTask(appointment.id);
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryGreen),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text('Xóa lịch', style: AppStyles.textSemiBold14.copyWith(color: AppColors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryGreen),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text('Đóng', style: AppStyles.textSemiBold14.copyWith(color: AppColors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
      );
    },
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: appointment.color,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appointment.subject,
                  style: AppStyles.textBold14.copyWith(color: AppColors.white),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Row(
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset('assets/icons/ic_clock.svg', height: 20, color: AppColors.white,)
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${DateFormat('HH:mm:ss').format(appointment.startTime)} - ${DateFormat('HH:mm:ss').format(appointment.endTime)}',
                        style: AppStyles.textRegular14.copyWith(color: AppColors.white),
                      ),
                    ]
                )
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appointment.notes,
                  style: AppStyles.textRegular14.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<Appointment> getAppointment(BuildContext context) {
  final List<Appointment> events = <Appointment>[];
  // Convert all data from EventDataSingleton to Appointment
  final eventDataSingleton = Provider.of<EventDataSingleton>(context);
  for (var i = 0; i < eventDataSingleton.getEvents.length; ++i) {
    final event = eventDataSingleton.getEvents[i];
    final eventId = event.taskId;
    final startTime = DateTime.parse(event.taskStartTime);
    final endTime = DateTime.parse(event.taskEndTime);
    final subject = 'Khu vực ${event.area} - ${event.taskName}';
    final notes = 'Đạm: ${event.flow1}kg; Lân: ${event.flow2}kg; Kali: ${event.flow3}kg';
    final color = event.color;
    final appointment = Appointment(
      id: eventId,
      startTimeZone: 'SE Asia Standard Time',
      endTimeZone: 'SE Asia Standard Time',
      startTime: startTime,
      endTime: endTime,
      subject: subject,
      notes: notes,
      color: color,
    );
    events.add(appointment);
  }
  return events;
}

// when tap on the Appointment, show the detail of the event


class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
