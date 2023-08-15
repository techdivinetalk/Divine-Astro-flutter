import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import 'block_user_controller.dart';

class BlockedUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BlockUserController(Get.put(UserRepository())));
  }
}
