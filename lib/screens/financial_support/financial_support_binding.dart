import 'package:get/get.dart';

import '../../repository/user_repository.dart';
import 'financial_support_controller.dart';

class FinancialSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinancialSupportController>(
        () => FinancialSupportController(UserRepository()));
  }
}
