import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_farm/values/app_colors.dart';

class AppImages {
  static const String imagePath = 'assets/images/';
  static const String img_hethong = '${imagePath}img_hethong.png';
  static String get img_upload => '${imagePath}img_upload.png';
}

class AppAIModel {
  static const String modelPath = 'assets/ai_model/';
  static const String ai_labelPath = '${modelPath}labels.txt';
  static const String ai_modelPath = '${modelPath}model_unquant.tflite';
}

class AppIcons {
  static final icHome = SvgPicture.asset('assets/icons/ic_house.svg', height: 26, color: AppColors.white);
  static final icControl = SvgPicture.asset('assets/icons/ic_screwdriver_wrench.svg', height: 26, color: AppColors.white);
  static final icCalendar = SvgPicture.asset('assets/icons/ic_calendar.svg', height: 26, color: AppColors.white);
  static final icBugs = SvgPicture.asset('assets/icons/ic_bugs.svg', height: 26, color: AppColors.white);
  static final icSetting = SvgPicture.asset('assets/icons/ic_setting.svg', height: 26, color: AppColors.white);

  static final icMenu = SvgPicture.asset('assets/icons/ic_bars.svg', height: 26, color: AppColors.black);
  static final icNoti = SvgPicture.asset('assets/icons/ic_bell.svg', height: 26, color: AppColors.black);

  static final icAngleDown = SvgPicture.asset('assets/icons/ic_angle_down.svg', height: 26, color: AppColors.white);
  static final icCamera = SvgPicture.asset('assets/icons/ic_camera.svg', height: 26, color: AppColors.white);
  static final icFind = SvgPicture.asset('assets/icons/ic_find.svg', height: 26, color: AppColors.white);
  static final icGlassWater = SvgPicture.asset('assets/icons/ic_glass_water.svg', height: 26, color: AppColors.white);
  static final icLog = SvgPicture.asset('assets/icons/ic_log.svg', height: 26, color: AppColors.white);
  static final icPlus = SvgPicture.asset('assets/icons/ic_plus.svg', height: 26, color: AppColors.white);
  static final icWrench = SvgPicture.asset('assets/icons/ic_wrench.svg', height: 26, color: AppColors.white);
  static final icClock = SvgPicture.asset('assets/icons/ic_clock.svg', height: 20, color: AppColors.white);

  static final icImage = SvgPicture.asset('assets/icons/ic_image_solid.svg', height: 26, color: AppColors.black);
  static final icExit = SvgPicture.asset('assets/icons/ic_exit.svg', height: 26, color: AppColors.black);
  static final icArrowLeft = SvgPicture.asset('assets/icons/ic_arrow_left.svg', height: 26, color: AppColors.black);
}