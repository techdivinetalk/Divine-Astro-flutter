import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/res_login.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt selectedIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  DashboardController();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  UserData? userData;

  @override
  void onInit() {
    super.onInit();
    userData = preferenceService.getUserDetail();
  }
}
