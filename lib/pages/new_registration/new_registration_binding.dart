import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import 'new_registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewRegistrationController>(
        () => NewRegistrationController(UserRepository()));
  }
}
