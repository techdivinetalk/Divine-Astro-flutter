import 'package:divine_astrologer/screens/home_screen_options/discount_offers/discount_offers_controller.dart';
import 'package:get/get.dart';


class DiscountOfferBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DiscountOffersController());
  }
}
