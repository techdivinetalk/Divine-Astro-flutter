import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/ChatOrderResponse.dart';
import 'package:divine_astrologer/pages/home/home_controller.dart';
import 'package:divine_astrologer/pages/performance/performance_controller.dart';
import 'package:divine_astrologer/pages/profile/profile_page_controller.dart';
import 'package:divine_astrologer/pages/profile/profile_ui.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_assistance_controller.dart';
import 'package:divine_astrologer/screens/dashboard/widgets/rejoin_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:divine_astrologer/screens/side_menu/wait_list/wait_list_controller.dart';
import 'package:divine_astrologer/screens/side_menu/wait_list/wait_list_ui.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import '../../common/common_functions.dart';
import '../../di/notification_two.dart';
import '../../pages/home/home_ui.dart';
import '../../pages/performance/performance_ui.dart';
import '../../repository/waiting_list_queue_repository.dart';
import '../chat_assistance/chat_assistance_ui.dart';
import '../live_page/constant.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseInAppMessaging.instance
        .triggerEvent('your_event_name')
        .then((_) => print('Event triggered'));
    print("beforeGoing 4 - ${preferenceService.getUserDetail()?.id}");
    // FirebaseMessaging.instance.getToken().then((value) {
    //   print("FirebaseMessagingToken: $value");
    //   // preferenceService.setFirebaseToken(value);
    // });
    return GetBuilder<DashboardController>(
      assignId: true,
      builder: (controller) {
        return Material(
          child: StreamBuilder<BroadcastMessage>(
              initialData: BroadcastMessage(name: '', data: {}),
              stream: controller.broadcastReceiver.messages,
              builder: (context, broadcastSnapshot) {
                final isDataNull = broadcastSnapshot.data != null &&
                    broadcastSnapshot.data?.data != null &&
                    broadcastSnapshot.data?.data?['orderData'] != null &&
                    broadcastSnapshot.data?.data?['orderData']['status'] !=
                        null;
                return Stack(
                  children: [
                    Scaffold(
                        backgroundColor: appColors.white,
                        key: controller.scaffoldkey,
                        body: Obx(
                          () {
                            debugPrint(
                                "test_selectedIndex: ${controller.selectedIndex.value}");
                            if (controller.selectedIndex.value == 0) {
                              debugPrint(
                                  "test_selectedIndex_isRegistered: ${Get.isRegistered<HomeController>()}");
                              if (Get.isRegistered<HomeController>() &&
                                  !Get.find<HomeController>().isInit) {
                                Get.find<HomeController>().onInit();
                              }
                            } else if (controller.selectedIndex.value == 1) {
                              debugPrint(
                                  "test_selectedIndex_isRegistered: ${Get.isRegistered<PerformanceController>()}");
                              if (Get.isRegistered<PerformanceController>() &&
                                  !Get.find<PerformanceController>().isInit) {
                                Get.find<PerformanceController>().onInit();
                              }
                            } else if (controller.selectedIndex.value == 2) {
                              debugPrint(
                                  "test_selectedIndex_isRegistered: ${Get.isRegistered<ChatAssistanceController>()}");
                              if (Get.isRegistered<
                                      ChatAssistanceController>() &&
                                  !Get.find<ChatAssistanceController>()
                                      .isInit) {
                                Get.find<ChatAssistanceController>().onInit();
                              }
                            } else if (controller.selectedIndex.value == 3) {
                              debugPrint(
                                  "test_selectedIndex_isRegistered: ${Get.isRegistered<WaitListUIController>()}");
                              if (Get.isRegistered<WaitListUIController>() &&
                                  !Get.find<WaitListUIController>().isInit) {
                                Get.find<WaitListUIController>().onInit();
                                WaitListUIController(WaitingListQueueRepo())
                                    .getWaitingList();
                              }
                            } else if (controller.selectedIndex.value == 4) {
                              debugPrint(
                                  "test_selectedIndex_isRegistered: ${Get.isRegistered<ProfilePageController>()}");
                              if (Get.isRegistered<ProfilePageController>() &&
                                  !Get.find<ProfilePageController>().isInit) {
                                Get.find<ProfilePageController>().onInit();
                              }
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: widgetOptions
                                  .elementAt(controller.selectedIndex.value),
                              transitionBuilder: (child, anim) {
                                return FadeTransition(
                                    opacity: anim, child: child);
                              },
                            );
                          },
                        ),
                        bottomNavigationBar: Obx(() => SafeArea(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: ScreenUtil().screenWidth * 0.9,
                                    height: 1,
                                    color:
                                        appColors.lightGrey.withOpacity(0.50),
                                  ),
                                  const SizedBox(height: 10),
                                  BottomNavigationBar(
                                    backgroundColor: appColors.white,
                                    type: BottomNavigationBarType.fixed,
                                    selectedFontSize: 10,
                                    unselectedFontSize: 10,
                                    selectedItemColor: appColors.darkBlue,
                                    unselectedItemColor: appColors.lightGrey,
                                    items: <BottomNavigationBarItem>[
                                      BottomNavigationBarItem(
                                        key: controller.keyHome,
                                        icon: Column(
                                          children: [
                                            Assets.images.icSelectedHome.svg(
                                                height: 22.h,
                                                colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            0
                                                        ? appColors.darkBlue
                                                        : appColors.lightGrey,
                                                    BlendMode.srcIn)),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        label: 'home'.tr,
                                      ),
                                      BottomNavigationBarItem(
                                        key: controller.keyPerformance,
                                        icon: Column(
                                          children: [
                                            Assets.images.icSelectedPerfom.svg(
                                                height: 22.h,
                                                colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            1
                                                        ? appColors.darkBlue
                                                        : appColors.lightGrey,
                                                    BlendMode.srcIn)),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        label: 'performance'.tr,
                                      ),
                                      BottomNavigationBarItem(
                                        key: controller.keyAssistance,
                                        icon: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Assets.images.icChatBottom.svg(
                                                height: 22.h,
                                                colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            2
                                                        ? appColors.darkBlue
                                                        : appColors.lightGrey,
                                                    BlendMode.srcIn)),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        label: "assistance".tr,
                                      ),
                                      BottomNavigationBarItem(
                                        key: controller.keyQueue,
                                        icon: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Assets.svg.queue.svg(
                                                height: 22.h,
                                                colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            3
                                                        ? appColors.darkBlue
                                                        : appColors.lightGrey,
                                                    BlendMode.srcIn)),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        label: "queue".tr,
                                      ),

                                      // Profile Tab comment
                                      BottomNavigationBarItem(
                                        key: controller.keyProfile,
                                        icon: Column(
                                          children: [
                                            userImage.value.contains("null") ||
                                                    userImage.value.isEmpty ||
                                                    userImage.value == ""
                                                ? SizedBox(
                                                    height: 30.h,
                                                    width: 30.h,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.h),
                                                      child: Image.asset(Assets
                                                          .images
                                                          .defaultProfile
                                                          .path),
                                                    ),
                                                  )
                                                : CommonImageView(
                                                    imagePath: userImage.value,
                                                    fit: BoxFit.cover,
                                                    height: 30.h,
                                                    width: 30.h,
                                                    placeHolder: Assets.images
                                                        .defaultProfile.path,
                                                    radius:
                                                        BorderRadius.circular(
                                                            100.h),
                                                  ),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        label: "profile".tr,
                                      ),
                                    ],
                                    elevation: 0,
                                    currentIndex:
                                        controller.selectedIndex.value,
                                    onTap: (value) {
                                      if (value == 2 &&
                                          isEngagedStatus.value == 2) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Can\'t Perform this action while in a Chat');
                                      } else {
                                        controller.selectedIndex.value = value;
                                        dasboardCurrentIndex(value);
                                      }
                                      /* if (controller.selectedIndex.value == 2) {
                                       // Get.toNamed(RouteName.orderHistory);
                                      } else {

                                      }*/
                                    },
                                  ),
                                ],
                              ),
                            ))),
                    controller.chatOrderData != null &&
                            controller.chatOrderData?.status.toString() == "0"
                        ? acceptBottomBar(
                            chatOrderData: controller.chatOrderData)
                        : const SizedBox(),
                    rejoinVisibility(),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget rejoinVisibility() {
    return Obx(
      () {
        final dynamic cond =
            AppFirebaseService().orderData.value["status"] ?? "0";
        print("order_Status $cond");
        return cond == "2" ||
                cond == 2 ||
                cond == "3" ||
                cond == 3 ||
                cond == "4" ||
                cond == 4
            ? Positioned(
                bottom: kToolbarHeight + 20.w,
                left: 0,
                right: 0,
                child: const RejoinWidget(),
              )
            : const SizedBox();
      },
    );
  }

  Widget acceptBottomBar({ChatOrderData? chatOrderData}) {
    return Positioned(
      bottom: kToolbarHeight + 20.w,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: appColors.white,
          border: Border.all(
            color: Colors.grey, // Choose your border color here
            width: 2, // Adjust the width as needed
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                offset: const Offset(3, 0)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Wrap(direction: Axis.horizontal, children: [
                CustomText('You have request from ', fontSize: 10.sp),
                CustomText(chatOrderData!.getCustomers.name,
                    fontSize: 10.sp,
                    fontColor: appColors.brown,
                    fontWeight: FontWeight.w700),
                CustomText(' accept it', fontSize: 10.sp),
                SizedBox(width: 8.w),
              ]),
            ),
            Card(
              color: appColors.guideColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: InkWell(
                onTap: () async {
                  debugPrint('rejoinChatIcon');

                  await acceptOrRejectChat(
                    orderId: controller.chatOrderData?.orderId,
                    queueId: controller.chatOrderData?.id,
                  );
                  await AppFirebaseService()
                      .database
                      .child("order/${controller.chatOrderData?.orderId}")
                      .update({"status": "1"});
                  await controller.getOrderFromApi();
                  // Get.toNamed(RouteName.chatMessageWithSocketUI);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0.sp), // Adjust padding as needed
                  child: Row(
                    children: [
                      CustomText(
                        "Accept Chat",
                        fontSize: 12.sp,
                        fontColor: appColors.white,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5.w),
                      Assets.svg.rejoin.svg(height: 12.sp)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            SizedBox(
              height: 32,
              width: 32,
              child: CustomImageWidget(
                imageUrl:
                    "${preferenceService?.getAmazonUrl()}${chatOrderData!.getCustomers.avatar}",
                rounded: true,
                typeEnum: TypeEnum.user,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> widgetOptions = <Widget>[
    const HomeUI(),
    const PerformanceUI(),
    //const SuggestRemediesUI(),
    ChatAssistancePage(),
    const WaitListUI(),
    ProfileUI()
  ];
}
