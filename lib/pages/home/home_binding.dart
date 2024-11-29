import 'package:divine_astrologer/pages/home/home_controller.dart';
import 'package:get/get.dart';

class PriceChangeReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}