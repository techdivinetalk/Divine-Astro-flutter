import 'dart:developer';

import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/res_login.dart';

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
    userProfileImage.value = userData?.image ?? "";
    askPermission();
    loadPreDefineData();
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
