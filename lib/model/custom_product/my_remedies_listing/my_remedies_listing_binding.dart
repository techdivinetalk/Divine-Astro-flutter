import 'package:divine_astrologer/model/custom_product/my_remedies_listing/my_remedies_listing_controller.dart';
import 'package:get/get.dart';

class MyRemediesListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyRemediesListingController());
  }
}
