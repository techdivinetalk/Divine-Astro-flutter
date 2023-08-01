import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

class CustomProgressDialog extends StatelessWidget {
  final AppThemeState _appTheme = AppTheme.of(Get.context!);
  CustomProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 200.w,
      decoration: BoxDecoration(
          color: _appTheme.blackColor.withOpacity(0.5),
          borderRadius: BorderRadius.all(
              Radius.circular(_appTheme.getHeight(10)))),
      child: Center(
        child: SizedBox(
          width: 100.w,
          height: 100.w,
          child: CircularProgressIndicator(
            strokeWidth: _appTheme.getWidth(8),
            valueColor: AlwaysStoppedAnimation<Color>(_appTheme.primaryColor),
          ),
        ),
      ),
    );
  }
}