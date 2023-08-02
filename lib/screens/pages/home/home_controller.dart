import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool chatSwitch = false.obs;
  RxBool callSwitch = false.obs;
  RxBool consultantOfferSwitch = false.obs;
  RxBool promotionOfferSwitch = false.obs;
  final promotionOfferValue = ValueNotifier<bool>(false);

  @override
  void onInit() {
    super.onInit();
    promotionOfferValue.addListener(() {
      if (promotionOfferValue.value) {
        // _themeDark = true;
      } else {
        // _themeDark = false;
      }
    });
  }
}
