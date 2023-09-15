import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/screens/auth/login/widget/country_picker.dart';
import 'package:divine_astrologer/screens/number_change/sub_screen/otp_screen_for_update_mobile_number.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';

import 'number_change_controller.dart';

class NumberChangeReqUI extends GetView<NumberChangeReqController> {
  const NumberChangeReqUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "numberChangeRequest".tr,
          style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "numChangeMsgTitle".tr,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.greyColor),
              ),
              SizedBox(
                height: 20.h,
              ),
              //primary Phone Number
              Text(
                "primaryPhoneNumber".tr,
                style: AppTextStyle.textStyle20(
                  fontColor: AppColors.darkBlue,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  Obx(() => CustomButton(
                        onTap: () {
                          countryPickerSheet(context, (value) {
                            String code = value.phoneCode;
                            if (!code.startsWith("+")) code = "+$code";
                            controller.countryCode.value = code;
                            Get.back();
                          });
                        },
                        child: Text(
                          controller.countryCode.value,
                          style: AppTextStyle.textStyle20(
                            fontColor: AppColors.darkBlue,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: TextField(
                    controller: controller.controller,
                    style: AppTextStyle.textStyle20(
                      fontColor: AppColors.darkBlue,
                    ),
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyColor),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Obx(() => Material(
                            color: controller.enableUpdateButton.value
                                ? AppColors.lightYellow
                                : AppColors.greyColor,
                            child: InkWell(
                              onTap: controller.enableUpdateButton.value
                                  ? () {
                                      if (controller.controller.text.length ==
                                          10) {
                                        Get.toNamed(
                                            RouteName.numberChangeOtpScreen);
                                        controller.focusNodeOtp.requestFocus();
                                      } else {
                                        divineSnackBar(
                                          data: "phoneNumberMustBe10Digit".tr,
                                        );
                                      }
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 10.h,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "update".tr,
                                      style: AppTextStyle.textStyle16(
                                        fontColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}
