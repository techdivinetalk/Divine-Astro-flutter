import 'package:get/get.dart';

import 'BlockUserController.dart';

class BlockedUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BlockUserController());
  }
}
