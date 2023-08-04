import 'package:get/get.dart';

import 'earning_controller.dart';

class YourEarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(YourEarningController());
  }
}
