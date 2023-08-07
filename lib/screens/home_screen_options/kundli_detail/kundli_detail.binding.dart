import 'package:get/get.dart';

import 'kundli_detail_controller.dart';

class KundliDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KundliDetailController());
  }
}
