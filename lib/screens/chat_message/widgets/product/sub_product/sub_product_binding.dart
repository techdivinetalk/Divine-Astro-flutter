import 'package:divine_astrologer/screens/chat_message/widgets/product/sub_product/sub_product_controller.dart';
import 'package:get/get.dart';

import '../../../../../repository/shop_repository.dart';

class SubProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubProductController(Get.put(ShopRepository())));
  }
}
