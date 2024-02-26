
import "package:get/get.dart";

import "address_view_controller.dart";

class AddressViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AddressViewController.new);
  }
}
