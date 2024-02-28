import "package:get/get.dart";

import "pooja_dharam_details_controller.dart";

class PoojaDharamDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(PoojaDharamDetailsController.new);
  }
}
