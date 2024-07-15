import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
          borderRadius:
              BorderRadius.all(Radius.circular(_appTheme.getHeight(10)))),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.maxFinite),
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: appColors.guideColor,
            ),
          ),
        ),
        SizedBox(height: 10),
        CustomText('Getting data'),
      ],
    );
  }
}

class KundliLoading extends StatelessWidget {
  const KundliLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lottie/kundali_loading.json",
              height: 100.h,
              width: 100.w,
              repeat: true,
              frameRate: FrameRate.max,
              options: LottieOptions(),
              delegates: const LottieDelegates(),
              onWarning: (p0) {},
              alignment: Alignment.center,
              onLoaded: (p0) {
                print(p0);
                print("on loaded");
              },
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return const Center(
                  child: Icon(Icons.error),
                );
              },
            ),
            Text("pleaseWait".tr),
          ],
        ),
      ),
    );
  }
}
