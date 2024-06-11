import 'package:flutter/material.dart';
import 'package:smart_farm/pages/app_widgets.dart';

class AppPageControl extends StatefulWidget {
  const AppPageControl({super.key});

  @override
  State<AppPageControl> createState() => _AppPageControlState();
}

class _AppPageControlState extends State<AppPageControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Điều khiển"),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: StatusWidget(),
          ),

          Divider(color: Color(0xFFDDDDDD), height: 2, thickness: 2),

          // Container(
          //   color: AppColors.lightGrey,
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
          //     child: MixedTankInfor(),
          //   ),
          // ),

          // const Divider(color: Color(0xFFDDDDDD), height: 2, thickness: 2),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: ManualControl(),
          ),

          Divider(color: Color(0xFFDDDDDD), height: 2, thickness: 2),
        ]
      ),
    );
  }
}
