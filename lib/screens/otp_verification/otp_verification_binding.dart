import 'package:get/get.dart';

import '../../repository/user_repository.dart';
import 'otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpVerificationController(Get.put(UserRepository())));
  }
}
