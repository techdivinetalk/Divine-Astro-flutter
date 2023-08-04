import 'package:get/get.dart';

import 'price_history_controller.dart';

class PriceHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PriceHistoryController());
  }
}
