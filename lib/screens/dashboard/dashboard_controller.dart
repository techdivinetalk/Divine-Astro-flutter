import 'dart:async';

import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common_functions.dart';
import '../../di/api_provider.dart';
import '../../di/fcm_notification.dart';
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
  StreamSubscription<DatabaseEvent>? notiticationCheck;

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
    notiticationCheck ??= FirebaseDatabase.instance
        .ref("astrologer/${userData?.id}/realTime/notification")
        .onValue
        .listen((event) {
      debugPrint("Your event $event");
      checkNotification();
      debugPrint("Value has been updated: ${event.snapshot.value}");
    });
  }

  void askPermission() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  @override
  void onClose() {
    super.onClose();
    if (notiticationCheck != null) {
      notiticationCheck!.cancel();
    }
  }

  void loadPreDefineData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    SpecialityList response = await repository.loadPreDefineData();
    await preferenceService.setSpecialAbility(response.toPrettyJson());
  }
}
