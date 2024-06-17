import 'package:divine_astrologer/common/app_textstyle.dart';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_widget_marquee.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';

import 'package:divine_astrologer/common/switch_component.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/astrologer_training_session_response.dart';
import 'package:divine_astrologer/model/home_model/astrologer_live_data_response.dart';
import 'package:divine_astrologer/model/home_page_model_class.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/model/wallet_deatils_response.dart';
import 'package:divine_astrologer/pages/home/widgets/offer_bottom_widget.dart';
import 'package:divine_astrologer/pages/home/widgets/training_video.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_ui.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/screens/order_feedback/widget/feedback_card_widget.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/load_image.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common/routes.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/constants.dart';
import '../../gen/fonts.gen.dart';
import '../../model/feedback_response.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'home_controller.dart';
import 'widgets/common_info_sheet.dart';
import 'widgets/retention_widget.dart';

class HomeUI extends GetView<HomeController> {
  const HomeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("beforeGoing 5 - ${preferenceService.getUserDetail()?.id}");
    return GetBuilder<HomeController>(
        assignId: true,
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
              key: controller.homeScreenKey,
              backgroundColor: appColors.white,
              drawer: const SideMenuDrawer(),
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () =>
                      controller.homeScreenKey.currentState?.openDrawer(),
                  highlightColor: appColors.transparent,
                  splashColor: appColors.transparent,
                  icon: const Icon(Icons.menu),
                ),
                titleSpacing: 0,
                surfaceTintColor: Colors.transparent,
                backgroundColor: appColors.white,
                elevation: 0,
                centerTitle: false,
                title: Text(
                  controller.appbarTitle.value,
                  style: AppTextStyle.textStyle15(
                    fontWeight: FontWeight.w400,
                    fontColor: appColors.darkBlue,
                  ),
                ),
                actions: [
                  Column(
                    key: Get.find<DashboardController>().keyHide,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.isShowTitle.value =
                              !controller.isShowTitle.value;
                          controller.update();
                        },
                        child: controller.isShowTitle.value
                            ? Assets.images.icVisibility.svg()
                            : Assets.images.icVisibilityOff.svg(),
                      ),
                      Text(
                        !controller.isShowTitle.value ? "unHide".tr : "hide".tr,
                        style: AppTextStyle.textStyle13(
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.textColor),
                      )
                    ],
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    key: Get.find<DashboardController>().keyProfileHome,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.userImage.contains("null") ||
                              controller.userImage.isEmpty ||
                              controller.userImage == ""
                          ? SizedBox(
                              height: 24.h,
                              width: 24.h,
                            )
                          : CommonImageView(
                              imagePath: controller.userImage,
                              fit: BoxFit.cover,
                              height: 24.h,
                              width: 24.h,
                              placeHolder: Assets.images.defaultProfile.path,
                              radius: BorderRadius.circular(100.h),
                              onTap: () async {
                                Get.toNamed(RouteName.profileUi);
                              },
                            ),
                      Text(
                        "profile".tr,
                        style: AppTextStyle.textStyle13(
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.textColor),
                      )
                    ],
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              body: LayoutBuilder(builder: (context, constraints) {
                final double maxHeight = constraints.maxHeight;
                final double maxWidth = constraints.maxWidth;
                if (controller.loading == Loading.loaded) {
                  return Stack(children: [
                    SingleChildScrollView(
                      // padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    key: Get.find<DashboardController>()
                                        .keyTodayAmount,
                                    child: controller.isShowTitle.value
                                        ? InkWell(
                                            onTap: () {},
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "₹${abbreviateNumber(controller.homeData?.todaysEarning?.toStringAsFixed(2))}",
                                                  // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                  style:
                                                      AppTextStyle.textStyle16(
                                                          fontColor: appColors
                                                              .appRedColour,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                Text(
                                                  "today".tr,
                                                  style:
                                                      AppTextStyle.textStyle16(
                                                          fontColor: appColors
                                                              .darkBlue,
                                                          fontWeight:
                                                              FontWeight.w400),
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
                                                  style:
                                                      AppTextStyle.textStyle16(
                                                          fontColor: appColors
                                                              .appRedColour,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                Text(
                                                  "today".tr,
                                                  style:
                                                      AppTextStyle.textStyle16(
                                                          fontColor: appColors
                                                              .darkBlue,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  // SizedBox(width: 15.w),
                                  Expanded(
                                    key: Get.find<DashboardController>()
                                        .keyTotalAmount,
                                    child: controller.isShowTitle.value
                                        ? InkWell(
                                            onTap: () {
                                              earningDetailPopup(Get.context!,
                                                  controller: controller);
                                              // Get.toNamed(RouteName.yourEarning);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "₹${abbreviateNumber(controller.homeData?.totalEarning?.toStringAsFixed(2))}",
                                                      style: AppTextStyle
                                                          .textStyle16(
                                                              fontColor: appColors
                                                                  .appRedColour,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  "total"
                                                      .trParams({"count": ""}),
                                                  style:
                                                      AppTextStyle.textStyle16(
                                                          fontColor: appColors
                                                              .darkBlue,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              earningDetailPopup(Get.context!,
                                                  controller: controller);
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
                                                      style: AppTextStyle
                                                          .textStyle16(
                                                              fontColor: appColors
                                                                  .appRedColour,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  "total"
                                                      .trParams({"count": ""}),
                                                  style:
                                                      AppTextStyle.textStyle16(
                                                          fontColor: appColors
                                                              .darkBlue,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  // SizedBox(width: 10.w),
                                  InkWell(
                                    key: Get.find<DashboardController>()
                                        .keyCheckKundli,
                                    onTap: () {
                                      Get.toNamed(RouteName.checkKundli);
                                    },
                                    child: Ink(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: appColors.guideColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      // alignment: Alignment.center,
                                      child: Center(
                                        child: Text(
                                          "checkKundli".tr,
                                          style: AppTextStyle.textStyle12(
                                              fontColor: appColors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          /// new widget
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                Expanded(
                                    key: Get.find<DashboardController>()
                                        .keyRetentionRate,
                                    child: RetentionWidget(
                                      isEligible: true,
                                      title:
                                          "${"bonusWallet".tr} \n ₹${abbreviateNumber(controller.homeData?.bonusWallet)}",
                                      subTitle:
                                          "${"retentionRate".tr} \n ${controller.homeData?.retention ?? 0}%",
                                      borderColor:
                                          (controller.homeData!.retention! <
                                                  controller.homeData!
                                                      .minimumRetention!)
                                              ? appColors.red
                                              : appColors.green,
                                      onTap: () async {
                                        if (!controller.isOpenBonusSheet) {
                                          controller.isOpenBonusSheet = true;
                                          controller.update();
                                          await controller
                                              .getWalletPointDetail(2);
                                          ecommerceWalletDetailPopup(
                                              Get.context!,
                                              controller.walletData,
                                              title: "What is Bonus Wallet ?",
                                              controller: controller,
                                              type: 2);
                                        }
                                      },
                                    )),
                                SizedBox(width: 7.w),
                                Expanded(
                                  key: Get.find<DashboardController>()
                                      .keyRepurchaseRate,
                                  child: RetentionWidget(
                                    title:
                                        "${"paidWallet".tr} \n ₹${abbreviateNumber(controller.homeData?.paidWallet)}",
                                    subTitle:
                                        "${"rePurchaseRate".tr} \n ${controller.homeData?.repurchaseRate ?? 0}%",
                                    borderColor:
                                        (controller.homeData!.repurchaseRate! <
                                                controller.homeData!
                                                    .minimumRepurchaseRate!)
                                            ? appColors.red
                                            : appColors.green,
                                    onTap: () async {
                                      if (!controller.isOpenPaidSheet) {
                                        controller.isOpenPaidSheet = true;
                                        controller.update();
                                        await controller
                                            .getWalletPointDetail(1);
                                        ecommerceWalletDetailPopup(
                                            Get.context!, controller.walletData,
                                            title: "What is Paid Wallet ?",
                                            controller: controller,
                                            type: 1);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 7.w),
                                Expanded(
                                    key: Get.find<DashboardController>()
                                        .keyEcommerceWallet,
                                    child: RetentionWidget(
                                      borderColor: appColors.textColor,
                                      bottomTextColor: appColors.textColor,
                                      bottomColor: appColors.transparent,
                                      onTap: () async {
                                        if (!controller.isOpenECommerceSheet) {
                                          controller.isOpenECommerceSheet =
                                              true;
                                          controller.update();
                                          await controller
                                              .getWalletPointDetail(3);
                                          ecommerceWalletDetailPopup(
                                              Get.context!,
                                              controller.walletData,
                                              title:
                                                  "What is Ecommerce Wallet ?",
                                              controller: controller,
                                              type: 3);
                                        }
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            "ecommerceWallet".tr,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.center,
                                            fontSize: 9.sp,
                                            fontColor: appColors.textColor,
                                          ),
                                          SizedBox(height: 5.h),
                                          CustomText(
                                            "₹${abbreviateNumber(controller.homeData?.ecommerceWallet)}",
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                            fontSize: 9.sp,
                                            fontColor: appColors.textColor,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: CustomText(
                                (controller.homeData!.retention! <
                                        controller.homeData!.minimumRetention!)
                                    ? "notEligibleBonus".tr
                                    : "eligibleBonus".tr,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.start,
                                fontSize: 14,
                                fontColor: !(controller.homeData!.retention! <
                                        controller.homeData!.minimumRetention!)!
                                    ? appColors.green
                                    : appColors.red,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Obx(
                            () => controller.isFeedbackAvailable.value
                                ? controller.homeData?.feedback == null
                                    ? const SizedBox.shrink()
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    RouteName.orderFeedback,
                                                    arguments: [
                                                      controller.feedbacksList
                                                    ]);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Order Feedback',
                                                    style: AppTextStyle
                                                        .textStyle16(
                                                            fontColor: appColors
                                                                .darkBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                  Text(
                                                    "viewAll".tr,
                                                    style: AppTextStyle
                                                        .textStyle12(
                                                            fontColor: appColors
                                                                .darkBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            FeedbackCardWidget(
                                                feedback: controller
                                                        .homeData?.feedback ??
                                                    FeedbackData(
                                                      id: controller.homeData
                                                          ?.feedback?.id,
                                                      orderId: controller
                                                          .homeData
                                                          ?.feedback
                                                          ?.orderId,
                                                      remark: controller
                                                          .homeData
                                                          ?.feedback
                                                          ?.remark,
                                                      order: OrderDetails(
                                                        astrologerId: controller
                                                            .homeData
                                                            ?.feedback
                                                            ?.order
                                                            ?.astrologerId,
                                                        id: controller
                                                            .homeData
                                                            ?.feedback
                                                            ?.order
                                                            ?.id,
                                                        productType: controller
                                                            .homeData
                                                            ?.feedback
                                                            ?.order
                                                            ?.productType,
                                                        orderId: controller
                                                            .homeData
                                                            ?.feedback
                                                            ?.order
                                                            ?.orderId,
                                                        createdAt: controller
                                                            .homeData
                                                            ?.feedback
                                                            ?.order
                                                            ?.createdAt,
                                                      ),
                                                    )),
                                            SizedBox(height: 10.h),
                                          ],
                                        ),
                                      )
                                : const SizedBox(),
                          ),
                          // SizedBox(height: 10.h),
                          // availableFeedbackWidget(controller.feedbackResponse ?? FeedbackData()),
                          // SizedBox(height: 10.h),
                          controller.homeData?.noticeBoard == null
                              ? const SizedBox()
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(RouteName.noticeBoard);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "noticeBoard".tr,
                                              style: AppTextStyle.textStyle16(
                                                  fontColor: appColors.darkBlue,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "viewAll".tr,
                                              style: AppTextStyle.textStyle12(
                                                  fontColor: appColors.darkBlue,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      noticeBoardWidget(controller: controller),
                                    ],
                                  ),
                                ),
                          // SizedBox(height: 10.h),
                          // noticeBoardWidget(),
                          SizedBox(height: 15.h),

                          /// marquree
                          // Obx(() {
                          //   return Visibility(
                          //     visible: controller.marqueeText.isNotEmpty,
                          //     child: Container(
                          //       margin: EdgeInsets.only(bottom: 15.h),
                          //       height: 45.h,
                          //       color: appColors.marqueeBgColor,
                          //       child: CustomWidgetMarquee(
                          //         child: ListView(
                          //           padding: EdgeInsets.zero,
                          //           scrollDirection: Axis.horizontal,
                          //           shrinkWrap: true,
                          //           children: List.generate(
                          //             controller.marqueeText.length,
                          //             (index) {
                          //               return Container(
                          //                   alignment:
                          //                       AlignmentDirectional.center,
                          //                   child: HtmlWidget(
                          //                     controller.marqueeText[index],
                          //                   ));
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   );
                          // }),

                          Obx(() {
                            return Visibility(
                              visible: controller.marqueeText.value.isNotEmpty,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5.h),
                                height: 50.h,
                                color: appColors.marqueeBgColor,
                                child: Marquee(
                                  text: Utils().parseHtmlString(
                                      controller.marqueeText.value),
                                  style: TextStyle(
                                    color: appColors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: FontFamily.metropolis,
                                  ),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 20.0,
                                  velocity: 60.0,
                                  startPadding: 10.0,
                                  accelerationCurve: Curves.linear,
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            );
                          }),
                          scheduledTrainingWidgetUpdated(),
                          // viewKundliWidget(),
                          viewKundliWidgetUpdated(),
                          Obx(() {
                            return Visibility(
                              visible: controller.isLiveMonitor.value == 1,
                              child: Column(
                                children: [
                                  liveWidgetUpdated(),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            );
                          }),
                          Obx(
                            () {
                              return isLive.value == 1
                                  ? controller.isLiveEnable.value
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10.h),
                                              GestureDetector(
                                                onTap: () async {
                                                  bool hasOpenOrder = false;
                                                  // hasOpenOrder = await controller.hasOpenOrder();
                                                  if (hasOpenOrder) {
                                                    // divineSnackBar(
                                                    //   data:
                                                    //       "Unable to Go Live due to your active order.",
                                                    //   color: appColors.guideColor,
                                                    //   duration: const Duration(seconds: 6),
                                                    // );
                                                  } else {
                                                    bool isChatOn =
                                                        chatSwitch.value;
                                                    bool isAudioCallOn =
                                                        callSwitch.value;
                                                    bool isVideoCallOn =
                                                        videoSwitch.value;
                                                    if (isChatOn == false &&
                                                        isAudioCallOn ==
                                                            false &&
                                                        isVideoCallOn ==
                                                            false) {
                                                      await Get.toNamed(
                                                          RouteName.liveTipsUI);
                                                    } else {
                                                      divineSnackBar(
                                                        data:
                                                            "Please turn off all session types in order to go live.",
                                                        color: appColors
                                                            .guideColor,
                                                        duration:
                                                            const Duration(
                                                                seconds: 6),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: appColors.guideColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        blurRadius: 1.0,
                                                        offset: const Offset(
                                                            0.0, 3.0),
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Assets.images.icGoLive
                                                          .svg(
                                                              color:
                                                                  Colors.white),
                                                      const SizedBox(width: 15),
                                                      Text(
                                                        "goLive".tr,
                                                        style: AppTextStyle
                                                            .textStyle20(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontColor:
                                                              appColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox();
                            },
                          ),
                          SizedBox(height: 10.h),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              height: 1.h,
                              color: appColors.darkBlue.withOpacity(0.5)),
                          SizedBox(height: 10.h),
                          Obx(
                            () {
                              final bool cond1 = controller.isCallEnable.value;
                              final bool cond2 = controller.isChatEnable.value;
                              final bool cond3 =
                                  controller.isVideoCallEnable.value;

                              return cond1 || cond2 || cond3
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: sessionTypeWidget(
                                          controller: controller))
                                  : const SizedBox();
                            },
                          ),
                          // if (controller.homeData?.offerType != null &&
                          //     controller.homeData?.offerType != [])
                          //   offerTypeWidget(),
                          controller.homeData?.offers?.orderOffer!.length != 0
                              ? Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: orderOfferWidget(
                                      homeController: controller))
                              : const SizedBox(),
                          controller.homeData?.offers?.customOffer!.length != 0
                              ? Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: customerOfferWidget(context,
                                      controller: controller),
                                )
                              : const SizedBox(),
                          // SizedBox(height: 10.h),
                          // fullScreenBtnWidget(
                          //     imageName: Assets.images.icReferAFriend.svg(),
                          //     btnTitle: "referAnAstrologer".tr,
                          //     onbtnTap: () {
                          //       Get.toNamed(RouteName.referAstrologer);
                          //     }),
                          SizedBox(height: 10.h),
                          trainingVideoWidget(controller: controller),
                          /*  SizedBox(height: 10.h),
                          fullScreenBtnWidget(
                              imageName: Assets.images.icEcommerce.svg(),
                              btnTitle: "eCommerce".tr,
                              onbtnTap: () async {
                                if (await PermissionHelper().askPermissions()) {
                                  Get.toNamed(RouteName.videoCallPage);
                                }
                              }),*/
                          SizedBox(height: 20.h),
                          feedbackWidget(controller: controller),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                    Positioned(
                        top: controller.yPosition,
                        left: controller.xPosition + 10,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: GestureDetector(
                              onPanUpdate: (tapInfo) {
                                double newXPosition =
                                    controller.xPosition + tapInfo.delta.dx;
                                double newYPosition =
                                    controller.yPosition + tapInfo.delta.dy;

                                // Ensure newXPosition is within screen bounds
                                newXPosition = newXPosition.clamp(
                                    0.0,
                                    maxWidth -
                                        50); // Assuming widget width is 50
                                newYPosition = newYPosition.clamp(
                                    0,
                                    maxHeight -
                                        50); // Assuming widget height is 50

                                controller.xPosition = newXPosition;
                                controller.yPosition = newYPosition;
                                controller.update();
                              },
                              onPanEnd: (details) {
                                if (controller.xPosition + 25 < Get.width / 2) {
                                  controller.xPosition = 0;
                                } else {
                                  controller.xPosition = Get.width - 70;
                                }

                                controller.update();
                              },
                              onTap: () {
                                controller.whatsapp();
                              },
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: appColors.guideColor,
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Assets.images.icHelp
                                            .svg(color: appColors.white),
                                        Text(
                                          "help".tr,
                                          style: AppTextStyle.textStyle10(
                                              fontColor: appColors.white,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ))),
                        ))
                  ]);
                } else {
                  return Container(color: Colors.white);
                }
              }));
        });
  }

  Widget viewKundliWidgetUpdated() {
    return Obx(() {
      var data = callKunadliUpdated.value;

      return !mapEquals(data, {})
          ? Container(
              margin: EdgeInsets.only(
                bottom: 10.h,
                left: 20.w,
                right: 20.w,
              ),
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3.0,
                    offset: const Offset(0, 3.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Id : ${data?["orderId"]}',
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${DateFormat("dd MMMM yyyy, hh:mm a").format(DateTime.now())}',
                          style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.darkBlue.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'On-Going CALL',
                      style:
                          AppTextStyle.textStyle12(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'with ${data["userName"]}(${data["userId"]})',
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue.withOpacity(.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gender: ${data["gender"]}',
                      style:
                          AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DOB: ${data["dob"]}',
                      style:
                          AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TOB: ${data["tob"]}',
                      style:
                          AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'POB: ${data["pob"]}',
                      style:
                          AppTextStyle.textStyle10(fontWeight: FontWeight.w400),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Marital Status: ${data["marital"]}',
                                style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Problem Area: ${data["problem"]}',
                                maxLines: 1,
                                style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            DateTime time = DateFormat('d MMMM yyyy h:mm a')
                                .parse('${data["dob"]} ${data["tob"]}');
                            print(data);
                            print("datadatadatadatadata");
                            Params params = Params(
                              day: time.day,
                              month: time.month,
                              hour: time.hour,
                              min: time.minute,
                              lat: double.parse(data["latitude"] ?? "0.0"),
                              long: double.parse(data["longitude"] ?? "0.0"),
                              location: data["pob"],
                              year: time.year,
                              name: data["userName"],
                            );
                            Get.toNamed(
                              RouteName.kundliDetail,
                              arguments: {
                                "kundli_id": data["kundli_id"],
                                "from_kundli": false,
                                "params": params,
                              },
                            );
                          },
                          child: Container(
                            height: 54.h,
                            decoration: BoxDecoration(
                              color: appColors.guideColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            // alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                "View Kundali",
                                style: AppTextStyle.textStyle14(
                                    fontColor: appColors.whiteGuidedColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : const SizedBox();
    });
  }

  Widget noticeBoardWidget({HomeController? controller}) {
    return controller!.homeData != null
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            child: Material(
              color: appColors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RouteName.noticeDetail,
                      arguments: controller!.homeData?.noticeBoard,
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
                      border: Border.all(color: appColors.guideColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: CustomText(
                              controller.homeData?.noticeBoard?.title ?? '',
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.darkBlue,
                              maxLines: 2,
                              fontSize: 16.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${dateToString(controller.homeData?.noticeBoard?.createdAt ?? DateTime.now(), format: "h:mm a")}  '
                                '${formatDateTime(controller.homeData?.noticeBoard?.createdAt ?? DateTime.now())} ',
                                style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w400,
                                    fontColor: appColors.darkBlue),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(CommonInfoSheet(
                                      title: "noticeBoard".tr,
                                      subTitle: "noticeBoardDes".tr,
                                      argument:
                                          controller.homeData?.noticeBoard,
                                    ));
                                  },
                                  child: Assets.images.icInfo
                                      .svg(height: 18.h, width: 18.h)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      /*Html(
                  data: controller.homeData?.noticeBoard?.description ?? '',
                  onLinkTap: (url, __, ___) {
                    launchUrl(Uri.parse(url ?? ''));
                  },
                ),
                ReadMoreText(
                  controller.homeData?.noticeBoard?.description ?? '',
                  trimLines: 4,
                  colorClickableText: appColors.blackColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: "readMore".tr,
                  trimExpandedText: "showLess".tr,
                  moreStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: appColors.blackColor,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: appColors.blackColor,
                  ),
                ),*/
                      ExpandableHtml(
                        htmlData:
                            controller.homeData?.noticeBoard?.description ?? "",
                        trimLength: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget scheduledTrainingWidgetUpdated() {
    return Visibility(
      visible: controller.astrologerTrainingSessionLst.isNotEmpty,
      child: ListView.builder(
        itemCount: controller.astrologerTrainingSessionLst.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          AstrologerTrainingSessionModel model =
              controller.astrologerTrainingSessionLst[index];

          return Container(
            margin: EdgeInsets.only(
              bottom: 15.h,
              left: 20.w,
              right: 20.w,
            ),
            width: ScreenUtil().screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: appColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3.0,
                  offset: const Offset(0, 3.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Scheduled Training',
                          style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Visibility(
                        visible: model.isStart == "1",
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: appColors.green, width: 1.5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            'Started',
                            style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w600,
                              fontColor: appColors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Training Purpose -',
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          model.trainingPurpose,
                          maxLines: 5,
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Date & Time -',
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          controller.convertCustomDateTime(model.meetingDate,
                              "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy, hh:mm a"),
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Training Duration -',
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          // '2 Hours',
                          controller.getHoursFromDuration(model.duration),
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      GestureDetector(
                        onTap: () {
                          String meetingLink = model.link;
                          openZoomMeeting(meetingLink);
                        },
                        child: Container(
                          width: 80.w,
                          height: 31.h,
                          decoration: BoxDecoration(
                            color: appColors.guideColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          // alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              "Join",
                              style: AppTextStyle.textStyle14(
                                  fontColor: appColors.whiteGuidedColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget liveWidgetUpdated() {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
        left: 20.w,
        right: 20.w,
      ),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            offset: const Offset(0, 3.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'dailyLiveTimeRemaining_'.tr,
                  style: AppTextStyle.textStyle13(
                    fontWeight: FontWeight.w400,
                    fontColor: appColors.black,
                  ),
                ),
                SizedBox(width: 5.h),
                Text(
                  '${controller.todaysRemaining.value} Mins',
                  style: AppTextStyle.textStyle13(
                    fontWeight: FontWeight.w600,
                    fontColor: appColors.red,
                  ),
                ),
                SizedBox(width: 8.h),
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: "No info for now!");
                  },
                  child: Assets.images.icInfo.svg(width: 18, height: 18),
                ),
                const Expanded(child: SizedBox()),
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      controller.isOpenLivePayment.value =
                          !controller.isOpenLivePayment.value;
                    },
                    child: controller.isOpenLivePayment.value
                        ? Assets.images.icUpArrow.svg(width: 11, height: 11)
                        : Assets.images.icDownArrow.svg(width: 11, height: 11),
                  );
                })
              ],
            ),
            Obx(() {
              return Visibility(
                visible: controller.isOpenLivePayment.value,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      color: appColors.grey,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'date'.tr,
                            textAlign: TextAlign.start,
                            style: AppTextStyle.textStyle13(
                              fontWeight: FontWeight.w600,
                              fontColor: appColors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          'remainingMinutes'.tr,
                          style: AppTextStyle.textStyle13(
                            fontWeight: FontWeight.w600,
                            fontColor: appColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    controller.weekLst.isEmpty
                        ? Container(
                            height: 100.h,
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              "noAnyDataFound".tr,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: appColors.grey,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.weekLst.length,
                            itemBuilder: (context, index) {
                              Weeks model = controller.weekLst[index];

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${controller.getWeeks((model.weekNo!))} ${'weeksHoursRemaining'.tr}',
                                          textAlign: TextAlign.start,
                                          style: AppTextStyle.textStyle13(
                                            fontWeight: FontWeight.w500,
                                            fontColor: appColors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.h),
                                      model.remainingLiveMinute == "0"
                                          ? Text(
                                              'done'.tr,
                                              textAlign: TextAlign.start,
                                              style: AppTextStyle.textStyle13(
                                                fontWeight: FontWeight.w600,
                                                fontColor: appColors.green,
                                              ),
                                            )
                                          : Text(
                                              '${model.remainingLiveMinute} ${'minutes'.tr}',
                                              textAlign: TextAlign.start,
                                              style: AppTextStyle.textStyle13(
                                                fontWeight: FontWeight.w600,
                                                fontColor: appColors.red,
                                              ),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              );
                            },
                          ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Compulsory Live Days -',
                              //       style: AppTextStyle.textStyle13(
                              //         fontWeight: FontWeight.w400,
                              //         fontColor: appColors.black,
                              //       ),
                              //     ),
                              //     SizedBox(width: 5.h),
                              //     Text(
                              //       '21',
                              //       style: AppTextStyle.textStyle13(
                              //         fontWeight: FontWeight.w600,
                              //         fontColor: appColors.red,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //     height:
                              //         controller.isRewardAvailable.value == 1
                              //             ? 5
                              //             : 0),
                              Visibility(
                                visible:
                                    controller.isRewardAvailable.value == 1,
                                child: Row(
                                  children: [
                                    Text(
                                      'eligibleReward_'.tr,
                                      style: AppTextStyle.textStyle13(
                                        fontWeight: FontWeight.w400,
                                        fontColor: appColors.black,
                                      ),
                                    ),
                                    SizedBox(width: 5.h),
                                    Text(
                                      '₹${controller.rewardPoint.value}',
                                      style: AppTextStyle.textStyle13(
                                        fontWeight: FontWeight.w600,
                                        fontColor: appColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 3.h),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteName.liveLogsScreen);
                          },
                          child: Container(
                            width: 80.w,
                            height: 31.h,
                            decoration: BoxDecoration(
                              color: appColors.guideColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1.0,
                                  offset: const Offset(0.0, 3.0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Center(
                              child: Text(
                                "liveLogs".tr,
                                style: AppTextStyle.textStyle14(
                                    fontColor: appColors.whiteGuidedColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  void openZoomMeeting(String url) async {
    debugPrint("test_url: $url");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget sessionTypeWidget({HomeController? controller}) {
    if (controller != null) {
      final bool cond1 = controller.isCallEnable.value;
      final bool cond2 = controller.isChatEnable.value;
      final bool cond3 = controller.isVideoCallEnable.value;
      return Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: appColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "sessionType".tr,
                  style: AppTextStyle.textStyle10(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue),
                ),
                SizedBox(height: 16.h),
                cond2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "chat".tr.toUpperCase(),
                              style: AppTextStyle.textStyle12(
                                  fontColor: appColors.darkBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "₹${controller.homeData?.sessionType?.chatAmount}/Min",
                              style: AppTextStyle.textStyle10(
                                  fontColor: appColors.darkBlue,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cond1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "call".tr.toUpperCase(),
                              style: AppTextStyle.textStyle12(
                                  fontColor: appColors.darkBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "₹${controller.homeData?.sessionType?.callAmount}/Min",
                              style: AppTextStyle.textStyle10(
                                  fontColor: appColors.darkBlue,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cond3
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "videoCall".tr.toUpperCase(),
                              style: AppTextStyle.textStyle12(
                                  fontColor: appColors.darkBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "₹${controller.homeData?.sessionType?.videoCallAmount}/Min",
                              style: AppTextStyle.textStyle10(
                                  fontColor: appColors.darkBlue,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            //SizedBox(width: 20.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "status".tr,
                  style: AppTextStyle.textStyle10(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue),
                ),
                SizedBox(height: 18.h),
                cond2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Obx(
                              () => SwitchWidget(
                                onTap: () async {
                                  await controller.chatSwitchFN(
                                    onComplete: () {
                                      // if (controller.chatSwitch.value) {
                                      // } else {
                                      //   selectDateTimePopupForChat();
                                      // }
                                    },
                                  );
                                },
                                switchValue: chatSwitch.value,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cond1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Obx(
                              () => SwitchWidget(
                                onTap: () async {
                                  await controller.callSwitchFN(
                                    onComplete: () {
                                      // if (controller.callSwitch.value) {
                                      // } else {
                                      //   selectDateTimePopupForCall();
                                      // }
                                    },
                                  );
                                },
                                switchValue: callSwitch.value,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cond3
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Obx(
                              () => SwitchWidget(
                                onTap: () async {
                                  await controller.videoCallSwitchFN(
                                    onComplete: () {
                                      // if (controller.videoSwitch.value) {
                                      // } else {
                                      //   selectDateTimePopupForVideo();
                                      // }
                                    },
                                  );
                                },
                                switchValue: videoSwitch.value,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            //SizedBox(width: 15.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "nextOnlineTiming".tr,
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue,
                      textAlign: TextAlign.center,
                      fontSize: 10.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.bottomSheet(CommonInfoSheet(
                            title: "nextOnlineTime".tr,
                            subTitle: "nextOnlineTimeDes".tr,
                          ));
                        },
                        child: Assets.images.icInfo
                            .svg(height: 16.h, width: 16.h)),
                  ],
                ),
                SizedBox(height: 15.h),
                cond2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Obx(() => controller.selectedChatTime.value.isEmpty
                                ? InkWell(
                                    onTap:
                                        controller.selectDateTimePopupForChat,
                                    child: Container(
                                      // width: 128.w,
                                      height: 31.h,
                                      decoration: BoxDecoration(
                                        color: appColors.guideColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "scheduleNow".tr,
                                          style: AppTextStyle.textStyle10(
                                              fontColor: appColors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ).pSymmetric(h: 16),
                                    ),
                                  )
                                : SelectedTimeForChat(controller: controller)),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cond1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Obx(() => controller.selectedCallTime.value.isEmpty
                                ? InkWell(
                                    onTap:
                                        controller.selectDateTimePopupForCall,
                                    child: Container(
                                      // width: 128.w,
                                      height: 31.h,
                                      decoration: BoxDecoration(
                                        color: appColors.guideColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "scheduleNow".tr,
                                          style: AppTextStyle.textStyle10(
                                              fontColor: appColors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ).pSymmetric(h: 16),
                                    ),
                                  )
                                : SelectedTimeForCall(controller: controller)),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cond3
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Obx(() => controller.selectedVideoTime.value.isEmpty
                                ? InkWell(
                                    onTap:
                                        controller.selectDateTimePopupForVideo,
                                    child: Container(
                                      // width: 128.w,
                                      height: 31.h,
                                      decoration: BoxDecoration(
                                        color: appColors.guideColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "scheduleNow".tr,
                                          style: AppTextStyle.textStyle10(
                                            fontColor: appColors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ).pSymmetric(h: 16),
                                    ),
                                  )
                                : SelectedTimeForVideoCall(
                                    controller: controller)),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  String abbreviateNumber(dynamic value) {
    const List<String> suffixes = ['M', 'K', 'B', 'T'];

    // Extract numeric part by removing non-numeric characters
    String numericPart = value.toString().replaceAll(RegExp(r'[^0-9.-]'), '');

    double numericValue = double.tryParse(numericPart) ?? 0.0;

    // Check if balance is greater than or equal to 0
    if (numericValue >= 0) {
      int index = 0;

      // Check if balance is above 9999
      if (numericValue > 9999) {
        while (numericValue >= 1000 && index < suffixes.length - 1) {
          numericValue /= 1000;
          index++;
        }
        return '${numericValue.toStringAsFixed(1)}${suffixes[index]}';
      } else {
        return numericValue.toStringAsFixed(0);
      }
    } else {
      // If balance is negative, format it with a minus sign
      numericValue = -numericValue;
      int index = 0;

      // Check if balance is above 9999
      if (numericValue > 9999) {
        while (numericValue >= 1000 && index < suffixes.length - 1) {
          numericValue /= 1000;
          index++;
        }
        return '-${numericValue.toStringAsFixed(1)}${suffixes[index]}';
      } else {
        return '-${numericValue.toStringAsFixed(0)}';
      }
    }
  }

  Widget orderOfferWidget({HomeController? homeController}) {
    return homeController!.homeData!.offers!.orderOffer!.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: appColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Offers",
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue,
                      ),
                    ),
                    /*Text(
                      "status".tr,
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue,
                      ),
                    ),*/
                  ],
                ),
                SizedBox(height: 10.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      homeController.homeData?.offers?.orderOffer?.length ?? 0,
                  separatorBuilder: (context, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    OrderOffer orderOffer =
                        homeController.homeData!.offers!.orderOffer![index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "${orderOffer.offerName}".toUpperCase(),
                              style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if ((orderOffer.callRate ?? 0) > 0)
                              CustomText(
                                " (₹${orderOffer.callRate}/min)".toUpperCase(),
                                fontSize: 10.sp,
                              ),
                          ],
                        ),
                        SwitchWidget(
                          onTap: () {
                            orderOffer.isOn = !orderOffer.isOn!;
                            homeController.update();
                            homeController.updateOrderOffer(
                              index: index,
                              offerId: orderOffer.id ?? 0,
                              value: orderOffer.isOn!,
                            );
                          },
                          switchValue: orderOffer.isOn,
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget customerOfferWidget(BuildContext context,
      {HomeController? controller}) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: appColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount Offers",
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w500,
                  fontColor: appColors.darkBlue,
                ),
              ),
              /*InkWell(
                onTap: () {
                  Get.toNamed(RouteName.discountOffers)!.then((value) {
                    controller!.homeData?.offers?.customOffer = value;
                    controller.update();
                  });
                },
                child: Text(
                  "viewAll".tr,
                  style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w500,
                    fontColor: appColors.darkBlue,
                  ),
                ),
              ),*/
            ],
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller!.homeData!.offers!.customOffer!.length,
            separatorBuilder: (context, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              DiscountOffer data =
                  controller.homeData!.offers!.customOffer![index];
              print(data.isOn);
              print("data.isOn");
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${data.offerName}".toUpperCase(),
                        style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // if ((controller
                      //     .homeData?.offers?.customOffer?[index].callRate ??
                      //     0) >
                      //     0)
                      //   CustomText(
                      //     " (₹${controller.homeData?.offers?.orderOffer?[index].callRate}/min)"
                      //         .toUpperCase(),
                      //     fontSize: 10.sp,
                      //   ),
                    ],
                  ),
                  SwitchWidget(
                    onTap: () {
                      if (data.isOn!) {
                        data.isOn = !data.isOn!;
                        controller.updateOfferType(
                            value: data.isOn!,
                            index: index,
                            offerId: data.id!,
                            offerType: 2);
                      } else if (controller.homeData!.offers!.customOffer!
                          .any((element) => element.isOn!)) {
                        divineSnackBar(
                            data: "Only 1 custom offer is allowed at once",
                            color: appColors.redColor);
                      } else {
                        data.isOn = !data.isOn!;
                        controller.updateOfferType(
                            value: data.isOn!,
                            index: index,
                            offerId: data.id!,
                            offerType: 2);
                      }

                      controller.update();
                    },
                    switchValue: data.isOn,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget offerTypeWidget({HomeController? controller}) {
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
            color: appColors.white,
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
                      fontColor: appColors.darkBlue,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "status".tr,
                        style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: appColors.darkBlue,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(msg: "No info for now!");
                          },
                          child: Assets.images.icInfo
                              .svg(height: 16.h, width: 16.h)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller!.homeData?.offerType?.length ?? 0,
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
                            // if (controller.offerTypeLoading.value !=
                            //     Loading.loading) {
                            //   controller.updateOfferType(
                            //       !controller.promotionOfferSwitch[index],
                            //       controller.homeData?.offerType?[index].id ??
                            //           0,
                            //       index);
                            // }
                          },
                          switchValue: controller.customOfferSwitch[index],
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
              //               fontColor: appColors.darkBlue),
              //         ),
              //         Text(
              //           "  (₹5/Min)",
              //           style: AppTextStyle.textStyle10(
              //               fontWeight: FontWeight.w400,
              //               fontColor: appColors.darkBlue),
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
          color: appColors.white,
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
                    fontWeight: FontWeight.w600, fontColor: appColors.darkBlue),
              )
            ],
          ),
        ));
  }

  Widget trainingVideoWidget({HomeController? controller}) {
    if (controller!.homeData?.trainingVideo == null ||
        (controller.homeData?.trainingVideo ?? []).isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 10.h,
        left: 20.w,
        right: 20.w,
      ),
      height: 238.h,
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.guideColor, width: 1),
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
                    onTap: () {
                      Get.bottomSheet(CommonInfoSheet(
                        title: "trainingVideos".tr,
                        subTitle: "trainingVideoDes".tr,
                      ));
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
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ]);
                        Get.to(() {
                          return TrainingVideoUI(
                            video: controller.homeData?.trainingVideo?[index],
                          );
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: appColors.extraLightGrey,
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
                              loadingIndicator: SizedBox(
                                child: CircularProgressIndicator(
                                  color: appColors.guideColor,
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

  Widget feedbackWidget({HomeController? controller}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
              style: AppTextStyle.textStyle16(fontColor: appColors.darkBlue),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "feedbacksText".tr,
              style: AppTextStyle.textStyle14(fontColor: appColors.darkBlue),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                maxLines: 6,
                maxLength: 96,
                keyboardType: TextInputType.text,
                controller: controller!.feedBackText,
                textInputAction: TextInputAction.done,
                onTapOutside: (value) => FocusScope.of(Get.context!).unfocus(),
                decoration: InputDecoration(
                  hintText: "feedbackHintText".tr,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: appColors.lightGrey,
                  ),
                  helperStyle: AppTextStyle.textStyle16(),
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: appColors.white,
                        width: 1.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: appColors.guideColor,
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
                      color: appColors.redColor);
                } else {
                  controller.sendFeedbackAPI(controller.feedBackText.text);
                }
              },
              child: Center(
                child: Container(
                    width: ScreenUtil().screenWidth / 1.5,
                    height: 56,
                    decoration: BoxDecoration(
                        color: appColors.guideColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      "submitFeedback".tr,
                      style: AppTextStyle.textStyle16(
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.white),
                    ))),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  earningDetailPopup(BuildContext context, {HomeController? controller}) async {
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
                    "Total Payment:",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.appRedColour),
                  ),
                  Text(
                    "₹${controller!.homeData?.totalEarning?.toStringAsFixed(2)}",
                    style: AppTextStyle.textStyle16(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.appRedColour),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            ExpandedTile(
              theme: ExpandedTileThemeData(
                headerPadding: const EdgeInsets.only(left: 8.0, right: 0.0),
                contentPadding: const EdgeInsets.only(left: 25.0, right: 25.0),
                contentBackgroundColor: appColors.white,
                headerColor: appColors.white,
              ),
              controller: controller.expandedTileController!,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${'actualPayment'.tr}:",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue),
                  ),
                  Text(
                    "₹${controller.homeData?.payoutPending.toString()}",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue),
                  ),
                ],
              ),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '-${'Order Amount'}:',
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                      Text(
                        "₹${controller.homeData?.totalOrderPayout?.toStringAsFixed(2)}",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-${'Divine Amount'.tr}",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                      Text(
                        "₹${controller.homeData?.totalDivineWalletPayout?.toStringAsFixed(2)}",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-${'refund'.tr}:",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                      const Spacer(),
                      Text(
                        "₹${controller.homeData?.totalRefundPayout?.toStringAsFixed(2)}",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-Fine:",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                      Text(
                        "₹${controller.homeData?.totalFinePayout?.toStringAsFixed(2)}",
                        style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w500,
                            fontColor: appColors.darkBlue.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            ExpandedTile(
                controller: controller.expandedTile2Controller!,
                theme: ExpandedTileThemeData(
                  headerPadding: const EdgeInsets.only(left: 8.0, right: 0.0),
                  contentPadding:
                      const EdgeInsets.only(left: 25.0, right: 25.0),
                  contentBackgroundColor: appColors.white,
                  headerColor: appColors.white,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${'totalTax'.tr}:",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: appColors.darkBlue),
                    ),
                    Text(
                      "₹${controller.homeData?.totalTax?.toStringAsFixed(2)}",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: appColors.darkBlue),
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "-TDS:",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.darkBlue.withOpacity(0.5)),
                        ),
                        Text(
                          "₹${controller.homeData?.tds?.toStringAsFixed(2)}",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.darkBlue.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "-${'paymentGateway'.tr}:",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.darkBlue.withOpacity(0.5)),
                        ),
                        Text(
                          "₹${controller.homeData?.totalPaymentGatewayCharges?.toStringAsFixed(2)}",
                          style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.darkBlue.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                )),
            /*Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${'status'.tr}:",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: appColors.darkBlue),
                    ),
                  ),
                  Text(
                    "toBeSettled".tr,
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue),
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
                          fontColor: appColors.darkBlue),
                    ),
                  ),
                  Text(
                    "16th May 2023 - 23rd May 2023",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue),
                  ),
                ],
              ),
            ),*/
            // SizedBox(height: 10.h),
          ],
        ));
  }

  ecommerceWalletDetailPopup(BuildContext context, List<WalletPoint> walletData,
      {String? title, int? type, HomeController? controller}) async {
    await openBottomSheet(
      context,
      functionalityWidget: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: SizedBox(
          height: Get.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: AppTextStyle.textStyle20(
                  fontWeight: FontWeight.w500,
                  fontColor: appColors.textColor,
                ),
              ).centered(),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: walletData.length,
                  itemBuilder: (context, index) {
                    return CustomInfoWidget(
                      text: walletData[index].title,
                      badgeText: walletData[index].sequence.toString(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then(
      (value) {
        if (type == 1) {
          controller!.isOpenPaidSheet = false;
          controller.update();
        }
        if (type == 2) {
          controller!.isOpenBonusSheet = false;
          controller.update();
        }
        if (type == 3) {
          controller!.isOpenECommerceSheet = false;
          controller.update();
        }
      },
    );
  }

/* ecommerceWalletDetailPopup(BuildContext context,
      wallet) async {
    await openBottomSheet(context,
        functionalityWidget: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Text(
                  "What Is Bonus Wallet?",
                  style: AppTextStyle.textStyle20(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.textColor),
                ),
                SizedBox(height: 10.h),
                CustomInfoWidget(
                  text: "Bonus Wallet contains money which is sanctioned by the platform.",
                  badgeText: "1",
                ),
                CustomInfoWidget(
                  text: "It is very good feature.",
                  badgeText: "2",
                ),
                CustomInfoWidget(
                  text: "It is very good feature.",
                  badgeText: "3",
                ),
              ],
            )));
  }*/
}

class SelectedTimeForChat extends StatelessWidget {
  final HomeController? controller;

  const SelectedTimeForChat({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31.h,
      child: Obx(
        () {
          if (controller?.selectedChatTime.value.isNotEmpty ?? false) {
            return Text(
              "${controller?.selectedChatDate.value.toCustomFormat() ?? ""} ${controller?.selectedChatTime.value ?? ""}",
              style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller?.selectedChatDate.value.toCustomFormat() ?? "",
              style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: GetBuilder<HomeController>(
          id: "score_update",
          assignId: true,
          init: HomeController(),
          builder: (controller) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "${'payAttention'.tr}!",
                        style: AppTextStyle.textStyle20(
                            fontColor: appColors.redColor,
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
                                controller.getLabel(),
                                // "",
                                // controller
                                //         .performanceScoreList[
                                //             controller.scoreIndex]
                                //         ?.label ??
                                //     '',
                                // controller.yourScore[controller.scoreIndex]
                                //     ['title'],
                                style: AppTextStyle.textStyle14(
                                    fontColor: appColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 190.h,
                              child: Stack(
                                children: [
                                  Assets.images.bgMeterFinal.svg(
                                    height: 135.h,
                                    width: 135.h,
                                  ),
                                  /*Positioned(
                                        left: 32.h,
                                        top: 40.h,
                                        child: CustomText(
                                          // "25",
                                          '${controller.performanceScoreList[controller.scoreIndex]?.performance?.marks?[1].min ?? 0}',
                                          //'${item?.rankDetail?[0].max ?? 0}',
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      Positioned(
                                        right: 38.h,
                                        top: 40.h,
                                        child: CustomText(
                                          // "50",
                                          '${controller.performanceScoreList[controller.scoreIndex]?.performance?.marks?[1].max ?? 0}',
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      Positioned(
                                        left: 5.h,
                                        top: 105.h,
                                        child: CustomText(
                                          //0
                                          '${controller.performanceScoreList[controller.scoreIndex]?.performance?.marks?[0].min ?? 0}',
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0.h,
                                        top: 105.h,
                                        child: CustomText(
                                          //100
                                          '${controller.performanceScoreList[controller.scoreIndex]?.performance?.marks?[2].max ?? 0}',
                                          fontSize: 8.sp,
                                        ),
                                      ),*/
                                  SizedBox(
                                    height: 135.h,
                                    width: 270.h,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 25.h),
                                        Text(
                                          "Your Score",
                                          style: AppTextStyle.textStyle10(
                                            fontColor: appColors.darkBlue,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        controller.performanceScoreList
                                                .asMap()
                                                .containsKey(
                                                    controller.scoreIndex)
                                            ? Text(
                                                '${controller.performanceScoreList[controller.scoreIndex]?.performance?.marksObtains ?? 0}',
                                                // item?.performance?.isNotEmpty ?? false
                                                //     ? '${item?.performance?[0].value ?? 0}'
                                                //     : "0",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: appColors.darkBlue,
                                                    fontSize: 20.sp),
                                              )
                                            : const SizedBox(),
                                        SizedBox(height: 5.h),
                                        controller.performanceScoreList
                                                .asMap()
                                                .containsKey(
                                                    controller.scoreIndex)
                                            ? Text(
                                                'Out of ${controller.performanceScoreList[controller.scoreIndex]?.performance?.totalMarks ?? 0}',
                                                // item?.performance?.isNotEmpty ?? false
                                                //     ? 'Out of ${item?.performance?[0].valueOutOff ?? 0}'
                                                //     : "Out of 0",
                                                // "Out of 100",
                                                style: AppTextStyle.textStyle10(
                                                    fontColor:
                                                        appColors.darkBlue),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    controller.performanceScoreList.length == 1
                        ? const SizedBox()
                        : Row(
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "previous".tr,
                                          style: AppTextStyle.textStyle16(
                                              fontWeight: FontWeight.w600,
                                              fontColor: appColors.darkBlue),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "next".tr,
                                          style: AppTextStyle.textStyle16(
                                              fontWeight: FontWeight.w600,
                                              fontColor: appColors.darkBlue),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    controller.performanceScoreList.length == 1
                        ? const SizedBox()
                        : SizedBox(height: 15.h),
                    controller.scoreIndex == controller.yourScore.length - 1
                        ? GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "close".tr,
                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w600,
                                        fontColor: appColors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (controller.performanceScoreList.last
                                      .performance?.totalMarks ==
                                  (controller
                                      .performanceScoreList[
                                          controller.scoreIndex]
                                      .performance
                                      ?.totalMarks)) {
                                // Get.put(DashboardController(
                                //         Get.put(PreDefineRepository())))
                                //     .selectedIndex
                                //     .value = 1;
                                // Get.put(DashboardController(
                                //         Get.put(PreDefineRepository())))
                                //     .update();
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: controller.performanceScoreList.last
                                              .performance?.totalMarks ==
                                          controller
                                              .performanceScoreList[
                                                  controller.scoreIndex]
                                              .performance
                                              ?.totalMarks
                                      ? appColors.guideColor
                                      : appColors.lightGrey.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "viewScore".tr,
                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w600,
                                        fontColor: appColors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class SelectedTimeForCall extends StatelessWidget {
  final HomeController? controller;

  const SelectedTimeForCall({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31.h,
      child: Obx(
        () {
          if (controller?.selectedCallTime.value.isNotEmpty ?? false) {
            return Text(
              "${controller?.selectedCallDate.value.toCustomFormat() ?? ""} ${controller?.selectedCallTime.value ?? ""}",
              style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller?.selectedCallDate.value.toCustomFormat() ?? "",
              style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        },
      ),
    );
  }
}

class SelectedTimeForVideoCall extends StatelessWidget {
  final HomeController? controller;

  const SelectedTimeForVideoCall({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31.h,
      child: Obx(
        () {
          if (controller?.selectedVideoTime.value.isNotEmpty ?? false) {
            return Text(
              "${controller?.selectedVideoDate.value.toCustomFormat() ?? ""} ${controller?.selectedVideoTime.value ?? ""}",
              style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller?.selectedVideoDate.value.toCustomFormat() ?? "",
              style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          }
        },
      ),
    );
  }
}
