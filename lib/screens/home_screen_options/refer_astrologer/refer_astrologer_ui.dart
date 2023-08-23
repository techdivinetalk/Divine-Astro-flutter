import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';

import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/custom_light_yellow_btn.dart';

class ReferAnAstrologer extends GetView<ReferAstrologerController> {
  const ReferAnAstrologer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: commonDetailAppbar(title: "referAnAstrologer".tr),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLightYellowButton(
            name: "submitForm".tr,
            onTaped: () {
              controller.submitForm();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: controller.formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${"name".tr}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                ReferAstrologerField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.astrologerName,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: "enterNameMsg".tr,
                  errorBorder: AppColors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  "mobileNumber".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                ReferAstrologerField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.mobileNumber,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: "enterNumberMsg".tr,
                ),
                const SizedBox(height: 20),
                Text(
                  "astrologySkill".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                ReferAstrologerField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.astrologySkills,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: "enterSkillsMsg".tr,
                ),
                const SizedBox(height: 20),
                Text(
                  "${"experience".tr}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                ReferAstrologerField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.astrologerExperience,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  hintText: "enterExperienceMsg".tr,
                ),
                const SizedBox(height: 20),
                Text(
                  "anotherPlatform".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                yesNoOptionWiddet(),
                const SizedBox(height: 20),
                Text(
                  "mandatoryFields".tr,
                  style: AppTextStyle.textStyle14(
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.darkBlue),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget yesNoOptionWiddet() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GetBuilder<ReferAstrologerController>(
              builder: (controller) => InkWell(
                onTap: () {
                  controller.workingForPlatForm(value: WorkingForPlatform.yes);
                },
                child: Container(
                    height: 35.h,
                    width: 60.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3.0,
                            offset: const Offset(0.0, 3.0)),
                      ],
                      color: controller.isYes
                          ? AppColors.darkBlue
                          : AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      "yes".tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w600,
                          fontColor: controller.isYes
                              ? AppColors.white
                              : AppColors.darkBlue),
                    )),
              ),
            ),
            const SizedBox(width: 25),
            GetBuilder<ReferAstrologerController>(
              builder: (controller) => InkWell(
                onTap: () {
                  controller.workingForPlatForm(value: WorkingForPlatform.no);
                },
                child: Container(
                    height: 35.h,
                    width: 60.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3.0,
                            offset: const Offset(0.0, 3.0)),
                      ],
                      color: controller.isNo
                          ? AppColors.darkBlue
                          : AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      "no".tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w600,
                          fontColor: controller.isNo
                              ? AppColors.white
                              : AppColors.darkBlue),
                    )),
              ),
            ),
          ],
        ),
        GetBuilder<ReferAstrologerController>(
          builder: (controller) => controller.isYes
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "platform".tr,
                      style:
                          AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 5),
                    ReferAstrologerField(
                      validator: (value) {
                        if (controller.isYes) {
                          if (value! == "") {
                            return "";
                          }
                        }
                        return null;
                      },
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      hintText: "enterPlatformMsg".tr,
                    ),
                  ],
                )
              : Container(),
        )
      ],
    );
  }
}

class ReferAstrologerField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Icon? icon;
  final Widget? suffixIcon;
  final Color? errorBorder;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;

  const ReferAstrologerField({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.inputAction,
    this.errorBorder,
    this.icon,
    this.suffixIcon,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 1.0,
            offset: const Offset(0.1, 1.0),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        textInputAction: inputAction,
        decoration: InputDecoration(
          isDense: true,
          errorStyle: const TextStyle(height: 0),
          hintText: hintText,
          helperStyle: AppTextStyle.textStyle16(),
          fillColor: AppColors.white,
          hintStyle: AppTextStyle.textStyle16(fontColor: AppColors.grey),
          hoverColor: AppColors.white,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: errorBorder ?? AppColors.white,
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: errorBorder ?? AppColors.white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.redColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.yellow,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
