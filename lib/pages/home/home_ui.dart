import 'dart:developer';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/switch_component.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/astrologer_training_session_response.dart';
import 'package:divine_astrologer/model/chat_assistant/CustomerDetailsResponse.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_astrologer_response.dart';
import 'package:divine_astrologer/model/home_model/astrologer_live_data_response.dart';
import 'package:divine_astrologer/model/home_page_model_class.dart';
import 'package:divine_astrologer/model/notice_response.dart';
import 'package:divine_astrologer/model/wallet_deatils_response.dart';
import 'package:divine_astrologer/pages/home/widgets/offer_bottom_widget.dart';
import 'package:divine_astrologer/pages/home/widgets/retention_widget.dart';
import 'package:divine_astrologer/pages/home/widgets/training_video.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/check_kundli/kundli_controller.dart';
import 'package:divine_astrologer/screens/home_screen_options/notice_board/notice_board_ui.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/screens/order_feedback/widget/feedback_card_widget.dart';
import 'package:divine_astrologer/screens/signature_module/view/agreement_screen.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:divine_astrologer/utils/load_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/routes.dart';
import '../../common/common_bottomsheet.dart';
import '../../gen/fonts.gen.dart';
import '../../model/feedback_response.dart';
import '../../repository/pre_defind_repository.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import '../../utils/utils.dart';
import 'home_controller.dart';
import 'widgets/common_info_sheet.dart';

class HomeUI extends GetView<HomeController> {
  const HomeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    print("beforeGoing 5 - ${preferenceService.getUserDetail()?.id}");
    print("width - ${MediaQuery.of(context).size.width.toString()}");
    print("height - ${MediaQuery.of(context).size.height.toString()}");
    print(
        "width - ${MediaQuery.of(context).size.width * 0.19} ${MediaQuery.of(context).size.width * 0.19 * 3 + 0.29 + 18 + 16.w + 16.w} ${16.w}");

    return GetBuilder<HomeController>(
        assignId: true,
        init: HomeController(),
        builder: (controller) {
          // controller.scrollController.addListener(() {
          //   if (controller.scrollController.position.maxScrollExtent ==
          //       controller.scrollController.position.pixels) {
          //   }
          // });
          controller.scrollController.addListener(() async {
            // Check if the user is at the bottom
            if (controller.scrollController.hasClients) {
              final double maxScrollExtent =
                  controller.scrollController.position.maxScrollExtent;
              final double currentScrollPosition =
                  controller.scrollController.position.pixels;

              if (currentScrollPosition >=
                      maxScrollExtent - controller.threshold &&
                  controller.checkin.value == false) {
                controller.checkin(true);
                // User is at the bottom
                controller.isLoadMoreData.value = true;
                await Future.delayed(const Duration(milliseconds: 100));
                controller.scrollController.jumpToBottom();
                controller.getConsulation();
                print("User is at the bottom of the screen");
              }
            }
          });

          return Scaffold(
            key: controller.homeScreenKey,
            backgroundColor: appColors.white,
            drawer: SideMenuDrawer(
              from: "Home",
            ),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  controller.showPopup = false;
                  controller.homeScreenKey.currentState?.openDrawer();
                },
                highlightColor: appColors.transparent,
                splashColor: appColors.transparent,
                icon: const Icon(Icons.menu),
              ),
              titleSpacing: 0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: appColors.white,
              elevation: 0,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.appbarTitle.value,
                    style: AppTextStyle.textStyle15(
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.darkBlue,
                    ),
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Text(
                          DateFormat("dd/MM/yyyy hh:mm:ss")
                              .format(AppFirebaseService().currentTime()),
                          style: AppTextStyle.textStyle12(
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.darkBlue,
                          ),
                        );
                      }),
                ],
              ),
              actions: [
                Column(
                  key: DashboardController(PreDefineRepository()).keyHide,
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
                  key:
                      DashboardController(PreDefineRepository()).keyProfileHome,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.userImage.contains("null") ||
                            controller.userImage.isEmpty ||
                            controller.userImage == ""
                        ? SizedBox(
                            height: 24.h,
                            width: 24.w,
                          )
                        : CommonImageView(
                            imagePath: controller.userImage,
                            fit: BoxFit.cover,
                            height: 24.h,
                            width: 24.w,
                            placeHolder: Assets.images.defaultProfile.path,
                            radius: BorderRadius.circular(100.r),
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
                return Screenshot(
                  controller: controller.screenshotController,
                  child: Stack(children: [
                    SingleChildScrollView(
                      controller: controller.scrollController,
                      // padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          // RechargeScreen(),

                          // const SizedBox(height: 15),
                          controller.showAgreement == 1 &&
                                  isAgreement.value == 1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => AgreementScreen());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 45,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: appColors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 6,
                                            spreadRadius: 2,
                                            color:
                                                appColors.grey.withOpacity(0.2),
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Exclusive agreement".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.poppins,
                                              fontWeight: FontWeight.w600,
                                              color: appColors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          astroHome.toString() == "0"
                              ? Obx(
                                  () => Container(
                                    key: DashboardController(
                                            PreDefineRepository())
                                        .keyTodayAmount,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 5,
                                          ),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: appColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 6,
                                                    spreadRadius: 2,
                                                    color: appColors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 15, 8, 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        controller.isShowTitle
                                                                .value
                                                            ? SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.19,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "₹${abbreviateNumber(controller.homeData?.todaysEarning?.toStringAsFixed(2))}",
                                                                      // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle14(
                                                                          fontColor: (controller.homeData?.todaysEarning ?? 0) <= 0
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(
                                                                      "today"
                                                                          .tr,
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle10(
                                                                          fontColor: (controller.homeData?.todaysEarning ?? 0) <= 0
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.19,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "₹******",
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle14(
                                                                          fontColor: (controller.homeData?.todaysEarning ?? 0) <= 0
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(
                                                                      "today"
                                                                          .tr,
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle10(
                                                                          fontColor: (controller.homeData?.todaysEarning ?? 0) <= 0
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        controller.isShowTitle
                                                                .value
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (!controller
                                                                      .isOpenBonusSheet) {
                                                                    controller
                                                                            .isOpenBonusSheet =
                                                                        true;
                                                                    controller
                                                                        .update();
                                                                    controller
                                                                        .getWalletPointDetail(
                                                                            2);

                                                                    ecommerceWalletDetailPopup(
                                                                        Get
                                                                            .context!,
                                                                        controller
                                                                            .walletData,
                                                                        title:
                                                                            "What is Bonus Wallet ?",
                                                                        controller:
                                                                            controller,
                                                                        type:
                                                                            2);
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.19,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "₹${abbreviateNumber(controller.homeData?.bonusWallet?.toStringAsFixed(2))}",
                                                                        // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                                        maxLines:
                                                                            1,
                                                                        style: AppTextStyle.textStyle14(
                                                                            fontColor: (controller.homeData!.retention! < controller.homeData!.minimumRetention!)
                                                                                ? appColors.red
                                                                                : appColors.green,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      Text(
                                                                        "Bonus"
                                                                            .tr,
                                                                        maxLines:
                                                                            1,
                                                                        style: AppTextStyle.textStyle10(
                                                                            fontColor: (controller.homeData!.retention! < controller.homeData!.minimumRetention!)
                                                                                ? appColors.red
                                                                                : appColors.green,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.19,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "₹******",
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle14(
                                                                          fontColor: (controller.homeData!.retention! < controller.homeData!.minimumRetention!)
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(
                                                                      "Bonus"
                                                                          .tr,
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle10(
                                                                          fontColor: (controller.homeData!.retention! < controller.homeData!.minimumRetention!)
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.19,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${abbreviateNumber(controller.homeData?.retention?.toStringAsFixed(2))}%",
                                                                // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                                maxLines: 1,
                                                                style: AppTextStyle.textStyle14(
                                                                    fontColor: (controller.homeData!.retention! <
                                                                            controller
                                                                                .homeData!.minimumRetention!)
                                                                        ? appColors
                                                                            .red
                                                                        : appColors
                                                                            .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Text(
                                                                "Retention Rate"
                                                                    .tr,
                                                                maxLines: 1,
                                                                style: AppTextStyle.textStyle10(
                                                                    fontColor: (controller.homeData!.retention! <
                                                                            controller
                                                                                .homeData!.minimumRetention!)
                                                                        ? appColors
                                                                            .red
                                                                        : appColors
                                                                            .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 18,
                                                    ),
                                                    Row(
                                                      children: [
                                                        controller.isShowTitle
                                                                .value
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (!controller
                                                                      .isOpenECommerceSheet) {
                                                                    controller
                                                                            .isOpenECommerceSheet =
                                                                        true;
                                                                    controller
                                                                        .update();
                                                                    controller
                                                                        .getWalletPointDetail(
                                                                            3);
                                                                    ecommerceWalletDetailPopup(
                                                                        Get
                                                                            .context!,
                                                                        controller
                                                                            .walletData,
                                                                        title:
                                                                            "What is Ecommerce Wallet ?",
                                                                        controller:
                                                                            controller,
                                                                        type:
                                                                            3);
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.19,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "₹${abbreviateNumber(controller.homeData?.ecommerceWallet?.toStringAsFixed(2))}",
                                                                        // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                                        maxLines:
                                                                            1,
                                                                        style: AppTextStyle.textStyle14(
                                                                            fontColor: (controller.homeData?.ecommerceWallet ?? 0) <= 0
                                                                                ? appColors.red
                                                                                : appColors.green,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      Text(
                                                                        "Ecom. Wallet"
                                                                            .tr,
                                                                        maxLines:
                                                                            1,
                                                                        style: AppTextStyle.textStyle10(
                                                                            fontColor: (controller.homeData?.ecommerceWallet ?? 0) <= 0
                                                                                ? appColors.red
                                                                                : appColors.green,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.19,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "₹******",
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle14(
                                                                          fontColor: (controller.homeData?.ecommerceWallet ?? 0) <= 0
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(
                                                                      "Ecom. Wallet"
                                                                          .tr,
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle10(
                                                                          fontColor: (controller.homeData?.ecommerceWallet ?? 0) <= 0
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        controller.isShowTitle
                                                                .value
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (!controller
                                                                      .isOpenPaidSheet) {
                                                                    controller
                                                                            .isOpenPaidSheet =
                                                                        true;
                                                                    controller
                                                                        .update();
                                                                    controller
                                                                        .getWalletPointDetail(
                                                                            1);
                                                                    ecommerceWalletDetailPopup(
                                                                        Get
                                                                            .context!,
                                                                        controller
                                                                            .walletData,
                                                                        title:
                                                                            "What is Paid Wallet ?",
                                                                        controller:
                                                                            controller,
                                                                        type:
                                                                            1);
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.19,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "₹${abbreviateNumber(controller.homeData?.paidWallet?.toStringAsFixed(2))}",
                                                                        // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                                        maxLines:
                                                                            1,
                                                                        style: AppTextStyle.textStyle14(
                                                                            fontColor: (controller.homeData!.repurchaseRate! < controller.homeData!.minimumRepurchaseRate!)
                                                                                ? appColors.red
                                                                                : appColors.green,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      Text(
                                                                        "Paid Wallet"
                                                                            .tr,
                                                                        maxLines:
                                                                            1,
                                                                        style: AppTextStyle.textStyle10(
                                                                            fontColor: (controller.homeData!.repurchaseRate! < controller.homeData!.minimumRepurchaseRate!)
                                                                                ? appColors.red
                                                                                : appColors.green,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.19,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "₹******",
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle14(
                                                                          fontColor: (controller.homeData!.repurchaseRate! < controller.homeData!.minimumRepurchaseRate!)
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(
                                                                      "Paid Wallet"
                                                                          .tr,
                                                                      maxLines:
                                                                          1,
                                                                      style: AppTextStyle.textStyle10(
                                                                          fontColor: (controller.homeData!.repurchaseRate! < controller.homeData!.minimumRepurchaseRate!)
                                                                              ? appColors.red
                                                                              : appColors.green,
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.19,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${abbreviateNumber(controller.homeData?.repurchaseRate?.toStringAsFixed(2))}%",
                                                                // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                                maxLines: 1,

                                                                style: AppTextStyle.textStyle14(
                                                                    fontColor: (controller.homeData!.repurchaseRate! <
                                                                            controller
                                                                                .homeData!.minimumRepurchaseRate!)
                                                                        ? appColors
                                                                            .red
                                                                        : appColors
                                                                            .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Text(
                                                                "Repurchase Rate"
                                                                    .tr,
                                                                maxLines: 1,
                                                                style: AppTextStyle.textStyle10(
                                                                    fontColor: (controller.homeData!.repurchaseRate! <
                                                                            controller
                                                                                .homeData!.minimumRepurchaseRate!)
                                                                        ? appColors
                                                                            .red
                                                                        : appColors
                                                                            .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        // SizedBox(width: 15.w),
                                        // Expanded(
                                        //   key:
                                        //       DashboardController(PreDefineRepository())
                                        //           .keyTotalAmount,
                                        //   child: controller.isShowTitle.value
                                        //       ? InkWell(
                                        //           onTap: () {
                                        //             earningDetailPopup(Get.context!,
                                        //                 controller: controller);
                                        //             // Get.toNamed(RouteName.yourEarning);
                                        //           },
                                        //           child: Column(
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment.start,
                                        //             children: [
                                        //               Row(
                                        //                 children: [
                                        //                   Text(
                                        //                     "₹${abbreviateNumber(controller.homeData?.totalEarning?.toStringAsFixed(2))}",
                                        //                     style: AppTextStyle
                                        //                         .textStyle16(
                                        //                             fontColor: appColors
                                        //                                 .appRedColour,
                                        //                             fontWeight:
                                        //                                 FontWeight
                                        //                                     .w700),
                                        //                   ),
                                        //                   const Icon(
                                        //                     Icons.arrow_forward_ios,
                                        //                     size: 20,
                                        //                   )
                                        //                 ],
                                        //               ),
                                        //               Text(
                                        //                 "total".trParams({"count": ""}),
                                        //                 style: AppTextStyle.textStyle16(
                                        //                     fontColor:
                                        //                         appColors.darkBlue,
                                        //                     fontWeight:
                                        //                         FontWeight.w400),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         )
                                        //       : InkWell(
                                        //           onTap: () {
                                        //             earningDetailPopup(Get.context!,
                                        //                 controller: controller);
                                        //             // Get.toNamed(RouteName.yourEarning);
                                        //           },
                                        //           child: Column(
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment.start,
                                        //             children: [
                                        //               Row(
                                        //                 children: [
                                        //                   Text(
                                        //                     "₹********",
                                        //                     style: AppTextStyle
                                        //                         .textStyle16(
                                        //                             fontColor: appColors
                                        //                                 .appRedColour,
                                        //                             fontWeight:
                                        //                                 FontWeight
                                        //                                     .w700),
                                        //                   ),
                                        //                   const Icon(
                                        //                     Icons.arrow_forward_ios,
                                        //                     size: 20,
                                        //                   )
                                        //                 ],
                                        //               ),
                                        //               Text(
                                        //                 "total".trParams({"count": ""}),
                                        //                 style: AppTextStyle.textStyle16(
                                        //                     fontColor:
                                        //                         appColors.darkBlue,
                                        //                     fontWeight:
                                        //                         FontWeight.w400),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        // ),
                                        // SizedBox(width: 10.w),
                                        // Container(width: MediaQuery.of(context).size),

                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.toNamed(
                                                    RouteName.passbookUI,
                                                  );
                                                },
                                                child: Ink(
                                                  height: 52,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.29,
                                                  decoration: BoxDecoration(
                                                    color: appColors.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 6,
                                                        spreadRadius: 2,
                                                        color: appColors.grey
                                                            .withOpacity(0.2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Image.asset(
                                                          "assets/images/passport.png",
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                          child: Text(
                                                            "PassBook".tr,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: AppTextStyle
                                                                .textStyle12(
                                                                    fontColor:
                                                                        appColors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              InkWell(
                                                key: DashboardController(
                                                        PreDefineRepository())
                                                    .keyCheckKundli,
                                                onTap: () {
                                                  Get.toNamed(
                                                      RouteName.checkKundli);
                                                },
                                                child: Ink(
                                                  height: 52,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.29,
                                                  decoration: BoxDecoration(
                                                    color: appColors.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 6,
                                                        spreadRadius: 2,
                                                        color: appColors.grey
                                                            .withOpacity(0.2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/images/kundli_img.svg',
                                                            // height: 40,
                                                            // width: 40,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                          child: Text(
                                                            "View Kundli".tr,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: AppTextStyle
                                                                .textStyle12(
                                                                    fontColor:
                                                                        appColors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          astroHome.toString() == "0"
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: CustomText(
                                      (controller.homeData!.retention! <
                                              controller
                                                  .homeData!.minimumRetention!)
                                          ? "notEligibleBonus".tr
                                          : "eligibleBonus".tr,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                      fontSize: 14,
                                      fontColor:
                                          !(controller.homeData!.retention! <
                                                  controller.homeData!
                                                      .minimumRetention!)!
                                              ? appColors.green
                                              : appColors.red,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          astroHome.toString() == "0"
                              ? controller.getRitentionModel == null ||
                                      controller.getRitentionModel!.data == null
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          controller.getRitentionModel!.data!
                                                      .badge ==
                                                  null
                                              ? SizedBox()
                                              : Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                    ),
                                                    child: Ink(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: appColors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 6,
                                                            spreadRadius: 2,
                                                            color: appColors
                                                                .grey
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                        ],
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CommonImageView(
                                                              imagePath: controller
                                                                  .getRitentionModel!
                                                                  .data!
                                                                  .badge!
                                                                  .image
                                                                  .toString(),
                                                              height: 30,
                                                              width: 30,
                                                              placeHolder: Assets
                                                                  .images
                                                                  .defaultProfile
                                                                  .path,
                                                            ),
                                                            SizedBox(
                                                              width: 6,
                                                            ),
                                                            Text(
                                                              controller
                                                                  .getRitentionModel!
                                                                  .data!
                                                                  .badge!
                                                                  .value
                                                                  .toString(),
                                                              style: AppTextStyle.textStyle12(
                                                                  fontColor:
                                                                      appColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          controller.getRitentionModel!.data!
                                                          .badge ==
                                                      null &&
                                                  controller.getRitentionModel!
                                                          .data!.level ==
                                                      null
                                              ? SizedBox()
                                              : SizedBox(width: 10),
                                          controller.getRitentionModel!.data!
                                                      .level ==
                                                  null
                                              ? SizedBox()
                                              : Expanded(
                                                  child: Ink(
                                                    height: 50,
                                                    // width: MediaQuery.of(context)
                                                    //         .size
                                                    //         .width *
                                                    //     0.45,
                                                    decoration: BoxDecoration(
                                                      color: appColors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 6,
                                                          spreadRadius: 2,
                                                          color: appColors.grey
                                                              .withOpacity(0.2),
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    // alignment: Alignment.center,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CommonImageView(
                                                            imagePath:
                                                                "assets/images/clock.png",
                                                            height: 30,
                                                            width: 30,
                                                            placeHolder: Assets
                                                                .images
                                                                .defaultProfile
                                                                .path,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Avg. Hrs",
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppTextStyle.textStyle12(
                                                                        fontColor:
                                                                            appColors
                                                                                .black,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                        .getRitentionModel!
                                                                        .data!
                                                                        .level!
                                                                        .hours
                                                                        .toString(),
                                                                    style: AppTextStyle.textStyle10(
                                                                        fontColor:
                                                                            appColors
                                                                                .black,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 4),
                                                                  Text(
                                                                    controller
                                                                        .getRitentionModel!
                                                                        .data!
                                                                        .level!
                                                                        .text
                                                                        .toString(),
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: AppTextStyle.textStyle10(
                                                                        fontColor:
                                                                            appColors
                                                                                .black,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                              : SizedBox(),
                          astroHome.toString() == "1"
                              ? Obx(
                                  () => Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          key: DashboardController(
                                                  PreDefineRepository())
                                              .keyTodayAmount,
                                          child: controller.isShowTitle.value
                                              ? InkWell(
                                                  onTap: () {},
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "₹${abbreviateNumber(controller.homeData?.todaysEarning?.toStringAsFixed(2))}",
                                                        // "₹${controller.homeData?.todaysEarning?.toStringAsFixed(2)}",
                                                        style: AppTextStyle
                                                            .textStyle16(
                                                                fontColor: appColors
                                                                    .appRedColour,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      Text(
                                                        "today".tr,
                                                        style: AppTextStyle
                                                            .textStyle16(
                                                                fontColor:
                                                                    appColors
                                                                        .darkBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {},
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "₹******",
                                                        style: AppTextStyle
                                                            .textStyle16(
                                                                fontColor: appColors
                                                                    .appRedColour,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      Text(
                                                        "today".tr,
                                                        style: AppTextStyle
                                                            .textStyle16(
                                                                fontColor:
                                                                    appColors
                                                                        .darkBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        // SizedBox(width: 15.w),
                                        /*Expanded(
                                    key: DashboardController(PreDefineRepository())
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
                                                  "total".trParams({"count": ""}),
                                                  style: AppTextStyle.textStyle16(
                                                      fontColor:
                                                          appColors.darkBlue,
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
                                                  "total".trParams({"count": ""}),
                                                  style: AppTextStyle.textStyle16(
                                                      fontColor:
                                                          appColors.darkBlue,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),*/
                                        // SizedBox(width: 10.w),
                                        InkWell(
                                          onTap: () {
                                            // showModalBottomSheet(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return Container(
                                            //       height: 250,
                                            //       width: double.infinity,
                                            //       color: appColors.white,
                                            //       child: Image.asset(
                                            //           "assets/images/coming-soon-red-blue-3d-text-white-surface-clear-lighting.jpg"),
                                            //     );
                                            //   },
                                            // );

                                            Get.toNamed(
                                              RouteName.passbookUI,
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: Ink(
                                              height: 50,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: appColors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 6,
                                                    spreadRadius: 2,
                                                    color: appColors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              // alignment: Alignment.center,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/passport.png",
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    // CommonImageView(
                                                    //   imagePath:
                                                    //       "assets/images/passport.png",
                                                    //   height: 30,
                                                    //   width: 30,
                                                    //   placeHolder: Assets
                                                    //       .images.defaultProfile.path,
                                                    //   radius:
                                                    //       BorderRadius.circular(100.r),

                                                    // ),
                                                    Text(
                                                      "PassBook".tr,
                                                      style: AppTextStyle
                                                          .textStyle10(
                                                              fontColor:
                                                                  appColors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        InkWell(
                                          key: DashboardController(
                                                  PreDefineRepository())
                                              .keyCheckKundli,
                                          onTap: () {
                                            Get.toNamed(RouteName.checkKundli);
                                          },
                                          child: Ink(
                                            height: 50,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: appColors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 6,
                                                  spreadRadius: 2,
                                                  color: appColors.grey
                                                      .withOpacity(0.2),
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            // alignment: Alignment.center,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: SvgPicture.asset(
                                                      'assets/images/kundli_img.svg',
                                                      // height: 40,
                                                      // width: 40,
                                                    ),
                                                  ),
                                                  // CommonImageView(
                                                  //   imagePath:
                                                  //       "assets/images/kundli_img.svg",
                                                  //   height: 40,
                                                  //    placeHolder: Assets
                                                  //       .images.defaultProfile.path,
                                                  //   radius:
                                                  //       BorderRadius.circular(100.r),

                                                  // ),
                                                  Text(
                                                    "View Kundli".tr,
                                                    style: AppTextStyle
                                                        .textStyle10(
                                                            fontColor:
                                                                appColors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          /// new widget
                          astroHome.toString() == "1"
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          key: DashboardController(
                                                  PreDefineRepository())
                                              .keyRetentionRate,
                                          child: RetentionWidget(
                                            isEligible: true,
                                            title:
                                                "${"bonusWallet".tr} \n ₹${abbreviateNumber(controller.homeData?.bonusWallet)}",
                                            subTitle:
                                                "${"retentionRate".tr} \n ${controller.homeData?.retention ?? 0}%",
                                            borderColor: (controller
                                                        .homeData!.retention! <
                                                    controller.homeData!
                                                        .minimumRetention!)
                                                ? appColors.red
                                                : appColors.green,
                                            onTap: () async {
                                              if (!controller
                                                  .isOpenBonusSheet) {
                                                controller.isOpenBonusSheet =
                                                    true;
                                                controller.update();
                                                controller
                                                    .getWalletPointDetail(2);

                                                ecommerceWalletDetailPopup(
                                                    Get.context!,
                                                    controller.walletData,
                                                    title:
                                                        "What is Bonus Wallet ?",
                                                    controller: controller,
                                                    type: 2);
                                              }
                                            },
                                          )),
                                      SizedBox(width: 7.w),
                                      Expanded(
                                        key: DashboardController(
                                                PreDefineRepository())
                                            .keyRepurchaseRate,
                                        child: RetentionWidget(
                                          title:
                                              "${"paidWallet".tr} \n ₹${abbreviateNumber(controller.homeData?.paidWallet)}",
                                          subTitle:
                                              "${"rePurchaseRate".tr} \n ${controller.homeData?.repurchaseRate ?? 0}%",
                                          borderColor: (controller.homeData!
                                                      .repurchaseRate! <
                                                  controller.homeData!
                                                      .minimumRepurchaseRate!)
                                              ? appColors.red
                                              : appColors.green,
                                          onTap: () async {
                                            if (!controller.isOpenPaidSheet) {
                                              controller.isOpenPaidSheet = true;
                                              controller.update();
                                              controller
                                                  .getWalletPointDetail(1);
                                              ecommerceWalletDetailPopup(
                                                  Get.context!,
                                                  controller.walletData,
                                                  title:
                                                      "What is Paid Wallet ?",
                                                  controller: controller,
                                                  type: 1);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 7.w),
                                      Expanded(
                                          key: DashboardController(
                                                  PreDefineRepository())
                                              .keyEcommerceWallet,
                                          child: RetentionWidget(
                                            borderColor: appColors.textColor,
                                            bottomTextColor:
                                                appColors.textColor,
                                            bottomColor: appColors.transparent,
                                            onTap: () async {
                                              if (!controller
                                                  .isOpenECommerceSheet) {
                                                controller
                                                        .isOpenECommerceSheet =
                                                    true;
                                                controller.update();
                                                controller
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
                                                  fontColor:
                                                      appColors.textColor,
                                                ),
                                                SizedBox(height: 5.h),
                                                CustomText(
                                                  "₹${abbreviateNumber(controller.homeData?.ecommerceWallet)}",
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.center,
                                                  fontSize: 9.sp,
                                                  fontColor:
                                                      appColors.textColor,
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          astroHome.toString() == "1"
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: CustomText(
                                      (controller.homeData!.retention! <
                                              controller
                                                  .homeData!.minimumRetention!)
                                          ? "notEligibleBonus".tr
                                          : "eligibleBonus".tr,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                      fontSize: 14,
                                      fontColor:
                                          !(controller.homeData!.retention! <
                                                  controller.homeData!
                                                      .minimumRetention!)!
                                              ? appColors.green
                                              : appColors.red,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Obx(() {
                            return Visibility(
                              visible: controller.marqueeText.value.isNotEmpty,
                              child: Container(
                                height: 30.h,
                                // color: appColors.marqueeBgColor,
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
                          astroHome.toString() == "0"
                              ? PerformanceTab(context, controller: controller)
                              : SizedBox(),
                          Obx(
                            () => controller.isFeedbackAvailable.value
                                ? controller.homeData?.feedback == null
                                    ? const SizedBox.shrink()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
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
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.poppins,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.darkBlue,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "viewAll".tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.poppins,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: appColors.darkBlue,
                                                      fontSize: 12,
                                                    ),
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
                                          ],
                                        ),
                                      )
                                : const SizedBox(),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(RouteName.messageTemplate),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    decoration: BoxDecoration(
                                      color: appColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                          color:
                                              appColors.grey.withOpacity(0.2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CommonImageView(
                                            imagePath:
                                                "assets/images/message.png",
                                            height: 30,
                                            width: 30,
                                            placeHolder: Assets
                                                .images.defaultProfile.path,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Text(
                                              "Message Template",
                                              style: AppTextStyle.textStyle10(
                                                fontWeight: FontWeight.w500,
                                                fontColor: appColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                      RouteName.suggestRemediesView),
                                  // onTap: () {
                                  //   Get.to(() => RemediesChatScreen());
                                  // },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    decoration: BoxDecoration(
                                      color: appColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                          color:
                                              appColors.grey.withOpacity(0.2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CommonImageView(
                                            imagePath:
                                                "assets/images/service.png",
                                            height: 30,
                                            width: 30,
                                            placeHolder: Assets
                                                .images.defaultProfile.path,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Text(
                                              "Suggested Remedies",
                                              style: AppTextStyle.textStyle10(
                                                fontWeight: FontWeight.w500,
                                                fontColor: appColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(RouteName.customProduct),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    decoration: BoxDecoration(
                                      color: appColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                          color:
                                              appColors.grey.withOpacity(0.2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CommonImageView(
                                            imagePath:
                                                "assets/images/product.png",
                                            height: 30,
                                            width: 30,
                                            placeHolder: Assets
                                                .images.defaultProfile.path,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Text(
                                              "Custom Product",
                                              style: AppTextStyle.textStyle10(
                                                fontWeight: FontWeight.w500,
                                                fontColor: appColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          controller.astroNoticeBoardResponse.value.data
                                      ?.noticeBoard ==
                                  null
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
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
                                              style: TextStyle(
                                                fontFamily: FontFamily.poppins,
                                                fontWeight: FontWeight.w400,
                                                color: appColors.darkBlue,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "viewAll".tr,
                                              style: TextStyle(
                                                fontFamily: FontFamily.poppins,
                                                fontWeight: FontWeight.w400,
                                                color: appColors.darkBlue,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      noticeBoardWidget(controller: controller),
                                    ],
                                  ),
                                ),
                          // noticeBoardPoll(controller: controller, maxWidth),

                          Obx(
                            () {
                              final bool cond1 = controller.isCallEnable.value;
                              final bool cond2 = controller.isChatEnable.value;
                              final bool cond3 =
                                  controller.isVideoCallEnable.value;

                              return cond1 || cond2 || cond3
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      child: sessionTypeWidget(
                                          controller: controller))
                                  : const SizedBox();
                            },
                          ),
                          Obx(
                            () {
                              return isLive.value == 1
                                  ? controller.isLiveEnable.value // == false
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Column(
                                            children: [
                                              // SizedBox(height: 10.h),
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
                                                      if (disableAstroEvent
                                                              .toString() ==
                                                          "1") {
                                                        controller.firebaseEvent
                                                            .go_live(
                                                          {
                                                            "astrolgoer_id":
                                                                controller
                                                                        .userData
                                                                        .id ??
                                                                    "",
                                                            "date_time":
                                                                DateTime.now()
                                                                    .toString(),
                                                            "is_going_live":
                                                                "Yes"
                                                          },
                                                        );
                                                      }

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
                                                    color: appColors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 6,
                                                        spreadRadius: 2,
                                                        color: appColors.grey
                                                            .withOpacity(0.2),
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
                                                      CommonImageView(
                                                        imagePath:
                                                            "assets/images/live_image.png",
                                                        height: 35,
                                                        width: 35,
                                                        placeHolder: Assets
                                                            .images
                                                            .defaultProfile
                                                            .path,
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Text(
                                                        "goLive".tr,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .poppins,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              appColors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(height: 10.h),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox();
                            },
                          ),

                          viewKundliWidgetUpdated(),

                          controller.homeData?.offers?.orderOffer!.length != 0
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: orderOfferWidget(
                                      homeController: controller))
                              : SizedBox(),

                          controller.homeData?.offers?.customOffer!.length != 0
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: customerOfferWidget(context,
                                      controller: controller),
                                )
                              : const SizedBox(),
                          fullScreenBtnWidget(
                              btnTitle: "referAnAstrologer".tr,
                              onbtnTap: () {
                                Get.toNamed(RouteName.referAstrologer);
                              }),
                          trainingVideoWidget(controller: controller),
                          scheduledTrainingWidgetUpdated(
                              controller: controller),

                          Obx(() {
                            return showDailyLive.value.toString() == "1"
                                ? Visibility(
                                    visible:
                                        controller.isLiveMonitor.value != 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, bottom: 6),
                                      child: Column(
                                        children: [
                                          liveWidgetUpdated(),
                                          // SizedBox(height: 10.h),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          }),
                          (controller.customerDetailsResponse == null ||
                                  controller
                                      .customerDetailsResponse!.data.isEmpty)
                              ? SizedBox()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    child: Text(
                                      "User Data".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.poppins,
                                        fontWeight: FontWeight.w400,
                                        color: appColors.darkBlue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                          (controller.customerDetailsResponse == null ||
                                  controller
                                      .customerDetailsResponse!.data.isEmpty)
                              ? SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: (controller.filteredUserData)
                                              .isNotEmpty ||
                                          controller
                                              .searchController.text.isNotEmpty
                                      ? controller.filteredUserData.length
                                      : controller.customerDetailsResponse?.data
                                              .length ??
                                          0,
                                  itemBuilder: (context, index) {
                                    return ChatAssistanceDataTileHome(
                                      data: (controller.filteredUserData)
                                                  .isNotEmpty ||
                                              controller.searchController.text
                                                  .isNotEmpty
                                          ? controller.filteredUserData[index]
                                          : controller.customerDetailsResponse!
                                              .data[index],
                                      index: index,
                                      controller: controller,
                                    );
                                  },
                                ),
                          // NotificationListener<ScrollNotification>(
                          //         onNotification:
                          //             (ScrollNotification scrollInfo) {
                          //           if (scrollInfo.metrics.pixels ==
                          //               scrollInfo.metrics.maxScrollExtent) {
                          //             print(
                          //                 "getConsulation getConsulation getConsulation");
                          //             // controller.getConsulation();
                          //             return true;
                          //           }
                          //           return false;
                          //         },
                          //         child:
                          //       ),
                          SizedBox(height: 20.h),
                          // feedbackWidget(controller: controller),
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
                          //                 (index) {
                          //               return Container(
                          //                   alignment:
                          //                   AlignmentDirectional.center,
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
                          // GestureDetector(
                          //   onTap: () {
                          //     Get.toNamed(RouteName.customProduct);
                          //   },
                          //   child: Container(
                          //     margin:
                          //         const EdgeInsets.symmetric(horizontal: 20.0),
                          //     alignment: Alignment.center,
                          //     height: 55,
                          //     decoration: BoxDecoration(
                          //       color: appColors.guideColor,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.black.withOpacity(0.2),
                          //           blurRadius: 1.0,
                          //           offset: const Offset(0.0, 3.0),
                          //         ),
                          //       ],
                          //       borderRadius: BorderRadius.circular(10.0),
                          //     ),
                          //     child: Text(
                          //       "Custom Product",
                          //       style: AppTextStyle.textStyle14(
                          //         fontWeight: FontWeight.w500,
                          //         fontColor: appColors.white,
                          //       ),
                          //     ),
                          //   ),
                          // )
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(horizontal: 20.w),
                          //     child: CustomText(
                          //       (controller.homeData!.retention! <
                          //               controller.homeData!.minimumRetention!)
                          //           ? "notEligibleBonus".tr
                          //           : "eligibleBonus".tr,
                          //       fontWeight: FontWeight.w400,
                          //       textAlign: TextAlign.start,
                          //       fontSize: 14,
                          //       fontColor: !(controller.homeData!.retention! <
                          //               controller.homeData!.minimumRetention!)!
                          //           ? appColors.green
                          //           : appColors.red,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 10.h),

                          // SizedBox(height: 10.h),
                          // availableFeedbackWidget(controller.feedbackResponse ?? FeedbackData()),
                          // SizedBox(height: 10.h),

                          // SizedBox(height: 10.h),
                          // noticeBoardWidget(),
                          // SizedBox(height: 15.h),
                          // viewKundliWidget(),
                          // viewKundliWidgetUpdated(),

                          // SizedBox(height: 10.h),
                          // Container(
                          //     margin: EdgeInsets.symmetric(horizontal: 20.w),
                          //     height: 1.h,
                          //     color: appColors.darkBlue.withOpacity(0.5)),
                          // SizedBox(height: 10.h),
                          // Obx(
                          //   () {
                          //     final bool cond1 = controller.isCallEnable.value;
                          //     final bool cond2 = controller.isChatEnable.value;
                          //     final bool cond3 =
                          //         controller.isVideoCallEnable.value;
                          //
                          //     return cond1 || cond2 || cond3
                          //         ? Container(
                          //             margin:
                          //                 EdgeInsets.symmetric(horizontal: 20.w),
                          //             child: sessionTypeWidget(
                          //                 controller: controller))
                          //         : const SizedBox();
                          //   },
                          // ),
                          // if (controller.homeData?.offerType != null &&
                          //     controller.homeData?.offerType != [])
                          //   offerTypeWidget(),
                          // SizedBox(height: 20.h),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: GestureDetector(
                          //           onTap: () =>
                          //               Get.toNamed(RouteName.messageTemplate),
                          //           child: Container(
                          //             alignment: Alignment.center,
                          //             height: 55,
                          //             decoration: BoxDecoration(
                          //               color: appColors.guideColor,
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.black.withOpacity(0.2),
                          //                   blurRadius: 1.0,
                          //                   offset: const Offset(0.0, 3.0),
                          //                 ),
                          //               ],
                          //               borderRadius: BorderRadius.circular(10.0),
                          //             ),
                          //             child: Text(
                          //               "Message Template",
                          //               style: AppTextStyle.textStyle14(
                          //                 fontWeight: FontWeight.w500,
                          //                 fontColor: appColors.white,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 5.w,
                          //       ),
                          //       Expanded(
                          //         child: GestureDetector(
                          //           onTap: () => Get.toNamed(
                          //               RouteName.suggestRemediesView),
                          //           child: Container(
                          //             alignment: Alignment.center,
                          //             height: 55,
                          //             decoration: BoxDecoration(
                          //               color: appColors.guideColor,
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.black.withOpacity(0.2),
                          //                   blurRadius: 1.0,
                          //                   offset: const Offset(0.0, 3.0),
                          //                 ),
                          //               ],
                          //               borderRadius: BorderRadius.circular(10.0),
                          //             ),
                          //             child: Text(
                          //               "Suggested Remedies",
                          //               style: AppTextStyle.textStyle14(
                          //                 fontWeight: FontWeight.w500,
                          //                 fontColor: appColors.white,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 10.h),
                          // GestureDetector(
                          //   onTap: () {
                          //     Get.toNamed(RouteName.customProduct);
                          //   },
                          //   child: Container(
                          //     margin:
                          //         const EdgeInsets.symmetric(horizontal: 20.0),
                          //     alignment: Alignment.center,
                          //     height: 55,
                          //     decoration: BoxDecoration(
                          //       color: appColors.guideColor,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.black.withOpacity(0.2),
                          //           blurRadius: 1.0,
                          //           offset: const Offset(0.0, 3.0),
                          //         ),
                          //       ],
                          //       borderRadius: BorderRadius.circular(10.0),
                          //     ),
                          //     child: Text(
                          //       "Custom Product",
                          //       style: AppTextStyle.textStyle14(
                          //         fontWeight: FontWeight.w500,
                          //         fontColor: appColors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // controller.homeData?.offers?.orderOffer!.length != 0
                          //     ? Container(
                          //         margin: EdgeInsets.symmetric(horizontal: 20.w),
                          //         child: orderOfferWidget(
                          //             homeController: controller))
                          //     : const SizedBox(),

                          // SizedBox(height: 10.h),
                          // fullScreenBtnWidget(
                          //     imageName: Assets.images.icReferAFriend.svg(),
                          //     btnTitle: "referAnAstrologer".tr,
                          //     onbtnTap: () {
                          //       Get.toNamed(RouteName.referAstrologer);
                          //     }),
                          // SizedBox(height: 10.h),
                          // trainingVideoWidget(controller: controller),
                          /*  SizedBox(height: 10.h),
                            fullScreenBtnWidget(
                                imageName: Assets.images.icEcommerce.svg(),
                                btnTitle: "eCommerce".tr,
                                onbtnTap: () async {
                                  if (await PermissionHelper().askPermissions()) {
                                    Get.toNamed(RouteName.videoCallPage);
                                  }
                                }),*/
                          // SizedBox(height: 20.h),
                          // feedbackWidget(controller: controller),
                        ],
                      ),
                    ),
                    isAstroCare.value == 0
                        ? const SizedBox()
                        : Positioned(
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
                                    if (controller.xPosition + 25 <
                                        Get.width / 2) {
                                      controller.xPosition = 0;
                                    } else {
                                      controller.xPosition = Get.width - 70;
                                    }

                                    controller.update();
                                  },
                                  onTap: () {
                                    // Get.toNamed(
                                    //   RouteName.technicalIssues,
                                    // );
                                    controller.whatsapp();
                                  },
                                  child: Container(
                                      key: DashboardController(
                                              PreDefineRepository())
                                          .keyHelp,
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: appColors.guideColor,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
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
                  ]),
                );
              } else {
                return const GenericLoadingWidget();
              }
            }),
          );
        });
  }

  Widget viewKundliWidgetUpdated() {
    return Obx(() {
      var data = callKunadliUpdated.value;
      log("open_order -- $data");
      log("open_order -- $data");
      return !mapEquals(data, {})
          ? Container(
              margin: EdgeInsets.only(
                bottom: 6,
                top: 6,
                left: 16,
                right: 16,
              ),
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appColors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    spreadRadius: 2,
                    color: appColors.grey.withOpacity(0.2),
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
                            log("kundlii");
                            log("kundlii");
                            log("kundlii${double.parse(data["latitude"])}");
                            log("kundlii${double.parse(data["longitude"])}");
                            log("open_order -- $data");

                            DateTime time = DateFormat('d MMMM yyyy h:mm a')
                                .parse('${data["dob"]} ${data["tob"]}');
                            log("kundlii${time.toString()}");

                            print(data);
                            print("datadatadatadatadata");
                            Params params = Params(
                              day: time.day,
                              month: time.month,
                              hour: time.hour,
                              min: time.minute,
                              lat: double.parse(data["latitude"]),
                              long: double.parse(data["longitude"]),
                              location: data["pob"],
                              year: time.year,
                              name: data["userName"],
                            );
                            log("kundli");

                            Get.toNamed(
                              RouteName.kundliDetail,
                              arguments: {
                                "kundli_id": 0,
                                "from_kundli": false,
                                "params": params,
                                "gender":
                                    AppFirebaseService().orderData["gender"]
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
                                horizontal: 20, vertical: 6),
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

  Widget noticeBoardPoll(maxWidth, {HomeController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Ink(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              color: appColors.grey.withOpacity(0.2),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          // border: Border.all(color: appColors.guideColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you facing any issue with the new update? I repeat my question to fill the space!",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: FontFamily.poppins,
              ),
            ),
            SizedBox(height: 13),
            InkWell(
              onTap: () {
                if (controller.noticePollChecked == false) {
                  controller.selectedPoll = "Yes";
                  controller.noticePollChecked = true;
                  controller.update();
                } else {}
              },
              child: Container(
                height: 40,
                width: maxWidth,
                decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller!.selectedPoll == null
                          ? appColors.grey.withOpacity(0.3)
                          : controller.selectedPoll == "Yes"
                              ? appColors.red
                              : appColors.grey,
                      width: 1,
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      // Filled container

                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: maxWidth *
                              0.7 *
                              (70 /
                                  100), // Adjust the width based on the percentage
                          height: 40,
                          color: controller.selectedPoll == null
                              ? null
                              : controller.selectedPoll == "Yes"
                                  ? Colors.red.withOpacity(0.3)
                                  : appColors.grey
                                      .withOpacity(0.3), // Fill color
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 6, bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: controller.selectedPoll == null
                                        ? appColors.white
                                        : controller.selectedPoll == "Yes"
                                            ? appColors.red
                                            : appColors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: controller.selectedPoll == null
                                          ? appColors.grey.withOpacity(0.3)
                                          : controller.selectedPoll == "Yes"
                                              ? appColors.red
                                              : appColors.grey.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: controller.selectedPoll == "Yes"
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(
                                            Icons.check,
                                            size: 20,
                                            color: appColors.white,
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            controller.selectedPoll == null
                                ? SizedBox()
                                : Text(
                                    "70%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedPoll == "Yes"
                                          ? appColors.red
                                          : appColors.grey,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                if (controller.noticePollChecked == false) {
                  controller.selectedPoll = "No";
                  controller.noticePollChecked = true;
                  controller.update();
                } else {}
              },
              child: Container(
                height: 40,
                width: maxWidth,
                decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller.selectedPoll == null
                          ? appColors.grey.withOpacity(0.3)
                          : controller.selectedPoll == "No"
                              ? appColors.red
                              : appColors.grey,
                      width: 1,
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      // Filled container
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: maxWidth *
                              (30 /
                                  100), // Adjust the width based on the percentage
                          height: 40,
                          color: controller.selectedPoll == null
                              ? null
                              : controller.selectedPoll == "No"
                                  ? Colors.red.withOpacity(0.3)
                                  : appColors.grey
                                      .withOpacity(0.3), // Fill color
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 6, bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: controller.selectedPoll == null
                                        ? appColors.white
                                        : controller.selectedPoll == "No"
                                            ? appColors.red
                                            : appColors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: controller.selectedPoll == null
                                          ? appColors.grey.withOpacity(0.3)
                                          : controller.selectedPoll == "No"
                                              ? appColors.red
                                              : appColors.grey.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: controller.selectedPoll == "No"
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(
                                            Icons.check,
                                            size: 20,
                                            color: appColors.white,
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            controller.selectedPoll == null
                                ? SizedBox()
                                : Text(
                                    "30%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedPoll == "No"
                                          ? appColors.red
                                          : appColors.grey,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noticeBoardWidget({HomeController? controller}) {
    print(
        "-----------------${controller!.astroNoticeBoardResponse.value.data?.noticeBoard.toString()}");
    return controller!.astroNoticeBoardResponse.value.success == true
        ? ClipRRect(
            key: DashboardController(PreDefineRepository()).keyNoticeBoard,
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            child: Material(
              color: appColors.transparent,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RouteName.noticeDetail,
                      arguments: controller
                          .astroNoticeBoardResponse.value.data?.noticeBoard,
                      parameters: {"from_list": "0"});
                },
                child: Ink(
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 2,
                          color: appColors.grey.withOpacity(0.2),
                        ),
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
                            width: 150.w,
                            child: CustomText(
                              controller.astroNoticeBoardResponse.value.data
                                      ?.noticeBoard?.title ??
                                  '',
                              fontWeight: FontWeight.w500,
                              fontColor: appColors.appRedColour,
                              maxLines: 2,
                              fontSize: 16.sp,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  '${dateToString(DateTime.parse(controller.astroNoticeBoardResponse.value.data?.noticeBoard?.createdAt != null ? controller.astroNoticeBoardResponse.value.data?.noticeBoard?.createdAt ?? "" : DateTime.now().toString()), format: "h:mm a")}  '
                                  '${formatDateTime(DateTime.parse(controller.astroNoticeBoardResponse.value.data?.noticeBoard?.createdAt != null ? controller.astroNoticeBoardResponse.value.data?.noticeBoard?.createdAt ?? "" : DateTime.now().toString()))}',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyle.textStyle10(
                                      fontWeight: FontWeight.w400,
                                      fontColor: appColors.darkBlue),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(CommonInfoSheet(
                                      title: "noticeBoard".tr,
                                      subTitle: "noticeBoardDes".tr,
                                      argument: controller
                                          .astroNoticeBoardResponse
                                          .value
                                          .data
                                          ?.noticeBoard,
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
                        htmlData: controller.astroNoticeBoardResponse.value.data
                                ?.noticeBoard?.description ??
                            "",
                        trimLength: 100,
                        isExpanded: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget PerformanceTab(context, {HomeController? controller}) {
    return controller!.getRitentionModel == null ||
            controller.getRitentionModel!.data!.performanceData!.isEmpty ||
            controller.getRitentionModel!.data!.performanceData == null
        ? const SizedBox()
        : Padding(
            padding:
                const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: appColors.grey.withOpacity(0.2),
                  ),
                ],
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  maintainState: true,
                  collapsedIconColor: Colors.black,
                  iconColor: Colors.black,
                  initiallyExpanded: false,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      'Performance',
                      fontWeight: FontWeight.w600,
                      fontColor: appColors.black,
                      maxLines: 1,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: controller.change.value == false
                      ? null
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            controller.getRitentionModel!.data!.Date_text ==
                                    null
                                ? ""
                                : controller.getRitentionModel!.data!.Date_text
                                    .toString(),
                            fontWeight: FontWeight.w600,
                            fontColor: appColors.black,
                            maxLines: 1,
                            fontSize: 12,
                          ),
                        ),
                  onExpansionChanged: (bool value) {
                    if (value == true) {
                      controller.change(true);
                      controller.update();
                    } else {
                      controller.change(false);
                      controller.update();
                    }
                  },
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 6, left: 16, right: 16),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   child: CustomText(
                            //     'Performance ${controller.getRitentionModel!.data!.Date_text == null ? "" : "${controller.getRitentionModel!.data!.Date_text.toString()}"}', //(22nd-28th July)
                            //     fontWeight: FontWeight.w600,
                            //     fontColor: appColors.black,
                            //     maxLines: 1,
                            //     fontSize: 12,
                            //   ),
                            // ),
                            // SizedBox(height: 5),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.getRitentionModel!.data!
                                  .performanceData!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = controller.getRitentionModel!.data!
                                    .performanceData![index];
                                return rowWidget(
                                    context,
                                    data.metric.toString(),
                                    data.value.toString(),
                                    data.status.toString(),
                                    data.color ?? "#FF5733");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget rowWidget(context, title, mid, end, color) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.46,
            child: CustomText(
              title,
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
              fontColor: appColors.black,
              maxLines: 1,
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
            child: CustomText(
              mid,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              fontColor: Color(int.parse(color.replaceAll("#", "0xff"))),
              maxLines: 1,
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
            child: CustomText(
              end,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w400,
              fontColor: Color(int.parse(color.replaceAll("#", "0xff"))),
              maxLines: 1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduledTrainingWidgetUpdated({HomeController? controller}) {
    return Visibility(
      visible: controller!.astrologerTrainingSessionLst.isNotEmpty,
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
        // top: 10.h,
        left: 20.w,
        right: 20.w,
      ),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
        key: DashboardController(PreDefineRepository()).keySessionType,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 2,
              color: appColors.grey.withOpacity(0.2),
            ),
          ],
          color: appColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "sessionType".tr,
                    style: AppTextStyle.textStyle10(
                      fontWeight: FontWeight.w500,
                      fontColor: appColors.darkBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "status".tr,
                    style: AppTextStyle.textStyle10(
                        fontWeight: FontWeight.w500,
                        fontColor: appColors.darkBlue),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.bottomSheet(CommonInfoSheet(
                              title: "nextOnlineTime".tr,
                              subTitle: "nextOnlineTimeDes".tr,
                            ));
                          },
                          child:
                              Assets.images.icInfo.svg(height: 15, width: 15)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            cond2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
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
                            ),
                          ),
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: SwitchWidget(
                                onTap: () async {
                                  log("here is it is comming - ${chatSwitch.value}");

                                  if (chatSwitch.value) {
                                    controller.selectDateTimePopupForChat(true);
                                  } else {
                                    await controller.chatSwitchFN(
                                      onComplete: () {
                                        // if (controller.chatSwitch.value) {
                                        // } else {
                                        //   selectDateTimePopupForChat();
                                        // }
                                      },
                                    );
                                  }
                                },
                                switchValue: chatSwitch.value,
                                activeToggleColor: appColors.green,
                                inactiveToggleColor: appColors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Obx(() => Expanded(
                                flex: 3,
                                child: controller
                                            .selectedChatTime.value.isEmpty ||
                                        chatSwitch.value
                                    ? InkWell(
                                        onTap: () => controller
                                            .selectDateTimePopupForChat(
                                                chatSwitch.value),
                                        child: Container(
                                          height: 31.h,
                                          decoration: BoxDecoration(
                                            color: appColors.guideColor,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                    : SelectedTimeForChat(
                                        controller: controller),
                              )),
                        ],
                      ),
                      showStaticText.value.toString() == "0"
                          ? chatSwitch.value == true
                              ? Text(
                                  "You are online on chat",
                                  style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w500,
                                    fontColor: appColors.green,
                                  ),
                                )
                              : Text(
                                  "You are offline on chat",
                                  style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w500,
                                    fontColor: appColors.red,
                                  ),
                                )
                          : controller.chatMessage.isNotEmpty
                              ? Text(
                                  controller.chatMessage,
                                  style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w500,
                                    fontColor: Color(int.parse(controller
                                        .chatMessageColor
                                        .replaceAll("#", "0xff"))),
                                  ),
                                )
                              : SizedBox(),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            cond1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
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
                          ),
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: SwitchWidget(
                                onTap: () async {
                                  log("here is it is comming - ${callSwitch.value}");
                                  if (callSwitch.value) {
                                    controller.selectDateTimePopupForCall(true);
                                  } else {
                                    await controller.callSwitchFN(
                                      onComplete: () {
                                        // if (controller.callSwitch.value) {
                                        // } else {
                                        //   selectDateTimePopupForCall();
                                        // }
                                      },
                                    );
                                  }
                                },
                                switchValue: callSwitch.value,
                                activeToggleColor: appColors.green,
                                inactiveToggleColor: appColors.red,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Obx(() => Expanded(
                                flex: 3,
                                child: controller
                                            .selectedCallTime.value.isEmpty ||
                                        callSwitch.value
                                    ? InkWell(
                                        onTap: () => controller
                                            .selectDateTimePopupForCall(
                                                callSwitch.value),
                                        child: Container(
                                          // width: 128.w,
                                          height: 31.h,
                                          decoration: BoxDecoration(
                                            color: appColors.guideColor,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                    : SelectedTimeForCall(
                                        controller: controller),
                              )),
                        ],
                      ),
                      showStaticText.value.toString() == "0"
                          ? callSwitch.value == true
                              ? Text(
                                  "You are online on call",
                                  style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w500,
                                    fontColor: appColors.green,
                                  ),
                                )
                              : Text(
                                  "You are offline on call",
                                  style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w500,
                                    fontColor: appColors.red,
                                  ),
                                )
                          : controller.callMessage.isNotEmpty
                              ? Text(
                                  controller.callMessage,
                                  style: AppTextStyle.textStyle10(
                                    fontWeight: FontWeight.w500,
                                    fontColor: Color(int.parse(controller
                                        .callMessageColor
                                        .replaceAll("#", "0xff"))),
                                  ),
                                )
                              : SizedBox(),
                    ],
                  )
                : SizedBox(),
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
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 2,
                  color: appColors.grey.withOpacity(0.2),
                ),
              ],
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
      key: DashboardController(PreDefineRepository()).keyManageDiscountOffers,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 2,
            color: appColors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              // InkWell(
              //   onTap: () {
              //     Get.toNamed(RouteName.discountOffers)!.then((value) {
              //       controller!.homeData?.offers?.customOffer = value;
              //       controller.update();
              //     });
              //   },
              //   child: Text(
              //     "viewAll".tr,
              //     style: AppTextStyle.textStyle12(
              //       fontWeight: FontWeight.w500,
              //       fontColor: appColors.darkBlue,
              //     ),
              //   ),
              // ),
            ],
          ),
          // Text(
          //   "(You can apply each offer only once per day)",
          //   style: AppTextStyle.textStyle10(
          //     fontWeight: FontWeight.w500,
          //     fontColor: appColors.guideColor,
          //   ),
          // ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller!.homeData!.offers!.customOffer!.length,
            separatorBuilder: (context, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              DiscountOffer data =
                  controller.homeData!.offers!.customOffer![index];

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
                    onTap: () async {
                      // Check if another request is already in progress
                      if (controller.offerTypeLoading.value ==
                          Loading.loading) {
                        return;
                      }

                      // if (data.isOn!) {
                      //   data.isOn = !data.isOn!;
                      //   controller.updateOfferType(
                      //       value: data.isOn!,
                      //       index: index,
                      //       offerId: data.id!,
                      //       offerType: 2);
                      //
                      //   controller.update();
                      // } else if (controller.homeData!.offers!.customOffer!
                      //     .any((element) => element.isOn!)) {
                      //   divineSnackBar(
                      //       data: "Only 1 custom offer is allowed at once",
                      //       color: appColors.redColor);
                      // } else {
                      //   data.isOn = !data.isOn!;
                      //   controller.updateOfferType(
                      //       value: data.isOn!,
                      //       index: index,
                      //       offerId: data.id!,
                      //       offerType: 2);
                      //   controller.update();
                      // }
                      // If the current switch is already on
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
    required String? btnTitle,
    required VoidCallback? onbtnTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                spreadRadius: 2,
                color: appColors.grey.withOpacity(0.2),
              ),
            ],
            color: appColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: InkWell(
            onTap: onbtnTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonImageView(
                  imagePath: "assets/images/referral.png",
                  height: 30,
                  width: 30,
                  placeHolder: Assets.images.defaultProfile.path,
                ),
                SizedBox(width: 5.w),
                Text(
                  btnTitle ?? "",
                  style: AppTextStyle.textStyle20(
                      fontWeight: FontWeight.w600,
                      fontColor: appColors.darkBlue),
                )
              ],
            ),
          )),
    );
  }

  Widget trainingVideoWidget({HomeController? controller}) {
    // if (controller!.homeData?.trainingVideo == null ||
    //     (controller.homeData?.trainingVideo ?? []).isEmpty) {
    //   return const SizedBox.shrink();
    // }
    return controller!.homeData != null &&
            controller!.homeData!.trainingVideo!.isNotEmpty
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: 5,
              bottom: 5,
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
                  blurRadius: 4,
                  spreadRadius: 2,
                  color: appColors.grey.withOpacity(0.2),
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
                        style: AppTextStyle.textStyle16(
                            fontWeight: FontWeight.w500),
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
                          child: Container(
                              height: 30,
                              width: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Assets.images.icInfo
                                    .svg(height: 15.h, width: 15.h),
                              ))),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller!.homeData?.trainingVideo?.length ?? 0,
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
                                  video: controller
                                      .homeData?.trainingVideo?[index],
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
                                            .homeData
                                            ?.trainingVideo?[index]
                                            .url ??
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
          )
        : SizedBox();
  }

  Widget feedbackWidget({HomeController? controller}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffEDEDED),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 4,
        //     spreadRadius: 2,
        //     color: appColors.grey.withOpacity(0.2),
        //   ),
        // ],
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
                // scrollPadding: EdgeInsets.only(
                //     bottom:
                //         MediaQuery.of(Get.context!).viewInsets.bottom + 160),
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
      functionalityWidget: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: controller!.loadWalletData.value == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
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
                          itemCount: controller.walletData.length,
                          itemBuilder: (context, index) {
                            return CustomInfoWidget(
                              text: controller.walletData[index].title,
                              badgeText: controller.walletData[index].sequence
                                  .toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
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
              style: AppTextStyle.textStyle9(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller?.selectedChatDate.value.toCustomFormat() ?? "",
              style: AppTextStyle.textStyle9(
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
              style: AppTextStyle.textStyle9(
                fontColor: appColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return Text(
              controller?.selectedCallDate.value.toCustomFormat() ?? "",
              style: AppTextStyle.textStyle9(
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

// Future<void> showDiscountPopup(controller) async {
//   return Get.dialog(
//     barrierDismissible: false,
//     AlertDialog(
//       // insetPadding: EdgeInsets.all(16),
//       // contentPadding: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       elevation: 0,
//       content: customerOfferWidget2(Get.context!, controller),
//     ),
//   );
// }
//
// Widget customerOfferWidget2(BuildContext context, controller) {
//   return Container(
//     key: DashboardController(PreDefineRepository()).keyManageDiscountOffers,
//     margin: EdgeInsets.only(top: 10.h),
//     padding: EdgeInsets.all(16.h),
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 1.0,
//             offset: const Offset(0.0, 3.0)),
//       ],
//       color: appColors.white,
//       borderRadius: const BorderRadius.all(Radius.circular(20)),
//     ),
//     child: Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Discount Offers",
//                 style: AppTextStyle.textStyle12(
//                   fontWeight: FontWeight.w500,
//                   fontColor: appColors.darkBlue,
//                 ),
//               ),
//
//               /*InkWell(
//                         onTap: () {
//                           Get.toNamed(RouteName.discountOffers)!.then((value) {
//                             controller!.homeData?.offers?.customOffer = value;
//                             controller.update();
//                           });
//                         },
//                         child: Text(
//                           "viewAll".tr,
//                           style: AppTextStyle.textStyle12(
//                             fontWeight: FontWeight.w500,
//                             fontColor: appColors.darkBlue,
//                           ),
//                         ),
//                       ),*/
//             ],
//           ),
//           // Text(
//           //   "(You can apply each offer only once per day)",
//           //   style: AppTextStyle.textStyle10(
//           //     fontWeight: FontWeight.w500,
//           //     fontColor: appColors.guideColor,
//           //   ),
//           // ),
//           SizedBox(height: 10.h),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: controller.homeData!.offers!.customOffer!.length,
//             separatorBuilder: (context, _) => SizedBox(height: 10.h),
//             itemBuilder: (context, index) {
//               DiscountOffer data =
//                   controller.homeData!.offers!.customOffer![index];
//
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     children: [
//                       Text(
//                         "${data.offerName}".toUpperCase(),
//                         style: AppTextStyle.textStyle12(
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       // if ((controller
//                       //     .homeData?.offers?.customOffer?[index].callRate ??
//                       //     0) >
//                       //     0)
//                       //   CustomText(
//                       //     " (₹${controller.homeData?.offers?.orderOffer?[index].callRate}/min)"
//                       //         .toUpperCase(),
//                       //     fontSize: 10.sp,
//                       //   ),
//                     ],
//                   ),
//                   SwitchWidget(
//                     onTap: () {
//                       if (data.isOn!) {
//                         data.isOn = !data.isOn!;
//                         controller.updateOfferType(
//                             value: data.isOn!,
//                             index: index,
//                             offerId: data.id!,
//                             offerType: 2);
//                       } else if (controller.homeData!.offers!.customOffer!
//                           .any((element) => element.isOn!)) {
//                         divineSnackBar(
//                             data: "Only 1 custom offer is allowed at once",
//                             color: appColors.redColor);
//                       } else {
//                         data.isOn = !data.isOn!;
//                         controller.updateOfferType(
//                             value: data.isOn!,
//                             index: index,
//                             offerId: data.id!,
//                             offerType: 2);
//                       }
//
//                       controller.update();
//                     },
//                     switchValue: data.isOn,
//                   )
//                 ],
//               );
//             },
//           ),
//         ],
//       );
//     }),
//   );
// }

class ChatAssistanceDataTileHome extends StatelessWidget {
  final ConsultationData data;
  final HomeController controller;
  final int index;

  const ChatAssistanceDataTileHome(
      {super.key,
      required this.data,
      required this.controller,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DataList dataList = DataList();
        dataList.name = data.customerName;
        dataList.id = data.customerId;
        dataList.image = data.customerImage;
        Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: appColors.guideColor),
                      height: 50.w,
                      width: 50.w,
                      child: LoadImage(
                        imageModel: ImageModel(
                          assetImage: false,
                          placeHolderPath: Assets.images.defaultProfile.path,
                          imagePath: (data.customerImage ?? '').startsWith(
                                  'https://divineprod.blob.core.windows.net/divineprod/')
                              ? data.customerImage ?? ''
                              : "${preferenceService.getAmazonUrl()}/${data.customerImage ?? ''}",
                          loadingIndicator: SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: CircularProgressIndicator(
                              color: appColors.guideColor,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.35),
                            child: CustomText(
                              data.customerName ?? '',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (data.level != null && data.level != "")
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: LevelWidget(level: data.level ?? "0"),
                            ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: appColors.white, width: 1.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                color: appColors.darkGreen),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: CustomText("Connect",
                                  fontColor: Colors.white, fontSize: 12.sp),
                            ),
                          )
                        ],
                      ),
                      CustomText(
                        "Total Consultation : ${data.totalConsultation}",
                        fontColor:
                            // (index == 0) ? appColors.darkBlue:
                            appColors.grey,
                        fontSize: 12.sp,
                        fontWeight:
                            //(index == 0) ? FontWeight.w600 :
                            FontWeight.normal,
                      ),
                      CustomText(
                        "Last Consulted : ${data.lastConsulted}",
                        fontColor:
                            // (index == 0) ? appColors.darkBlue:
                            appColors.grey,
                        fontSize: 12.sp,
                        fontWeight:
                            //(index == 0) ? FontWeight.w600 :
                            FontWeight.normal,
                      ),
                      CustomText(
                        "Days Since Last Consulted : ${data.daySinceLastConsulted}",
                        fontColor:
                            // (index == 0) ? appColors.darkBlue:
                            appColors.grey,
                        fontSize: 12.sp,
                        fontWeight:
                            //(index == 0) ? FontWeight.w600 :
                            FontWeight.normal,
                      )
                    ],
                  ),
                ),
                const Center(child: Icon(Icons.keyboard_arrow_right_outlined))
              ],
            ),
            Obx(() => controller.isLoadMoreData.value &&
                    !controller.emptyRes.value &&
                    controller.customerDetailsResponse!.data.length - 1 == index
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                    ),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}

class RechargeScreen extends StatelessWidget {
  List data = ["₹ 200", "₹ 300", "₹ 400"];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var selected;
    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
      child: Container(
        width: screenWidth * 0.8, // 80% of the screen width
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.grey.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
          // border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                // text: 'Hello ', // Default text style
                // style: DefaultTextStyle.of(context).style,

                children: <TextSpan>[
                  TextSpan(
                      text: 'Low balance!',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFFDF00))),
                  TextSpan(
                      text: ' Recharge to continue this chat',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: appColors.black)),
                ],
              ),
            ),
            SizedBox(height: 10),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 buttons in a row
                crossAxisSpacing: 20,
                mainAxisSpacing: 5,
                childAspectRatio: 2.2, // To control the size of each button
              ),
              itemCount: data.length,

              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Prevent scrolling inside GridView
              itemBuilder: (context, index) {
                return Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent.withOpacity(0.1),
                      border: Border.all(
                        color: appColors.green.withOpacity(0.9),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        // top: 0, bottom: 6, left: 10, right: 10
                        ),
                    child: Center(
                      child: Text(
                        data[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                ); // return _buildAmountButton(context, "200");
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAY USING',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: appColors.grey,
                        fontSize: 12,
                      ),
                    ),
                    DropdownButton<String>(
                      value: 'GPay',
                      underline: SizedBox(),
                      // itemHeight:40,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: appColors.black,
                        fontSize: 12,
                      ),
                      items: <String>['GPay', 'Paytm', 'PhonePe']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appColors.green,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        // top: 0, bottom: 6, left: 10, right: 10
                        ),
                    child: Center(
                      child: Text(
                        "Recharge Now",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: appColors.white,
                        ),
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
  }

  Widget _buildAmountButton(BuildContext context, String amount) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Colors.green), // Border color
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        amount,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
