import 'dart:convert';

import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';
import '../../di/shared_preference_service.dart';

class SplashController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  Future<void> onInit() async {
    super.onInit();
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    navigation();
  }



  final repository = Get.put(UserRepository());

  void navigation() async {
    if (preferenceService.getToken() == null ||
        preferenceService.getToken() == "") {
      await getInitialLoginImages().then(
        (value) async => await preferenceService
            .saveLoginImages(jsonEncode(value.toJson()))
            .then((value) => Get.offAllNamed(RouteName.login)),
      );
    } else {
     // final socket = AppSocket();
    //  final appFirebaseService = AppFirebaseService();
    //  socket.socketConnect();
    //  debugPrint('preferenceService.getUserDetail()!.id ${preferenceService.getUserDetail()!.id}');
     // appFirebaseService.readData('astrologer/${preferenceService.getUserDetail()!.id}/realTime');
      Future.delayed(
        const Duration(seconds: 1),
        () => Get.offAllNamed(RouteName.dashboard),
      );
    }
  }

  Future<LoginImages> getInitialLoginImages() async {
    final response = await repository.getInitialLoginImages();
    return response;
  }
}
