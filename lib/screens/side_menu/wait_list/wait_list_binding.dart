import 'package:get/get.dart';
import 'wait_list_controller.dart';

class WaitListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WaitListUIController());
  }
}
