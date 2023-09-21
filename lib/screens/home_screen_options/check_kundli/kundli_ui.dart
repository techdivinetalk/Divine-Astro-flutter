import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/select_your_birth_place_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/custom_radio_button.dart';
import '../../../common/text_field_custom.dart';
import '../../../gen/assets.gen.dart';
import 'kundli_controller.dart';

class KundliUi extends GetView<KundliController> {
  const KundliUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const <StretchMode>[
                        StretchMode.blurBackground
                      ],
                      background: Center(
                        child: Assets.images.icKundli
                            .svg(height: 180.h, width: 180.w),
                      ),
                    ),
                    backgroundColor: AppColors.white,
                    surfaceTintColor: AppColors.white,
                    expandedHeight: 300.h,
                    pinned: true,
                    title: Text("kundliText".tr,
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w400)),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(kTextTabBarHeight),
                      child: Card(
                        surfaceTintColor: AppColors.white,
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        child: Center(
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 0.0,
                            isScrollable: true,
                            labelColor: AppColors.brownColour,
                            unselectedLabelColor: AppColors.blackColor,
                            dividerColor: Colors.transparent,
                            labelPadding: EdgeInsets.zero,
                            splashBorderRadius: BorderRadius.circular(20),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 8.h),
                            labelStyle: AppTextStyle.textStyle14(
                                fontWeight: FontWeight.w500),
                            indicator: BoxDecoration(
                              color: AppColors.lightYellow,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            onTap: (value) => SystemChannels.textInput
                                .invokeMethod('TextInput.hide'),
                            tabs: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Tab(text: "checkYours".tr),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Tab(
                                  text: "checkOthers".tr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                CheckYours(),
                CheckOther(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckYours extends GetView<KundliController> {
  CheckYours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(KundliController());
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            child: Form(
              key: controller.yourFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: kToolbarHeight.h * 2.6),
                  AppTextField(
                    controller: controller.yourNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    prefixIcon: Assets.images.icUser.svg(),
                    hintText: "hintTextName".tr,
                    onTap: () {},
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => CustomRadio<Gender>(
                              value: Gender.male,
                              groupValue: controller.yourGender.value,
                              onChanged: (value) {
                                controller.yourGender.value = value;
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            "male".tr,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(width: 64.w),
                      Row(
                        children: [
                          Obx(
                            () => CustomRadio<Gender>(
                              value: Gender.female,
                              groupValue: controller.yourGender.value,
                              onChanged: (value) {
                                controller.yourGender.value = value;
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            "female".tr,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.yourDateController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Select Birth Date";
                            }
                            return null;
                          },
                          onTap: () {
                            selectDateOrTime(
                              Get.context!,
                              title: "selectYourDateBirth".tr,
                              btnTitle: "confirmDateBirth".tr,
                              pickerStyle: "DateCalendar",
                              looping: true,
                              onConfirm: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("dd MMMM yyyy").parse(value);
                                  controller.yourDateController.text =
                                      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
                                  controller.yourParams.value.day = data.day;
                                  controller.yourParams.value.month =
                                      data.month;
                                  controller.yourParams.value.year = data.year;
                                }
                              },
                              onChange: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("dd MMMM yyyy").parse(value);
                                  controller.yourDateController.text =
                                      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
                                  controller.yourParams.value.day = data.day;
                                  controller.yourParams.value.month =
                                      data.month;
                                  controller.yourParams.value.year = data.year;
                                }
                              },
                            );
                          },
                          readOnly: true,
                          prefixIcon: Assets.images.icCalendar.svg(),
                          hintText: "birthDate".tr,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: AppTextField(
                          controller: controller.yourTimeController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Select Birth Time";
                            }
                            return null;
                          },
                          onTap: () {
                            selectDateOrTime(
                              Get.context!,
                              title: "selectYourTimeBirth".tr,
                              btnTitle: "confirmTimeBirth".tr,
                              pickerStyle: "TimeCalendar",
                              looping: true,
                              onConfirm: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("h:mm a").parse(value);
                                  controller.yourTimeController.text = value;
                                  controller.yourParams.value.hour = data.hour;
                                  controller.yourParams.value.min = data.minute;
                                }
                              },
                              onChange: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("h:mm a").parse(value);
                                  controller.yourTimeController.text = value;
                                  controller.yourParams.value.hour = data.hour;
                                  controller.yourParams.value.min = data.minute;
                                }
                              },
                            );
                          },
                          readOnly: true,
                          prefixIcon: Assets.images.icBirthTIme.svg(),
                          hintText: "birthTime".tr,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    controller: controller.yourPlaceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Select Birth Place";
                      }
                      return null;
                    },
                    prefixIcon: Assets.images.icLocation.svg(),
                    hintText: "birthPalace".tr,
                    onTap: () {
                      selectPlaceOfBirth(context, (value) {
                        controller.yourPlaceController.text = value.name;
                        controller.yourParams.value.lat =
                            double.parse(value.latitude!);
                        controller.yourParams.value.long =
                            double.parse(value.longitude!);
                        controller.yourParams.value.location = value.name;
                        Get.back();
                      });
                    },
                    readOnly: true,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.lightYellow,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            onPressed: () {
                              if (controller.yourFormKey.currentState!
                                  .validate()) {
                                controller.submitDetails(
                                    controller.yourParams.value,
                                    controller.yourGender.value);
                              }
                            },
                            child: Text(
                              "submit".tr,
                              style: AppTextStyle.textStyle20(
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.brownColour),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CheckOther extends GetView<KundliController> {
  CheckOther({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(KundliController());
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            child: Form(
              key: controller.otherFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: kToolbarHeight.h * 2.6),
                  AppTextField(
                    controller: controller.otherNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name should not be empty";
                      }
                      return null;
                    },
                    prefixIcon: Assets.images.icUser.svg(),
                    hintText: "hintTextName".tr,
                    onTap: () {},
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => CustomRadio<Gender>(
                              value: Gender.male,
                              groupValue: controller.otherGender.value,
                              onChanged: (value) {
                                controller.otherGender.value = value;
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            "male".tr,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(width: 64.w),
                      Row(
                        children: [
                          Obx(
                            () => CustomRadio<Gender>(
                              value: Gender.female,
                              groupValue: controller.otherGender.value,
                              onChanged: (value) {
                                controller.otherGender.value = value;
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            "female".tr,
                            style: AppTextStyle.textStyle16(
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.otherDateController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Date should not be empty";
                            }
                            return null;
                          },
                          onTap: () {
                            selectDateOrTime(
                              Get.context!,
                              title: "selectYourDateBirth".tr,
                              btnTitle: "confirmDateBirth".tr,
                              pickerStyle: "DateCalendar",
                              looping: true,
                              onConfirm: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("dd MMMM yyyy").parse(value);
                                  controller.otherDateController.text =
                                      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
                                  controller.otherParams.value.day = data.day;
                                  controller.otherParams.value.month =
                                      data.month;
                                  controller.otherParams.value.year = data.year;
                                }
                              },
                              onChange: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("dd MMMM yyyy").parse(value);
                                  controller.otherDateController.text =
                                      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
                                  controller.otherParams.value.day = data.day;
                                  controller.otherParams.value.month =
                                      data.month;
                                  controller.otherParams.value.year = data.year;
                                }
                              },
                            );
                          },
                          readOnly: true,
                          prefixIcon: Assets.images.icCalendar.svg(),
                          hintText: "birthDate".tr,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: AppTextField(
                          controller: controller.otherTimeController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Time should not be empty";
                            }
                            return null;
                          },
                          onTap: () {
                            selectDateOrTime(
                              Get.context!,
                              title: "selectYourTimeBirth".tr,
                              btnTitle: "confirmTimeBirth".tr,
                              pickerStyle: "TimeCalendar",
                              looping: true,
                              onConfirm: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("h:mm a").parse(value);
                                  controller.otherTimeController.text = value;
                                  controller.otherParams.value.hour = data.hour;
                                  controller.otherParams.value.min =
                                      data.minute;
                                }
                              },
                              onChange: (value) {
                                if (value != "") {
                                  DateTime data =
                                      DateFormat("h:mm a").parse(value);
                                  controller.otherTimeController.text = value;
                                  controller.otherParams.value.hour = data.hour;
                                  controller.otherParams.value.min =
                                      data.minute;
                                }
                              },
                            );
                          },
                          readOnly: true,
                          prefixIcon: Assets.images.icBirthTIme.svg(),
                          hintText: "birthTime".tr,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    controller: controller.otherPlaceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Place should not be empty";
                      }
                      return null;
                    },
                    prefixIcon: Assets.images.icLocation.svg(),
                    hintText: "birthPalace".tr,
                    onTap: () {
                      selectPlaceOfBirth(context, (value) {
                        controller.otherPlaceController.text = value.name;
                        controller.otherParams.value.lat =
                            double.parse(value.latitude!);
                        controller.otherParams.value.long =
                            double.parse(value.longitude!);
                        controller.otherParams.value.location = value.name;
                        Navigator.pop(context);
                        // Get.back();
                      });
                    },
                    readOnly: true,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.lightYellow,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            onPressed: () {
                              if (controller.otherFormKey.currentState!
                                  .validate()) {
                                controller.submitDetails(
                                    controller.otherParams.value,
                                    controller.otherGender.value);
                              }
                            },
                            child: Text(
                              "submit".tr,
                              style: AppTextStyle.textStyle20(
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.brownColour),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  openAlertView() {
    return Get.dialog(
      Center(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.appRedColour, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 15),
              Material(
                child: Text(
                  "allFieldsText".tr,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                width: 139,
                decoration: const BoxDecoration(
                  color: AppColors.lightYellow,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        "okay".tr,
                        style: AppTextStyle.textStyle16(
                            fontColor: AppColors.brownColour,
                            fontWeight: FontWeight.w600),
                      ),
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
