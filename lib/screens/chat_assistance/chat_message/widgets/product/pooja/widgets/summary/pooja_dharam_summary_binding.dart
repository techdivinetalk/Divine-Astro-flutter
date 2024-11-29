
import "package:get/get.dart";

import "pooja_dharam_summary_controller.dart";

class PoojaDharamSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(PoojaDharamSummaryController.new);
  }
}
