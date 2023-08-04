import 'package:divine_astrologer/screens/pages/home/home_controller.dart';
import 'package:get/get.dart';

import '../wallet/wallet_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(HomeController());
    Get.put(WalletController());
  }
}
