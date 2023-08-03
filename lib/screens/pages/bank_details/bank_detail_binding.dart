import 'package:get/get.dart';

import 'bank_detail_controller.dart';

class BankDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BankDetailController());
  }
}
