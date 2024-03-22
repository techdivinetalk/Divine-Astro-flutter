import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/pages/profile/profile_ui.dart';
import 'package:divine_astrologer/screens/dashboard/widgets/rejoin_widget.dart';
import 'package:divine_astrologer/screens/side_menu/wait_list/wait_list_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import "../../common/routes.dart";
import '../../pages/home/home_ui.dart';
import '../../pages/performance/performance_ui.dart';

import '../chat_assistance/chat_assistance_ui.dart';
import '../live_page/constant.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: widgetOptions
                                .elementAt(controller.selectedIndex.value),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                          ),
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
                                      // Remedies icon comment
                                      /* BottomNavigationBarItem(
                                        icon: Column(
                                          children: [
                                            Assets.images.icSelectedSuggest.svg(
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
                                        label: "Remedies",
                                      ),*/
                                      BottomNavigationBarItem(
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
                                        label: "Assistance",
                                      ),
                                      BottomNavigationBarItem(
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
                                        label: "Queue",
                                      ),

                                      // Profile Tab comment
                                      BottomNavigationBarItem(
                                        icon: Column(
                                          children: [

                                            userImage.value
                                                        .contains("null") ||
                                                userImage
                                                        .value.isEmpty ||
                                                userImage
                                                            .value ==
                                                        ""
                                                ? SizedBox(
                                              height: 30.h,
                                                    width: 30.h,
                                              child: ClipRRect(
                                              borderRadius:  BorderRadius.circular(
                                                    100.h),
                                                child: Image.asset(Assets
                                                    .images
                                                    .defaultProfile
                                                    .path),
                                              ),
                                                  )
                                                : CommonImageView(
                                                    imagePath:userImage.value,
                                                    fit: BoxFit.cover,
                                                    height: 30.h,
                                                    width: 30.h,
                                                    placeHolder:
                                                    Assets.images.defaultProfile.path,
                                                    radius:
                                                        BorderRadius.circular(
                                                            100.h),
                                                  ),
                                                 /*CommonImageView(
                                          imagePath:
                                              "${controller.userProfileImage}",
                                          fit: BoxFit.cover,
                                          height: 30,
                                          width: 30,
                                          radius: BorderRadius.circular(50),
                                        ), */
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

                    rejoinVisibility(),
                    // if (broadcastSnapshot.data!.name == 'ReJoinChat' &&
                    //     broadcastSnapshot.data!.data!['orderData']['status'] ==
                    //         '3')
                    //   Positioned(
                    //       bottom: kToolbarHeight + 20.w,
                    //       left: 0,
                    //       right: 0,
                    //       child: RejoinWidget(
                    //           data: broadcastSnapshot.data!.data!)),
                    // if (broadcastSnapshot.data!.name == 'AcceptChat' &&
                    //     broadcastSnapshot.data!.data!['orderData']['status'] ==
                    //         '0')
                    //   Positioned(
                    //       bottom: kToolbarHeight + 20.w,
                    //       left: 0,
                    //       right: 0,
                    //       child: AcceptChatWidget(
                    //         data: broadcastSnapshot.data!.data!,
                    //         onTap: () {
                    //           debugPrint('AcceptChatWidget onTap');
                    //           controller.appFirebaseService.writeData(
                    //               'order/${broadcastSnapshot.data!.data!['orderId']}',
                    //               {'status': '1'});
                    //           controller.appFirebaseService.acceptBottomWatcher
                    //               .strValue = '1';
                    //         },
                    //       ))
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
        final dynamic cond = AppFirebaseService().orderData.value["status"] ?? "0";
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

  static List<Widget> widgetOptions = <Widget>[
    const HomeUI(),
    const PerformanceUI(),
    //const SuggestRemediesUI(),
    ChatAssistancePage(),
    const WaitListUI(),
    ProfileUI()
  ];
}
