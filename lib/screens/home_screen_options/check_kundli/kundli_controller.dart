import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TabEnum { checkYours, checkOther }

enum Gender { none, male, female }

class KundliController extends GetxController {
  TabController? tabController;
  Rx<Gender> gender = Gender.male.obs;

  Rx<Params> params = Params().obs;
}

class Params {
  int? day, month, year, hour, min;
  double? lat, long, tzone;
  String? location;

  Params({
    this.day,
    this.month,
    this.year,
    this.hour,
    this.min,
    this.lat,
    this.long,
    this.tzone,
    this.location,
  });
}