import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController(Get.put(PreDefineRepository())));
  }
}
