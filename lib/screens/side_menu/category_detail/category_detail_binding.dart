import 'package:divine_astrologer/screens/side_menu/category_detail/category_detail_controller.dart';
import 'package:get/get.dart';

class CategoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CategoryDetailController());
  }
}
