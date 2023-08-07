import 'package:get/get.dart';

import 'rank_system_controller.dart';

class RankSystemBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RankSystemController());
  }
}
