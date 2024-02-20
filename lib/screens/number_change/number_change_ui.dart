import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/auth/login/widget/country_picker.dart';
import 'package:divine_astrologer/screens/bank_details/widgets.dart';
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
    return GetBuilder<NumberChangeReqController>(
      assignId: true,
      init: NumberChangeReqController(),
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackNavigationWidget(
                    title: "numberChangeRequest".tr,
                    onPressedBack: () => Get.back(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "numChangeMsgTitle".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: appColors.greyColor,
                              decoration: TextDecoration.underline,
                              decorationColor: appColors.greyColor,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "primaryPhoneNumber".tr,
                            style: AppTextStyle.textStyle20(
                              fontColor: appColors.darkBlue,
                            ),
                          ),
                          // SizedBox(height: 5.h),

                          PhoneNumberInput(
                            controller: controller.controller,
                            countryCode: controller.countryCode,
                            enableUpdateButton: controller.enableUpdateButton,
                            onButtonPressed: () {
                              if (controller.controller.text.length == 10) {
                                controller.sendOtpForNumberChange();
                              } else {
                                divineSnackBar(
                                    data: "phoneNumberMustBe10Digit".tr);
                              }
                            },
                            onChange: (value) {
                              if (controller.userData.mobileNumber == value) {
                                controller.enableUpdateButton.value = false;
                              } else {
                                if (value.length == 10) {
                                  print("controller.text");
                                  controller.enableUpdateButton.value = true;
                                } else {
                                  controller.enableUpdateButton.value = false;
                                }
                              }
                              controller.update();
                            },
                          ),
                          SizedBox(height: 25.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final RxString countryCode;
  final RxBool enableUpdateButton;
  final Function(String)? onChange;
  final Function() onButtonPressed;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    required this.countryCode,
    required this.onChange,
    required this.enableUpdateButton,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      // textBaseline: TextBaseline.ideographic,
      children: [
        CustomButton(
          onTap: () {
            countryPickerSheet(context, (value) {
              String code = value.phoneCode;
              if (!code.startsWith("+")) code = "+$code";
              countryCode.value = code;
              Get.back();
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 2.5),
            child: Text(
              countryCode.value,
              style: AppTextStyle.textStyle20(
                fontColor: appColors.darkBlue,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: onChange,
            controller: controller,
            style: AppTextStyle.textStyle20(
              fontColor: appColors.darkBlue,
            ),
            maxLength: 10,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              counterText: '',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: appColors.greyColor,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: appColors.greyColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: enableUpdateButton.value
                  ? appColors.guideColor
                  : appColors.greyColor,
              child: InkWell(
                onTap: enableUpdateButton.value ? onButtonPressed : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 10.h,
                    ),
                    child: Center(
                      child: Text(
                        "update".tr,
                        style: AppTextStyle.textStyle16(
                          fontColor: appColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
