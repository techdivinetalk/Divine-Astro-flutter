import 'dart:convert';

import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';
import '../../di/shared_preference_service.dart';

class SplashController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  void onInit() {
    super.onInit();
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
