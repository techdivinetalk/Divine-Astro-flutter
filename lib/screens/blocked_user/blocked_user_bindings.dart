import 'package:get/get.dart';

import 'block_user_controller.dart';

class BlockedUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BlockUserController());
  }
}
