import 'package:divine_astrologer/pages/on_boarding/add_ecom/add_ecom_controller.dart';
import 'package:get/get.dart';

class AddEcomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddEcomController());
  }
}
