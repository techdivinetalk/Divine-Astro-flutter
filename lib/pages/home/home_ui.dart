import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/common/switch_component.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/pages/home/widgets/training_video.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/load_image.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../common/routes.dart';
import '../../common/common_bottomsheet.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'home_controller.dart';

class HomeUI extends GetView<HomeController> {
  const HomeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      key: controller.homeScreenKey,
      backgroundColor: AppColors.white,
      drawer: const SideMenuDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => controller.homeScreenKey.currentState?.openDrawer(),
          highlightColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          icon: const Icon(Icons.menu),
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          controller.appbarTitle.value,
          style: AppTextStyle.textStyle15(
            fontWeight: FontWeight.w400,
            fontColor: AppColors.darkBlue,
          ),
        ),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  controller.isShowTitle.value = !controller.isShowTitle.value;
                },
                child: controller.isShowTitle.value
                    ? Assets.images.icVisibility.svg()
                    : Assets.images.icVisibilityOff.svg(),
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.loading == Loading.loaded) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.isShowTitle.value
                                ? InkWell(
                                    onTap: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.appRedColour,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "today".tr,
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.darkBlue,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹******",
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.appRedColour,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "today".tr,
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.darkBlue,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(width: 15.w),
                            controller.isShowTitle.value
                                ? InkWell(
                                    onTap: () {
                                      earningDetailPopup(Get.context!);
                                      // Get.toNamed(RouteName.yourEarning);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "₹${controller.homeData?.totalEarning?.toStringAsFixed(2)}",
                                              style: AppTextStyle.textStyle16(
                                                  fontColor:
                                                      AppColors.appRedColour,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                        Text(
                                          "total".tr,
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.darkBlue,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      earningDetailPopup(Get.context!);
                                      // Get.toNamed(RouteName.yourEarning);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "₹********",
                                              style: AppTextStyle.textStyle16(
                                                  fontColor:
                                                      AppColors.appRedColour,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                        Text(
                                          "total".tr,
                                          style: AppTextStyle.textStyle16(
                                              fontColor: AppColors.darkBlue,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteName.checkKundli);
                              },
                              child: Ink(
                                height: 54.h,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.appYellowColour,
                                      AppColors.gradientBottom
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                // alignment: Alignment.center,
                                child: Center(
                                  child: Text(
                                    "checkKundli".tr,
                                    style: AppTextStyle.textStyle14(
                                        fontColor: AppColors.brownColour,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteName.noticeBoard);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "noticeBoard".tr,
                              style: AppTextStyle.textStyle16(
                                  fontColor: AppColors.darkBlue,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "viewAll".tr,
                              style: AppTextStyle.textStyle12(
                                  fontColor: AppColors.darkBlue,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      senderCategoryWidget(),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: () async {
                          if (await PermissionHelper().askPermissions()) {
                            Get.toNamed(RouteName.liveTipsUI);
                          }
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.lightYellow,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 1.0,
                                offset: const Offset(0.0, 3.0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.appYellowColour,
                                AppColors.gradientBottom
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.images.icGoLive.svg(),
                              const SizedBox(width: 15),
                              Text(
                                "goLive".tr,
                                style: AppTextStyle.textStyle20(
                                    fontWeight: FontWeight.w700,
                                    fontColor: AppColors.brownColour),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                          height: 1.h,
                          color: AppColors.darkBlue.withOpacity(0.5)),
                      SizedBox(height: 10.h),
                      sessionTypeWidget(),
                      if (controller.homeData?.offerType != null &&
                          controller.homeData?.offerType != [])
                        offerTypeWidget(),
                      SizedBox(height: 10.h),
                      fullScreenBtnWidget(
                          imageName: Assets.images.icReferAFriend.svg(),
                          btnTitle: "referAnAstrologer".tr,
                          onbtnTap: () {
                            Get.toNamed(RouteName.referAstrologer);
                          }),
                      SizedBox(height: 10.h),
                      GetBuilder<HomeController>(
                        builder: (controller) => trainingVideoWidget(),
                      ),
                      SizedBox(height: 10.h),
                      fullScreenBtnWidget(
                          imageName: Assets.images.icEcommerce.svg(),
                          btnTitle: "eCommerce".tr,
                          onbtnTap: () async {
                            if (await PermissionHelper().askPermissions()) {
                              Get.toNamed(RouteName.videoCallPage);
                            }
                          }),
                      SizedBox(height: 20.h),
                      feedbackWidget(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
                Positioned(
                    right: 10.0,
                    top: Get.height * 0.4,
                    child: GestureDetector(
                      onTap: () {
                        controller.whatsapp();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.lightYellow,
                          borderRadius: BorderRadius.circular(25.0),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.appYellowColour,
                              AppColors.gradientBottom
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.images.icHelp.svg(),
                              Text(
                                "help".tr,
                                style: AppTextStyle.textStyle10(
                                    fontColor: AppColors.brownColour,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget senderCategoryWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.r)),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(RouteName.noticeDetail,
                arguments: controller.homeData?.noticeBoard,
                parameters: {"from_list": "0"});
          },
          child: Ink(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                border: Border.all(color: AppColors.lightYellow)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.homeData?.noticeBoard?.title ?? '',
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    Row(
                      children: [
                        Text(
                          '${dateToString(controller.homeData?.noticeBoard?.createdAt ?? DateTime.now(), format: "h:mm a")}  '
                          '${formatDateTime(controller.homeData?.noticeBoard?.createdAt! ?? DateTime.now())} ',
                          style: AppTextStyle.textStyle10(
                              fontWeight: FontWeight.w400,
                              fontColor: AppColors.darkBlue),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        GestureDetector(
                            onTap: (){
                              Fluttertoast.showToast(msg: "No info for now!");
                            },
                            child: Assets.images.icInfo.svg(height: 18.h, width: 18.h)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ReadMoreText(
                  controller.homeData?.noticeBoard?.description ?? '',
                  trimLines: 4,
                  colorClickableText: AppColors.blackColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: "readMore".tr,
                  trimExpandedText: "showLess".tr,
                  moreStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sessionTypeWidget() {
    return GetBuilder<HomeController>(
      builder: (controller) => Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "sessionType".tr,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.darkBlue),
                ),
                SizedBox(height: 16.h),
                Text(
                  "chat".tr.toUpperCase(),
                  style: AppTextStyle.textStyle12(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "₹${controller.homeData?.sessionType?.chatAmount}/Min",
                  style: AppTextStyle.textStyle10(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 16.h),
                Text(
                  "call".tr.toUpperCase(),
                  style: AppTextStyle.textStyle12(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "₹${controller.homeData?.sessionType?.chatAmount}/Min",
                  style: AppTextStyle.textStyle10(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 16.h),
                Text(
                  "videoCall".tr.toUpperCase(),
                  style: AppTextStyle.textStyle12(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "₹${controller.homeData?.sessionType?.videoCallAmount}/Min",
                  style: AppTextStyle.textStyle10(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "status".tr,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.darkBlue),
                ),
                SizedBox(height: 18.h),
                Obx(
                  () => SwitchWidget(
                    onTap: () => controller.chatSwitchFN(),
                    switchValue: controller.chatSwitch.value,
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => SwitchWidget(
                    onTap: () => controller.callSwitchFN(),
                    switchValue: controller.callSwitch.value,
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => SwitchWidget(
                    onTap: () => controller.videoCallSwitchFN(),
                    switchValue: controller.videoSwitch.value,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "nextOnlineTiming".tr,
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                        onTap: (){
                          Fluttertoast.showToast(msg: "No info for now!");
                        },
                        child: Assets.images.icInfo.svg(height: 16.h, width: 16.h)),
                  ],
                ),
                SizedBox(height: 15.h),
                Obx(() => controller.selectedChatTime.value.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectDateOrTime(
                            Get.context!,
                            title: "ScheduleOnlineDate".tr,
                            btnTitle: "confirmNextDate".tr,
                            pickerStyle: "DateCalendar",
                            looping: true,
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2050),
                            onConfirm: (value) =>controller.selectChatDate(value),
                            onChange: (value) =>
                                controller.selectChatDate(value),
                            onClickOkay: () {
                                selectDateOrTime(
                                  Get.context!,
                                  title: "scheduleOnlineTime".tr,
                                  btnTitle: "confirmOnlineTime".tr,
                                  pickerStyle: "TimeCalendar",
                                  looping: true,
                                  onConfirm: (value) =>controller.selectChatTime(value),
                                  onChange: (value) =>
                                      controller.selectChatTime(value),
                                  onClickOkay: () =>
                                      controller.scheduleCall("CHAT"),
                                );
                            },
                          );
                        },
                        child: Container(
                          width: 128.w,
                          height: 31.h,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.appYellowColour,
                                AppColors.gradientBottom
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              "scheduleNow".tr,
                              style: AppTextStyle.textStyle10(
                                  fontColor: AppColors.brownColour,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )
                    : const SelectedTimeForChat()),
                SizedBox(height: 15.h),
                //const SelectedTime(),
                Obx(() => controller.selectedCallTime.value.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectDateOrTime(
                            Get.context!,
                            title: "ScheduleOnlineDate".tr,
                            btnTitle: "confirmNextDate".tr,
                            pickerStyle: "DateCalendar",
                            looping: true,
                            lastDate: DateTime(2050),
                            onConfirm: (value) =>controller.selectCallDate(value),
                            onChange: (value) =>
                                controller.selectCallDate(value),
                            onClickOkay: () {
                              selectDateOrTime(
                                Get.context!,
                                title: "scheduleOnlineTime".tr,
                                btnTitle: "confirmOnlineTime".tr,
                                pickerStyle: "TimeCalendar",
                                looping: true,
                                onConfirm: (value)=>controller.selectCallTime(value),
                                onChange: (value) =>
                                    controller.selectCallTime(value),
                                onClickOkay: () =>
                                    controller.scheduleCall("CALL"),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 128.w,
                          height: 31.h,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.appYellowColour,
                                AppColors.gradientBottom
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              "scheduleNow".tr,
                              style: AppTextStyle.textStyle10(
                                  fontColor: AppColors.brownColour,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )
                    : const SelectedTimeForCall()),
                SizedBox(height: 15.h),
                Obx(() => controller.selectedVideoTime.value.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectDateOrTime(
                            Get.context!,
                            title: "ScheduleOnlineDate".tr,
                            btnTitle: "confirmNextDate".tr,
                            pickerStyle: "DateCalendar",
                            looping: true,
                            lastDate: DateTime(2050),
                            onConfirm: (value) =>controller.selectVideoDate(value),
                            onChange: (value) =>
                                controller.selectVideoDate(value),
                            onClickOkay: () {
                              selectDateOrTime(
                                Get.context!,
                                title: "scheduleOnlineTime".tr,
                                btnTitle: "confirmOnlineTime".tr,
                                pickerStyle: "TimeCalendar",
                                looping: true,
                                onConfirm: (value) =>controller.selectVideoTime(value),
                                onChange: (value) =>
                                    controller.selectVideoTime(value),
                                onClickOkay: () =>
                                    controller.scheduleCall("VIDEO"),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 128.w,
                          height: 31.h,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.appYellowColour,
                                AppColors.gradientBottom
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              "scheduleNow".tr,
                              style: AppTextStyle.textStyle10(
                                fontColor: AppColors.brownColour,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SelectedTimeForVideoCall()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget offerTypeWidget() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 3.0)),
            ],
            color: AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "offerType".tr,
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.darkBlue,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "status".tr,
                        style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                          onTap: (){
                            Fluttertoast.showToast(msg: "No info for now!");
                          },
                          child: Assets.images.icInfo.svg(height: 16.h, width: 16.h)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.homeData?.offerType?.length ?? 0,
                separatorBuilder: (context, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${controller.homeData?.offerType?[index].offerName}"
                                .toUpperCase(),
                            style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if ((controller
                                      .homeData?.offerType?[index].callRate ??
                                  0) >
                              0)
                            CustomText(
                              " (₹${controller.homeData?.offerType?[index].callRate}/min)"
                                  .toUpperCase(),
                              fontSize: 10.sp,
                            ),
                        ],
                      ),
                      Obx(
                        () => SwitchWidget(
                          onTap: () {
                            if (controller.offerTypeLoading.value !=
                                Loading.loading) {
                              controller.updateOfferType(
                                  !controller.promotionOfferSwitch[index],
                                  controller.homeData?.offerType?[index].id ??
                                      0,
                                  index);
                            }
                          },
                          switchValue: controller.promotionOfferSwitch[index],
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Text(
              //           "promotionOffer".tr,
              //           style: AppTextStyle.textStyle12(
              //               fontWeight: FontWeight.w700,
              //               fontColor: AppColors.darkBlue),
              //         ),
              //         Text(
              //           "  (₹5/Min)",
              //           style: AppTextStyle.textStyle10(
              //               fontWeight: FontWeight.w400,
              //               fontColor: AppColors.darkBlue),
              //         ),
              //       ],
              //     ),
              //     Obx(
              //       () => SwitchWidget(
              //         onTap: () => controller.promotionOfferSwitch.value =
              //             !controller.promotionOfferSwitch.value,
              //         switchValue: controller.promotionOfferSwitch.value,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fullScreenBtnWidget({
    required Widget imageName,
    required String? btnTitle,
    required VoidCallback? onbtnTap,
  }) {
    return Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0.0, 3.0),
            ),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          onTap: onbtnTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageName,
              SizedBox(width: 5.w),
              Text(
                btnTitle ?? "",
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w600, fontColor: AppColors.darkBlue),
              )
            ],
          ),
        ));
  }

  Widget trainingVideoWidget() {
    if (controller.homeData?.trainingVideo == null ||
        (controller.homeData?.trainingVideo ?? []).isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      height: 238.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.appYellowColour, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
            offset: const Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Row(
              children: [
                Text(
                  "trainingVideos".tr,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w500),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(msg: "No info for now!");
                    },
                    child: Assets.images.icInfo.svg(height: 16.h, width: 16.h)),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.homeData?.trainingVideo?.length ?? 0,
              separatorBuilder: (context, i) => SizedBox(width: 10.w),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() {
                          return TrainingVideoUI(
                            video: controller.homeData?.trainingVideo?[index],
                          );
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.extraLightGrey,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        height: 174.h,
                        width: 110.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.sp),
                          child: LoadImage(
                            boxFit: BoxFit.cover,
                            imageModel: ImageModel(
                              imagePath: getYoutubeThumbnail(controller
                                      .homeData?.trainingVideo?[index].url ??
                                  ''),
                              loadingIndicator: const SizedBox(
                                child: CircularProgressIndicator(
                                  color: Color(0XFFFDD48E),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget feedbackWidget() {
    return Container(
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffEDEDED),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3.0,
              offset: const Offset(0.3, 3.0)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "anyFeedbacks".tr,
              style: AppTextStyle.textStyle16(fontColor: AppColors.darkBlue),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "feedbacksText".tr,
              style: AppTextStyle.textStyle14(fontColor: AppColors.darkBlue),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                maxLines: 6,
                maxLength: 96,
                keyboardType: TextInputType.text,
                controller: controller.feedBackText,
                textInputAction: TextInputAction.done,
                onTapOutside: (value) => FocusScope.of(Get.context!).unfocus(),
                decoration: InputDecoration(
                  hintText: "feedbackHintText".tr,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightGrey,
                  ),
                  helperStyle: AppTextStyle.textStyle16(),
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.appYellowColour,
                        width: 1.0,
                      )),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                if (controller.feedBackText.text.isEmpty) {
                  divineSnackBar(
                      data: "${'feedbackValidation'.tr}.",
                      color: AppColors.redColor);
                } else {
                  controller.sendFeedbackAPI(controller.feedBackText.text);
                }
              },
              child: Center(
                child: Container(
                    width: ScreenUtil().screenWidth / 1.5,
                    height: 56,
                    decoration: BoxDecoration(
                        color: AppColors.lightYellow,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      "submitFeedback".tr,
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w600,
                          fontColor: AppColors.brownColour),
                    ))),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  earningDetailPopup(BuildContext context) async {
    await openBottomSheet(context,
        functionalityWidget: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Actual Payment:",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.appRedColour),
                  ),
                  Text(
                    "₹1000000000",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.appRedColour),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            ExpandedTile(
              theme: const ExpandedTileThemeData(
                headerPadding: EdgeInsets.only(left: 8.0, right: 0.0),
                contentPadding: EdgeInsets.only(left: 25.0, right: 25.0),
                contentBackgroundColor: AppColors.white,
                headerColor: AppColors.white,
              ),
              controller: controller.expandedTileController!,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${'actualPayment'.tr}:",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                  Text(
                    "₹1000000000",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '-${'amount'.tr}:',
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                      Text(
                        "₹1000000000",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-${'lastBillingCycle'.tr}",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 12.h),
                          Text(
                            "${'refund'.tr}:",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue.withOpacity(0.5)),
                          ),
                        ],
                      ),
                      Text(
                        "₹1000000000",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 12.h),
                            Text(
                              "Supplement:",
                              style: AppTextStyle.textStyle12(
                                  fontWeight: FontWeight.w500,
                                  fontColor:
                                      AppColors.darkBlue.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "₹1000000000",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            ExpandedTile(
                controller: controller.expandedTile2Controller!,
                theme: const ExpandedTileThemeData(
                  headerPadding: EdgeInsets.only(left: 8.0, right: 0.0),
                  contentPadding: EdgeInsets.only(left: 25.0, right: 25.0),
                  contentBackgroundColor: AppColors.white,
                  headerColor: AppColors.white,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${'totalTax'.tr}:",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                    Text(
                      "₹1000000000",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "-TDS:",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue.withOpacity(0.5)),
                          ),
                        ),
                        Text(
                          "₹1000000000",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.darkBlue.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "-${'paymentGateway'.tr}:",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w500,
                                fontColor: AppColors.darkBlue.withOpacity(0.5)),
                          ),
                        ),
                        Text(
                          "₹1000000000",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.darkBlue.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${'status'.tr}:",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Text(
                    "toBeSettled".tr,
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "timePeriod".tr,
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                    ),
                  ),
                  Text(
                    "16th May 2023 - 23rd May 2023",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ));
  }
}

class SelectedTimeForChat extends GetView<HomeController> {
  const SelectedTimeForChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31.h,
      child: Obx(
        () {
          if (controller.selectedChatTime.value.isNotEmpty) {
            return Text(
              "${controller.selectedChatDate.value.toCustomFormat()} ${controller.selectedChatTime.value}",
              style: AppTextStyle.textStyle10(
                fontColor: AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller.selectedChatDate.value.toCustomFormat(),
              style: AppTextStyle.textStyle10(
                fontColor: AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        },
      ),
    );
  }
}

class PerformanceDialog extends StatelessWidget {
  PerformanceDialog({super.key});

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Builder(
        builder: (context) {
          return GetBuilder<HomeController>(
              id: "score_update",
              builder: (controller) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "${'payAttention'.tr}!",
                            style: AppTextStyle.textStyle20(
                                fontColor: AppColors.redColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Container(
                            width: 230.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3.0,
                                    offset: const Offset(0.0, 3.0)),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 16.h),
                                Center(
                                  child: Text(
                                    controller.yourScore[controller.scoreIndex]
                                        ['title'],
                                    style: AppTextStyle.textStyle14(
                                        fontColor: AppColors.blackColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Assets.images.bgMeterFinal
                                        .svg(width: 190.h),
                                    Column(
                                      children: [
                                        SizedBox(height: 60.h),
                                        Text(
                                          "Your Score",
                                          style: AppTextStyle.textStyle10(
                                              fontColor: AppColors.darkBlue),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          controller.yourScore[
                                              controller.scoreIndex]['score'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.darkBlue,
                                              fontSize: 20.sp),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          "Out of 100",
                                          style: AppTextStyle.textStyle10(
                                              fontColor: AppColors.darkBlue),
                                        ),
                                      ],
                                    ),
                                    /*Center(
                                              child: SizedBox(
                                                height: 140.h,
                                                width: 280.h,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 10.w,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "0",
                                                            style: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          SizedBox(
                                                            width: 240.w,
                                                          ),
                                                          Text(
                                                            "100",
                                                            style: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 25.h,
                                                      left: 70.w,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "25",
                                                            style: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          SizedBox(
                                                            width: 110.w,
                                                          ),
                                                          Text(
                                                            "50",
                                                            style: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),*/
                                  ],
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onPreviousTap();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "previous".tr,
                                        style: AppTextStyle.textStyle16(
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.darkBlue),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onNextTap();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "next".tr,
                                        style: AppTextStyle.textStyle16(
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.darkBlue),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        controller.scoreIndex == controller.yourScore.length - 1
                            ? GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.appYellowColour,
                                          AppColors.gradientBottom
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "close".tr,
                                        style: AppTextStyle.textStyle16(
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.brownColour),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  dashboardController.selectedIndex.value = 1;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "viewScore".tr,
                                        style: AppTextStyle.textStyle16(
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

class SelectedTimeForCall extends GetView<HomeController> {
  const SelectedTimeForCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31.h,
      child: Obx(
        () {
          if (controller.selectedCallTime.value.isNotEmpty) {
            return Text(
              "${controller.selectedCallDate.value.toCustomFormat()} ${controller.selectedCallTime.value}",
              style: AppTextStyle.textStyle10(
                fontColor: AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller.selectedCallDate.value.toCustomFormat(),
              style: AppTextStyle.textStyle10(
                fontColor: AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        },
      ),
    );
  }
}

class SelectedTimeForVideoCall extends GetView<HomeController> {
  const SelectedTimeForVideoCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31.h,
      child: Obx(
        () {
          if (controller.selectedVideoTime.value.isNotEmpty) {
            return Text(
              "${controller.selectedVideoDate.value.toCustomFormat()} ${controller.selectedVideoTime.value}",
              style: AppTextStyle.textStyle10(
                fontColor: AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller.selectedVideoDate.value.toCustomFormat(),
              style: AppTextStyle.textStyle10(
                fontColor: AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        },
      ),
    );
  }
}
