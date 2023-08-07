import 'package:get/get.dart';

import '../../pages/home/home_controller.dart';
import '../../pages/profile/Profile_controller.dart';
import '../../pages/wallet/wallet_controller.dart';
import '../chat_assistance/chat_assistance_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(HomeController());
    Get.put(WalletController());
    Get.put(ProfilePageController());
    Get.put(ChatAssistanceController());
  }
}
