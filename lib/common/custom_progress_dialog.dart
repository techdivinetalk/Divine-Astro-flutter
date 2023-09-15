import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_theme.dart';
import 'colors.dart';
import 'custom_widgets.dart';

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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.maxFinite),
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: AppColors.lightYellow,
            ),
          ),
        ),
        SizedBox(height: 10),
        CustomText('Getting data'),
      ],
    );
  }
}