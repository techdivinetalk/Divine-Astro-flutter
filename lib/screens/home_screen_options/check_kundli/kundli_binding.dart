import 'package:get/get.dart';

import 'kundli_controller.dart';

class KundliBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KundliController());
  }
}
