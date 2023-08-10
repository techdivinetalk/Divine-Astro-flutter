import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryController extends GetxController {
  ScrollController orderScrollController = ScrollController();
  ScrollController orderAllScrollController = ScrollController();
  TabController? tabbarController;

  var durationOptions = ['daily'.tr, 'weekly'.tr, 'monthly'.tr, 'custom'.tr].obs;
  RxString selectedValue = "daily".tr.obs;
}
