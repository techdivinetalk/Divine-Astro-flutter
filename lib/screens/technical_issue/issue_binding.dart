import 'package:get/get.dart';

import '../../repository/user_repository.dart';
import 'issue_controller.dart';

class TechnicalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicalIssueController>(
        () => TechnicalIssueController(UserRepository()));
  }
}
