import 'package:divine_astrologer/model/custom_product/custom_product__list_controller.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:get/get.dart';



class CustomProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomProductListController());
  }
}
