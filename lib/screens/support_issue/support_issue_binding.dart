import 'package:divine_astrologer/screens/support_issue/support_issue_controller.dart';
import 'package:get/get.dart';

import '../../repository/user_repository.dart';

class SupportIssueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportIssueController>(
        () => SupportIssueController(UserRepository()));
  }
}
