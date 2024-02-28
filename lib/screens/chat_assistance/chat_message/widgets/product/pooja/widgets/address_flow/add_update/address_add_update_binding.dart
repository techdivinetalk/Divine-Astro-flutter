import "package:get/get.dart";

import "address_add_update_controller.dart";

class AddressAddUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AddressAddUpdateController.new);
  }
}
