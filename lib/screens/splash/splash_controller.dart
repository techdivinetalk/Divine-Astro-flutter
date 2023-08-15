import 'package:get/get.dart';

import '../../common/routes.dart';
import '../../di/shared_preference_service.dart';

class SplashController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 1), () {
      if (preferenceService.getToken() == null ||
          preferenceService.getToken() == "") {
        Get.offAllNamed(RouteName.login);
      } else {
        Get.offAllNamed(RouteName.dashboard);
      }
    });
  }
}
