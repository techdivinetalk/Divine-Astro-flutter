import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/select_your_birth_place_sheet.dart';
import 'package:divine_astrologer/model/cityDataModel.dart';
import 'package:divine_astrologer/screens/home_screen_options/refer_astrologer/refer_astrologer_controller.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/custom_light_yellow_btn.dart';

class ReferAnAstrologer extends GetView<ReferAstrologerController> {
  const ReferAnAstrologer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: commonDetailAppbar(title: "referAnAstrologer".tr),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          controller.submitting.value == false
              ? CustomLightYellowButton(
                  name: "submitForm".tr,
                  onTaped: () {
                    controller.submitForm();
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
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
                WhiteTextField(
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
                  errorBorder: appColors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "Father name",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.fatherNameController,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintText: "Enter Astrologer's Father Name",
                  errorBorder: appColors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "Date of Birth",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.dobController,
                  inputType: TextInputType.text,
                  readOnly: true,
                  onTap: () {
                    Utils.selectDateOrTime(
                      initialDate: DateTime.now(),
                      title: "selectDateBirth".tr,
                      btnTitle: "confirmDateBirth".tr,
                      pickerStyle: "DateCalendar",
                      looping: true,
                      onChange: (String datetime) {
                        if (datetime != "") {
                          DateTime data =
                              DateFormat("dd MMMM yyyy").parse(datetime);
                          controller.state.dobController.text =
                              "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
                        }
                      },
                      onConfirm: (value) {
                        if (value != "") {
                          var temp = DateFormat('dd MMMM yyyy').parse(value);
                          controller.state.selectDOB =
                              DateFormat('yyyy-MM-dd').format(temp);
                          DateTime data =
                              DateFormat("dd MMMM yyyy").parse(value);
                          controller.state.dobController.text =
                              "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
                        }
                      },
                    );
                  },
                  inputAction: TextInputAction.next,
                  hintText: "Enter Astrologer's Date of Birth",
                  errorBorder: appColors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "${"mobileNumber".tr}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  maxCount: 10,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    } else if (value.length != 10) {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.mobileNumber,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  hintText: "enterNumberMsg".tr,
                ),
                const SizedBox(height: 10),
                Text(
                  "${"astrologySkill".tr}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
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
                const SizedBox(height: 10),
                Text(
                  "${"experience".tr}*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  maxCount: 2,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.astrologerExperience,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  hintText: "enterExperienceMsg".tr,
                ),
                const SizedBox(height: 10),
                Text(
                  "City*",
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                WhiteTextField(
                  validator: (value) {
                    if (value! == "") {
                      return "";
                    }
                    return null;
                  },
                  controller: controller.state.cityController,
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.done,
                  readOnly: true,
                  hintText: "Enter Astrologer's City",
                  onTap: () {
                    Get.bottomSheet(
                        isScrollControlled: true,
                        Padding(
                          padding: EdgeInsets.only(
                              // bottom: MediaQuery.of(context).viewInsets.bottom
                              ),
                          child: AllCityListSheet(
                            onSelect: (value) {
                              controller.state.cityController.text =
                                  value.cityName ?? "";
                              controller.state.cityList.add(CityStateData(
                                cityName: value.cityName,
                                latitude: value.latitude,
                                longitude: value.longitude,
                              ));
                              controller.update();
                              Get.back();
                            },
                            country: "India",
                            cityData: controller.state.cityList,
                          ),
                        ));
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "anotherPlatform".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.h),
                yesNoOptionWiddet(),
                const SizedBox(height: 10),
                Text(
                  "*${"mandatoryFields".tr}",
                  style: AppTextStyle.textStyle14(
                      fontWeight: FontWeight.w400,
                      fontColor: controller.formValidateVal.value
                          ? appColors.darkBlue
                          : appColors.redColor),
                ),
                SizedBox(height: 5.h),
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
                          ? appColors.darkBlue
                          : appColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      "yes".tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w600,
                          fontColor: controller.isYes
                              ? appColors.white
                              : appColors.darkBlue),
                    )),
              ),
            ),
            SizedBox(width: 25.w),
            GetBuilder<ReferAstrologerController>(
              builder: (controller) {
                return InkWell(
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
                            ? appColors.darkBlue
                            : appColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Text(
                        "no".tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w600,
                            fontColor: controller.isNo
                                ? appColors.white
                                : appColors.darkBlue),
                      )),
                );
              },
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
                    WhiteTextField(
                      validator: (value) {
                        if (controller.isYes) {
                          if (value! == "") {
                            return "";
                          }
                        }
                        return null;
                      },
                      controller: controller.state.otherPlatform,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      hintText: "enterPlatformMsg".tr,
                    ),
                  ],
                )
              : const SizedBox(),
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
  final from;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final int? maxLine;
  final double? height;
  final List<TextInputFormatter>? inputFormatter;
  final bool notEditText;

  const ReferAstrologerField({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.inputAction,
    this.errorBorder,
    this.icon,
    this.from,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.maxLine,
    this.height,
    this.inputFormatter,
    this.notEditText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: from == "profile"
            ? [
                // BoxShadow(
                //   color: Colors.grey.withOpacity(0.1),
                //   blurRadius: 1,
                //   offset: const Offset(1, 1),
                // ),
              ]
            : [
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
        maxLines: maxLine,
        inputFormatters: inputFormatter,
        textInputAction: inputAction,
        readOnly: notEditText,
        decoration: InputDecoration(
          isDense: true,
          errorStyle: const TextStyle(height: 0),
          hintText: hintText,
          helperStyle: AppTextStyle.textStyle14(),
          fillColor: appColors.white,
          hintStyle: AppTextStyle.textStyle14(fontColor: appColors.grey),
          hoverColor: appColors.white,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: from == "profile"
                  ? appColors.grey.withOpacity(0.6)
                  : errorBorder ?? appColors.white,
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: from == "profile"
                  ? appColors.grey.withOpacity(0.6)
                  : errorBorder ?? appColors.white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: appColors.redColor,
              // color:from == "profile"? appColors.grey : errorBorder ?? appColors.white,

              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: appColors.guideColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteTextField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Icon? icon;
  final Widget? suffixIcon;
  final Color? errorBorder;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final void Function(String? val)? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxCount;
  final void Function()? onTap;
  final bool readOnly;

  const WhiteTextField({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.inputAction,
    this.errorBorder,
    this.icon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.onChanged,
    this.inputFormatter,
    this.maxCount,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey.withOpacity(0.1),
        //       blurRadius: 2,
        //       spreadRadius: 3),
        // ],
      ),
      child: TextFormField(
        maxLength: maxCount,
        inputFormatters: inputFormatter,
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        textInputAction: inputAction,
        onTap: onTap,
        readOnly: readOnly,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          counterText: '',
          errorStyle: const TextStyle(height: 0),
          hintText: hintText,
          helperStyle: AppTextStyle.textStyle16(),
          fillColor: appColors.white,
          hintStyle: AppTextStyle.textStyle16(fontColor: appColors.grey),
          hoverColor: appColors.white,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: appColors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: appColors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: appColors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: appColors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
