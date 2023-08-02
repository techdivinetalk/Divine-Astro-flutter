import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt selectedIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  DashboardController();
}
