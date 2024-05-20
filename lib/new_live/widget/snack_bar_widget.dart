import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void liveSnackBar({String? msg}) {
  final SnackBar snackBar = SnackBar(
    width: Get.width / 1.5,
    content: Text(
      msg ?? "",
      style: TextStyle(
        fontSize: 16,
        color: appColors.black,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
    backgroundColor: appColors.guideColor,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    ),
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  return;
}

