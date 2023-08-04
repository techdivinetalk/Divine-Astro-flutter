import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/TextFieldCustom.dart';
import '../../../common/customLightYellowButton.dart';

class ReferAnAstrologer extends GetView<ReferAstrologerController> {
  const ReferAnAstrologer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: AppString.referAnAstrologer),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLightYellowButton(
            name: AppString.submitForm,
            onTaped: () {
              if (controller.formKey.currentState!.validate()) {
                controller.formKey.currentState!.save();
              } else {}
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppString.name}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: AppString.enterNameMsg,
                  errorBorder: AppColors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  AppString.mobileNumber,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: AppString.enterNumberMsg,
                ),
                const SizedBox(height: 20),
                Text(
                  AppString.astrologySkill,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: AppString.enterSkillsMsg,
                ),
                const SizedBox(height: 20),
                Text(
                  "${AppString.experience}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  hintText: AppString.enterExperienceMsg,
                ),
                const SizedBox(height: 20),
                Text(
                  AppString.anotherPlatform,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                yesNoOptionWiddet(),
                const SizedBox(height: 20),
                Text(
                  AppString.mandatoryFields,
                  style: AppTextStyle.textStyle14(
                      fontWeight: FontWeight.w400, fontColor: AppColors.white),
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
            Obx(() => InkWell(
                  onTap: () {
                    controller.yesOrNoOptionTapped(isYesTapped: true);
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
                        color: controller.isYesSelected.value
                            ? AppColors.darkBlue
                            : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Text(
                        "Yes",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w600,
                            fontColor: controller.isYesSelected.value
                                ? AppColors.white
                                : AppColors.darkBlue),
                      )),
                )),
            const SizedBox(width: 25),
            Obx(() => InkWell(
                  onTap: () {
                    controller.yesOrNoOptionTapped(isYesTapped: false);
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
                        color: controller.isNoSelected.value
                            ? AppColors.darkBlue
                            : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Text(
                        "No",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w600,
                            fontColor: controller.isNoSelected.value
                                ? AppColors.white
                                : AppColors.darkBlue),
                      )),
                )),
          ],
        ),
        Obx(() => controller.isYesSelected.value
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    AppString.platform,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  WhiteTextField(
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    hintText: AppString.enterPlatformMsg,
                  ),
                ],
              )
            : Container())
      ],
    );
  }
}
