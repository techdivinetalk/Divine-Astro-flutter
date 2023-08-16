import 'package:divine_astrologer/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../di/shared_preference_service.dart';
import '../../../gen/assets.gen.dart';

class SettingsController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  deleteAccountPopup(BuildContext context) async {
    await openBottomSheet(
      context,
      functionalityWidget: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
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
          Container(
            // width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: AppColors.white,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeRight: true,
              removeLeft: true,
              removeBottom: true,
              removeTop: true,
              child: Column(
                children: [
                  Assets.images.bgDeleteAccount.svg(),
                  SizedBox(height: 20.h),
                  Text(
                    "${'deleteAccount'.tr}?",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.redColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'deleteText'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.visible,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.lightYellow,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'deleteAccount'.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.brownColour,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  logOutPopup(BuildContext context) async {
    await openBottomSheet(
      context,
      functionalityWidget: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Assets.images.bgLogout.svg(),
                SizedBox(height: 20.h),
                Text(
                  "${'logout'.tr}?",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: AppColors.redColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'logoutText'.tr,
                  style:
                      AppTextStyle.textStyle16(fontColor: AppColors.darkBlue),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          preferenceService.erase();
                          Get.offNamed(RouteName.login);
                          // Get.offAndToNamed(RouteName.login);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.lightYellow,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          'logout'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.brownColour,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
