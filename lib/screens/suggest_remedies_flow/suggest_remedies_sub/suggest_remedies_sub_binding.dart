import 'package:divine_astrologer/repository/shop_repository.dart';
import 'package:get/get.dart';

import 'suggest_remedies_sub_controller.dart';

class SuggestRemediesSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SuggestRemediesSubController(Get.put(ShopRepository())));
  }
}
