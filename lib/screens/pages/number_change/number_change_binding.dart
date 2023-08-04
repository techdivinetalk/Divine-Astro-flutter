import 'package:get/get.dart';

import 'number_change_controller.dart';

class NumberChangeReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NumberChangeReqController());
  }
}
