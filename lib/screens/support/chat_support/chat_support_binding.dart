import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/support/support_controller.dart';
import 'package:get/get.dart';

class ChatSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(
      () => SupportController(
        UserRepository(),
      ),
    );
  }
}
