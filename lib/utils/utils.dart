import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

class Utils {
  static const animationDuration = Duration(milliseconds: 200);
}

void divineSnackBar({required String data, Color? color}) {
  BuildContext? context = navigator?.context;
  if (context != null) {
    final snackBar = SnackBar(
      content: Text(
        data,
        style: TextStyle(
            color: color != null ? AppColors.white : AppColors.blackColor),
      ),
      backgroundColor: color ?? AppColors.lightYellow,
      showCloseIcon: true,
      closeIconColor: color != null ? AppColors.white : AppColors.blackColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
