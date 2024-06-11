import 'package:divine_astrologer/screens/add_puja/add_puja_controller.dart';
import 'package:get/get.dart';

class AddPujaBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AddPujaController());
  }
}
