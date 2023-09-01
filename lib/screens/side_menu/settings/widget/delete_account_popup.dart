import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../../../../gen/assets.gen.dart';
import '../settings_controller.dart';

class DeleteAccountPopup extends GetView<SettingsController> {
  const DeleteAccountPopup({super.key});

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
                        onPressed: () {
                          deleteAccountAlert(context);
                        },
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
        ],
      ),
    );
  }

  deleteAccountAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(child: Assets.images.logo.svg()),
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            "deleteAccountMsg".tr,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue),
                          ),
                          SizedBox(
                            height: 35.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "no".tr.toUpperCase(),
                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w500,
                                        fontColor: AppColors.darkBlue),
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                InkWell(
                                  onTap: () {
                                    // controller.deleteUserAccounts();
                                    Get.back();


                                  },
                                  child: Text(
                                    "yes".tr.toUpperCase(),
                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w500,
                                        fontColor: AppColors.darkBlue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }
}
