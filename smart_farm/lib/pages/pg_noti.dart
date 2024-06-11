import 'package:flutter/material.dart';
import 'package:smart_farm/values/app_assets.dart';
import 'package:smart_farm/values/app_colors.dart';
import 'package:smart_farm/values/app_styles.dart';
import 'package:smart_farm/data.dart';


class AppPageNoti extends StatefulWidget {
  const AppPageNoti({super.key});

  @override
  State<AppPageNoti> createState() => _AppPageNotiState();
}

class _AppPageNotiState extends State<AppPageNoti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Thông báo", style: AppStyles.title1.copyWith(color: AppColors.black, fontSize: 24)),
          leading: IconButton(
            icon: AppIcons.icArrowLeft,
            onPressed: () {
              NotificationsSingleton.instance.markedAsReadAll();
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: AppColors.lightGrey,
          toolbarHeight: 78,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: AppColors.grey,
              height: 2.0,
            ),
          )
      ),
      body: ListView(
        children: <Widget>[
          if (NotificationsSingleton.instance.getNotifications.isEmpty)
            Card(
              child: ListTile(
                title: Text('Không có thông báo', style: AppStyles.textRegular14.copyWith(color: AppColors.black, fontSize: 18)),
              ),
            ),
          for (var noti in NotificationsSingleton.instance.getNotifications.reversed)
            // A noti in form "DATETIME:MESSAGE"
            Card(
              color: noti.isRead ? AppColors.lightGrey : AppColors.grey,
              shadowColor: AppColors.grey,
              child: ListTile(
                title: Text(noti.message.split('#')[1], style: AppStyles.textSemiBold14.copyWith(color: AppColors.black, fontSize: 16)),
                subtitle: Text(noti.message.split('#')[0], style: AppStyles.textRegular14), // Replace with your variable
              ),
            ),
        ],
      ),
    );
  }
}
