import 'package:divine_astrologer/repository/shop_repository.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/category_detail/category_detail_controller.dart';
import 'package:get/get.dart';

class CategoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CategoryDetailController(Get.put(ShopRepository())));
  }
}
