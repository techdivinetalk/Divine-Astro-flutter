import 'package:divine_astrologer/common/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  RxInt orderList = 7.obs;

  ScrollController orderScrollController = ScrollController();
  ScrollController amountScrollController = ScrollController();
  List<String> amountTypeList = [
    AppString.availableBalance,
    AppString.pgCharges,
    AppString.subTotal,
    AppString.tds,
    AppString.totalAmount
  ];
  final List<String> durationOptions = ['Daily', 'Weekly', 'Monthly', 'Custom'];
  RxString selectedValue = "Daily".obs;
}
