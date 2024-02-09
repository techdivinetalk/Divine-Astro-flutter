import 'package:app_settings/app_settings.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaitingPeriodPopup extends StatelessWidget {
  const WaitingPeriodPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                Assets.images.waitlistLive.svg(),
                CustomText(
                  'Time Mismatch Error!',
                  fontSize: 24.sp,
                  fontColor: AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 20.h),
                CustomText(
                  'Kindly review and synchronize your\n device\'s time settings to ensure accurate functionality.',
                  fontSize: 16.sp,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.date ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          minimumSize: Size.zero,
                        ),
                        child: CustomText(
                          'Check Settings'.tr,
                          fontSize: 16.sp,
                          fontColor: AppColors.brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.mediaQuery.viewPadding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}