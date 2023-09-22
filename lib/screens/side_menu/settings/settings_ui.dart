import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/side_menu/settings/widget/change_lang_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../../pages/profile/profile_page_controller.dart';
import 'settings_controller.dart';
import 'widget/delete_account_popup.dart';

class SettingsUI extends GetView<SettingsController> {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          highlightColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        title: Text("settings".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors.darkBlue,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("changeAppLanguage".tr,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  )),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  // Get.put(ProfilePageController(UserRepository()));
                  // Get.put(ProfilePageController());
                  openBottomSheet(context,
                      functionalityWidget:  const LanguageBottomSheetWidget(
                      //  ontap: () => Get.back(),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.6, color: Colors.grey)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "english".tr,
                          style: AppTextStyle.textStyle16(
                              fontColor: AppColors.darkBlue),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 30.sp,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text("general".tr,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  )),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () => Get.toNamed(RouteName.termsCondition),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.6, color: Colors.grey)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "termsAndConditions".tr,
                          style: AppTextStyle.textStyle16(
                              fontColor: AppColors.darkBlue),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 30.sp,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () => Get.toNamed(RouteName.privacyPolicy),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.6, color: Colors.grey)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "privacyPolicy".tr,
                          style: AppTextStyle.textStyle16(
                              fontColor: AppColors.darkBlue),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 30.sp,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () {
                  logOutPopup(Get.context!);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.6, color: Colors.grey)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      children: [
                        Assets.images.icLogout.svg(),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "logoutMyAccount".tr,
                          style: AppTextStyle.textStyle16(
                              fontColor: AppColors.darkBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () {
                  // controller.deleteAccountPopup(Get.context!);
                  showCupertinoModalPopup(
                    context: context,
                    barrierColor: AppColors.darkBlue.withOpacity(0.5),
                    builder: (context) => const DeleteAccountPopup(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.6, color: Colors.grey)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Row(
                      children: [
                        Assets.images.deleteAccout.svg(),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "deleteMyAccount".tr,
                          style: AppTextStyle.textStyle16(
                              fontColor: AppColors.appRedColour),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                          controller.logOut();
                          // controller.preferenceService.erase();
                          // Get.offNamed(RouteName.login);
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
