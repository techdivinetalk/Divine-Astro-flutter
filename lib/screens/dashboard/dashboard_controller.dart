import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common_functions.dart';
import '../../di/api_provider.dart';
import '../../di/fcm_notification.dart';
import '../../di/hive_services.dart';
import '../../model/res_login.dart';
import '../live_page/constant.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PreDefineRepository repository;

  DashboardController(this.repository);

  RxInt selectedIndex = 0.obs;
  RxString userProfileImage = " ".obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  UserData? userData;

  @override
  void onInit() {
    super.onInit();
    userData = preferenceService.getUserDetail();
    userProfileImage.value = "${ApiProvider.imageBaseUrl} ${userData?.image}";
    askPermission();
    loadPreDefineData();
    firebaseMessagingConfig(Get.context!);
  }

  @override
  void onReady() {
    super.onReady();
    checkNotification();
    getHiveDatabase();
  }

  void getHiveDatabase() async {
    // At Login to set data
    // HiveServices hiveServices = HiveServices(boxName: userChatData);
    // await hiveServices.initialize();
  }

  void askPermission() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  void loadPreDefineData() async {
    SpecialityList response = await repository.loadPreDefineData();
    await preferenceService.setSpecialAbility(response.toPrettyJson());
  }
}
