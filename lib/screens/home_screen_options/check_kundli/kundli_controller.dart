import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TabEnum { checkYours, checkOther }

enum Gender { male, female }

class KundliController extends GetxController {
  TabController? tabController;
  Rx<Gender> gender = Gender.male.obs;
}
