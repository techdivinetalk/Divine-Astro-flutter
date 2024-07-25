import 'package:divine_astrologer/screens/side_menu/testing/testing_controller.dart';
import 'package:get/get.dart';

import '../../../repository/user_repository.dart';

class TestingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestingController>(() => TestingController(UserRepository()));
  }
}
