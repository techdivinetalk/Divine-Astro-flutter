import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/select_your_birth_place_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/colors.dart';
import '../../../common/custom_radio_button.dart';
import '../../../common/custom_widgets.dart';
import '../../../common/text_field_custom.dart';
import '../../../gen/assets.gen.dart';
import '../../../utils/utils.dart';
import 'kundli_controller.dart';

class KundliUi extends GetView<KundliController> {
  const KundliUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)
            .copyWith(bottom: viewBottomPadding(15.h)),
        child: Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: appColors.yellow,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () {
              if (controller.yourFormKey.currentState!.validate()) {
                controller.yourParams.value.name =
                    controller.yourNameController.text.trim();
                controller.submitDetails(controller.yourParams.value,
                    controller.yourGender.value);
              }
            },
            child: Text(
              'Check Kundali',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: appColors.brown,
              ),
            ),
          ),
        ),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverOverlapAbsorber(
                handle:
                NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Center(child: Assets.images.leftArrow.svg()),
                    ),
                  ),
                  flexibleSpace:
                  FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.blurBackground,
                    ],
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(48.r)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            appColors.appColorLite.withOpacity(0.35),
                            appColors.appYellowColour.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          Assets.svg.kundaliHeader.svg(
                            height: 250.h,
                            width: 250.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: appColors.white,
                  surfaceTintColor: appColors.white,
                  expandedHeight: 278.h,
                  pinned: true,
                  title: CustomText(
                    'Add Kundali',
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 100.w),
            child: Column(
              children: [
                Text(
                  'Add Kundali',
                  style: AppTextStyle.textStyle24(
                    fontWeight: FontWeight.w600,
                    fontColor: appColors.red,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 74),
                  child: Text(
                    'Fill in the details below to get the free personalized kundali',
                    style: AppTextStyle.textStyle16(),textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),

                 const SizedBox(

                  height: 380,
                  child: CheckYours(),
                ),
              ],
            ),
          )),
    );
  }
}

class CheckYours extends GetView<KundliController> {
  const CheckYours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(KundliController());
    return Column(
      children: [
        Container(
          child: Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: controller.yourFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //SizedBox(height: kToolbarHeight.h * 2.5),
                      const SizedBox(height: 30),
                      AppTextField(
                        controller: controller.yourNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'pleaseEnterName'.tr;
                          }
                          return null;
                        },
                        prefixIcon: Assets.images.icUser.svg(),
                        hintText: "Enter Name",
                        onTap: () {},
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: AppTextField(
                      //         controller: controller.yourNameController,
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'pleaseEnterFirstName'.tr;
                      //           }
                      //           return null;
                      //         },
                      //         prefixIcon: Assets.images.user.svg(),
                      //         hintText: "First Name".tr,
                      //         onTap: () {},
                      //       ),
                      //     ),
                      //     SizedBox(width: 20.w),
                      //     Expanded(
                      //       child: AppTextField(
                      //         controller: controller.yourLastNameController,
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'pleaseEnterLastName'.tr;
                      //           }
                      //           return null;
                      //         },
                      //         prefixIcon: Assets.images.user.svg(),
                      //         hintText: "Last Name".tr,
                      //         onTap: () {},
                      //       ),
                      //     )
                      //   ],
                      // ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: appColors.darkBlue,
                                ),
                              )
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: appColors.darkBlue,
                                ),
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
                                if (value == null || value.isEmpty) {
                                  return 'BirthdateValidation'.tr;
                                }
                                return null;
                              },
                              onTap: () {
                                Utils.selectDateOrTime(
                                  initialDate: controller
                                      .yourDateController.text.isNotEmpty
                                      ? DateFormat("dd/MM/yyyy").parse(
                                      controller.yourDateController.text)
                                      : DateTime.now(),
                                  title: "selectDateBirth".tr,
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
                                      controller.yourParams.value.year =
                                          data.year;
                                    }
                                  },
                                  onChange: (String datetime) {},
                                );
                              },
                              readOnly: true,
                              prefixIcon: Assets.images.date.svg(),
                              hintText: "birthDate".tr,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: AppTextField(
                              controller: controller.yourTimeController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "timeEmptyValidation".tr;
                                }
                                return null;
                              },
                              onTap: () {
                                Utils.selectDateOrTime(
                                  initialDate: controller
                                      .yourTimeController.text.isNotEmpty
                                      ? DateFormat("hh:mm a").parse(
                                      controller.yourTimeController.text)
                                      : DateTime.now(),
                                  title: "selectTimeBirth".tr,
                                  btnTitle: "confirmTimeBirth".tr,
                                  pickerStyle: "TimeCalendar",
                                  looping: true,
                                  onConfirm: (value) {
                                    if (value != "") {
                                      DateTime data =
                                      DateFormat("h:mm a").parse(value);
                                      controller.yourTimeController.text = value;
                                      controller.yourParams.value.hour =
                                          data.hour;
                                      controller.yourParams.value.min =
                                          data.minute;
                                    }
                                  },
                                  onChange: (value) {
                                    if (value != "") {
                                      DateTime data =
                                      DateFormat("h:mm a").parse(value);
                                      controller.yourTimeController.text = value;
                                      controller.yourParams.value.hour =
                                          data.hour;
                                      controller.yourParams.value.min =
                                          data.minute;
                                    }
                                  },
                                );
                              },
                              readOnly: true,
                              prefixIcon: Assets.images.time.svg(),
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
                            return "PlaceEmptyValidation".tr;
                          }
                          return null;
                        },
                        prefixIcon: Assets.images.icLocation.svg(),
                        hintText: "birthPlace".tr,
                        onTap: () {
                          selectPlaceOfBirth(context, (value) {
                            controller.yourPlaceController.text = value.name;
                            controller.yourParams.value.lat =
                                double.parse(value.latitude ?? '');
                            controller.yourParams.value.long =
                                double.parse(value.longitude ?? '');
                            controller.yourParams.value.location = value.name;
                            Get.back();
                          });
                        },
                        readOnly: true,
                      ),
                    ],
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


