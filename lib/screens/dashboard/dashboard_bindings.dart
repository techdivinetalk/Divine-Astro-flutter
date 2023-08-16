import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import '../../pages/home/home_controller.dart';
import '../../pages/profile/profile_page_controller.dart';
import '../chat_assistance/chat_assistance_controller.dart';
import '../../pages/suggest_remedies/suggest_remedies_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(HomeController());
    // Get.put(WalletController());

    Get.put(ProfilePageController(Get.put(UserRepository())));
    Get.put(ChatAssistanceController());
    Get.put(SuggestRemediesController());
  }
}
