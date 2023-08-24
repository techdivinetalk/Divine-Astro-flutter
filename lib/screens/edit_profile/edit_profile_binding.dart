import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import 'edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditProfileController(Get.put(UserRepository())));
  }
}
