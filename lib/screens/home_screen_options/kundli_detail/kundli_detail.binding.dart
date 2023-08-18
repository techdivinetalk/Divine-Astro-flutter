import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:get/get.dart';

import 'kundli_detail_controller.dart';

class KundliDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KundliDetailController(Get.put(KundliRepository())));
  }
}
