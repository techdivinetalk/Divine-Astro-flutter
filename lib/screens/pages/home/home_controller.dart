import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = false.obs;
  RxBool callSwitch = false.obs;
  RxBool consultantOfferSwitch = false.obs;
  RxBool promotionOfferSwitch = false.obs;
  RxString appbarTitle = "Astrologer Name  ".obs;
  RxBool isShowTitle = true.obs;
}
