import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import 'settings_controller.dart';

class SettingsUI extends GetView<SettingsController> {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        title: Text(AppString.settings,
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
              Text(AppString.changeAppLanguage,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  )),
              SizedBox(
                height: 20.h,
              ),
              Container(
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
                        AppString.english,
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
              SizedBox(
                height: 20.h,
              ),
              Text(AppString.general,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  )),
              SizedBox(
                height: 20.h,
              ),
              Container(
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
                        AppString.termsAndConditions,
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
              SizedBox(
                height: 15.h,
              ),
              Container(
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
                        AppString.privacyPolicy,
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
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: (){

                  controller.logOutPopup(Get.context!);
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
                          AppString.logoutMyAccount,
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
                onTap: (){

                  controller.deleteAccountPopup(Get.context!);

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
                          AppString.deleteMyAccount,
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
}
