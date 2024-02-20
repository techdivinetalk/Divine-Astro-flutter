import 'dart:async';

import 'package:divine_astrologer/remote_config/remote_config_helper.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final appColors = Get.find<AppColors>();

class AppColors extends GetxController {



  Color white = Color(0xFFFFFFFF);
  Color darkBlue = Color(0xFF0E2339);
  Color lightGreen = Color(0xff27C884);
  Color guideColor = Color(0xFF87919C);
  Color textColor = Color(0xFF0E2339);
  Color blackColor = Colors.black;
  Color brownColour = Color(0xFF5F3C08); // foreground color
  Color appRedColour = Color(0xFFEF5862);
  Color greyColour = Color(0xFF7E7E7E);
  Color redColor = Colors.red;
  Color darkRed = Color(0xFFE31E24);
  Color darkGreen = Color(0xff13BF45);
  Color greyColor = Colors.grey;
  Color lightGrey = Color(0xff87919C);
  Color extraLightGrey = Color(0xffD9D9D9);
  Color markerColor = Color(0xffc5c5d8);
  Color teal = Color(0xFF41C1D1);
  Color transparent = Colors.transparent;
  Color grey = Color(0xFF9E9E9E);
  Color lightBlack = Color(0xff233982);
  Color black = Color(0xFF000000);
  Color brown = Color(0xFF5F3C08);
  Color red = Color(0xFFEF5862);
}
