import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  RxInt orderList = 7.obs;

  ScrollController orderScrollController = ScrollController();
  ScrollController amountScrollController = ScrollController();
  List<String> amountTypeList = [
    "availableBalance".tr,
    "pgCharges".tr,
    "subTotal".tr,
    "tds".tr,
    "totalAmount".tr
  ];
  var durationOptions =
      ['daily'.tr, 'weekly'.tr, 'monthly'.tr, 'custom'.tr].obs;
  RxString selectedValue = "daily".tr.obs;
}
