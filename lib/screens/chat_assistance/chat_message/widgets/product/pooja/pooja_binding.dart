
import "package:get/get.dart";

import "poojaDetailController.dart";

class PoojaDharamMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PoojaDharamMainController());
  }
}
