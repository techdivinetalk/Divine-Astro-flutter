import 'package:get/get.dart';

import 'performance_controller.dart';

class PerformanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PerformanceController());
  }
}
