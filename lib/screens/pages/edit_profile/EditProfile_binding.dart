import 'package:get/get.dart';

import 'EditProfile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditProfileController());
  }
}
