import 'package:divine_astrologer/screens/auth/login/login_controller.dart';
import 'package:get/get.dart';

import '../../../repository/user_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController(Get.put(UserRepository())));
  }
}
