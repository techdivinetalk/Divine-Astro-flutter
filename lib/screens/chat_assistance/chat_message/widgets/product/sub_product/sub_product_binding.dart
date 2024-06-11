import 'package:get/get.dart';

import '../../../../../../repository/shop_repository.dart';
import 'sub_product_controller.dart';



class SubProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubProductController(Get.put(ShopRepository())));
  }
}
