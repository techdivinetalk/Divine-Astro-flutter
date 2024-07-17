import 'package:divine_astrologer/model/add_custom_product/add_custom_product_controller.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';



class AddCustomProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddCustomProductController());
  }
}
