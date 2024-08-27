import 'package:get/get.dart';

import 'bank_controller.dart';

class BankBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BankController());
  }
}
