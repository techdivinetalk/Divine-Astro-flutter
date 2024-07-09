import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import 'help_support_controller.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(
      () => HelpSupportController(
        UserRepository(),
      ),
    );
  }
}
