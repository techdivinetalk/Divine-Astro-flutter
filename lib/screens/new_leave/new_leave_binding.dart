import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';

import 'new_leave_controller.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewLeaveController>(() => NewLeaveController(UserRepository()));
  }
}
