import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/custom_radio_button.dart';
import '../../../common/routes.dart';
import '../../../common/text_field_custom.dart';
import '../../../gen/assets.gen.dart';
import 'kundli_controller.dart';

class KundliUi extends GetView<KundliController> {
  const KundliUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                      child: Center(child: Assets.images.icLeftArrow.svg()),
                    ),
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
                  surfaceTintColor: AppColors.white,
                  expandedHeight: 300.h,
                  pinned: true,
                  centerTitle: false,
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
          body: const TabBarView(
            children: [
              CheckYours(),
              CheckOther(),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckYours extends GetView<KundliController> {
  const CheckYours({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(KundliController());
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 25.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: kToolbarHeight.h * 2.6),
                AppTextField(
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
                            groupValue: controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value;
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
                            groupValue: controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value;
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
                  children: [
                    Expanded(
                      child: AppTextField(
                        onTap: () {
                          selectDateOrTime(Get.context!,
                              title: "selectYourDateBirth".tr,
                              btnTitle: "confirmDateBirth".tr,
                              pickerStyle: "DateCalendar",
                              looping: true);
                        },
                        readOnly: true,
                        prefixIcon: Assets.images.icCalendar.svg(),
                        hintText: "birthDate".tr,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AppTextField(
                        onTap: () {
                          selectDateOrTime(Get.context!,
                              title: "selectYourTimeBirth".tr,
                              btnTitle: "confirmTimeBirth".tr,
                              pickerStyle: "TimeCalendar",
                              looping: true);
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
                  prefixIcon: Assets.images.icLocation.svg(),
                  hintText: "birthPalace".tr,
                  onTap: () {},
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 36.h, left: 20.w, right: 20.h),
                    child: MaterialButton(
                        height: 50,
                        minWidth: Get.width,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        onPressed: () {
                          Get.toNamed(RouteName.kundliDetail);
                        },
                        color: AppColors.lightYellow,
                        child: Text(
                          "submit".tr,
                          style: AppTextStyle.textStyle20(
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CheckOther extends GetView<KundliController> {
  const CheckOther({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(KundliController());
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 25.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: kToolbarHeight.h * 2.6),
                AppTextField(
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
                            groupValue: controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value;
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
                            groupValue: controller.gender.value,
                            onChanged: (value) {
                              controller.gender.value = value;
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
                  children: [
                    Expanded(
                      child: AppTextField(
                        onTap: () {
                          selectDateOrTime(Get.context!,
                              title: "selectYourDateBirth".tr,
                              btnTitle: "confirmDateBirth".tr,
                              pickerStyle: "DateCalendar",
                              looping: true);
                        },
                        readOnly: true,
                        prefixIcon: Assets.images.icCalendar.svg(),
                        hintText: "birthDate".tr,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AppTextField(
                        onTap: () {
                          selectDateOrTime(Get.context!,
                              title: "selectYourTimeBirth".tr,
                              btnTitle: "confirmTimeBirth".tr,
                              pickerStyle: "TimeCalendar",
                              looping: true);
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
                  prefixIcon: Assets.images.icLocation.svg(),
                  hintText: "birthPalace".tr,
                  onTap: () {},
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 36.h, left: 20.w, right: 20.h),
                    child: MaterialButton(
                        height: 50,
                        minWidth: Get.width,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        onPressed: () {
                          openAlertView();
                        },
                        color: AppColors.lightYellow,
                        child: Text(
                          "submit".tr,
                          style: AppTextStyle.textStyle20(
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
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
