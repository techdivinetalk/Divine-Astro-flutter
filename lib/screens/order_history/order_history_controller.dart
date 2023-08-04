import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryController extends GetxController {
  ScrollController orderScrollController = ScrollController();
  ScrollController orderAllScrollController = ScrollController();
  TabController? tabbarController;

  final List<String> durationOptions = ['Daily', 'Weekly', 'Monthly', 'Custom'];
  RxString selectedValue = "Daily".obs;
}
