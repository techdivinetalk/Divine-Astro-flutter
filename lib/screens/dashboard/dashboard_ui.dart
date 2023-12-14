import 'package:divine_astrologer/common/accept_chat_request_screen.dart';
import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/screens/dashboard/widgets/accept_chat_widget.dart';
import 'package:divine_astrologer/screens/dashboard/widgets/rejoin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import '../../pages/home/home_ui.dart';
import '../../pages/performance/performance_ui.dart';
import '../../pages/profile/profile_ui.dart';
import '../../pages/suggest_remedies/suggest_remedies_ui.dart';
import '../chat_assistance/chat_assistance_ui.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<BroadcastMessage>(
          initialData: BroadcastMessage(name: '', data: {}),
          stream: controller.broadcastReceiver.messages,
          builder: (context, broadcastSnapshot) {
            return Stack(
              children: [
                Scaffold(
                    backgroundColor: AppColors.white,
                    key: controller.scaffoldkey,
                    body: Obx(
                      () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: widgetOptions.elementAt(controller.selectedIndex.value),
                        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
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
                                color: AppColors.lightGrey.withOpacity(0.50),
                              ),
                              const SizedBox(height: 10),
                              BottomNavigationBar(
                                backgroundColor: AppColors.white,
                                type: BottomNavigationBarType.fixed,
                                selectedFontSize: 10,
                                unselectedFontSize: 10,
                                selectedItemColor: AppColors.darkBlue,
                                unselectedItemColor: AppColors.lightGrey,
                                items: <BottomNavigationBarItem>[
                                  BottomNavigationBarItem(
                                    icon: Column(
                                      children: [
                                        Assets.images.icSelectedHome.svg(
                                            height: 22.h,
                                            colorFilter: ColorFilter.mode(
                                                controller.selectedIndex.value == 0
                                                    ? AppColors.darkBlue
                                                    : AppColors.lightGrey,
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
                                                controller.selectedIndex.value == 1
                                                    ? AppColors.darkBlue
                                                    : AppColors.lightGrey,
                                                BlendMode.srcIn)),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                    label: 'performance'.tr,
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Column(
                                      children: [
                                        Assets.images.icSelectedSuggest.svg(
                                            height: 22.h,
                                            colorFilter: ColorFilter.mode(
                                                controller.selectedIndex.value == 2
                                                    ? AppColors.darkBlue
                                                    : AppColors.lightGrey,
                                                BlendMode.srcIn)),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                    label: 'suggestRemediesHome'.tr,
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Assets.images.icChatBottom.svg(
                                            height: 22.h,
                                            colorFilter: ColorFilter.mode(
                                                controller.selectedIndex.value == 3
                                                    ? AppColors.darkBlue
                                                    : AppColors.lightGrey,
                                                BlendMode.srcIn)),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                    label: "chatAssistanceHome".tr,
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(22),
                                          child: CachedNetworkPhoto(
                                            url: "${controller.userProfileImage}",
                                            fit: BoxFit.cover,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                    label: "profile".tr,
                                  ),
                                ],
                                elevation: 0,
                                currentIndex: controller.selectedIndex.value,
                                onTap: (value) {
                                  _onItemTapped(value);
                                },
                              ),
                            ],
                          ),
                        ))),
                if (broadcastSnapshot.data!.name == 'ReJoinChat' &&
                    broadcastSnapshot.data!.data!['orderData']['status'] == '3')
                  Positioned(
                      bottom: kToolbarHeight,
                      left: 0,
                      right: 0,
                      child: RejoinWidget(data: broadcastSnapshot.data!.data!)),
                if (broadcastSnapshot.data!.name == 'AcceptChat' &&
                    broadcastSnapshot.data!.data!['orderData']['status'] == '0')
                  Positioned(
                      bottom: kToolbarHeight+20.w,
                      left: 0,
                      right: 0,
                      child: AcceptChatWidget(
                        data: broadcastSnapshot.data!.data!,
                        onTap: () {
                          debugPrint('AcceptChatWidget onTap');
                          controller.appFirebaseService.writeData(
                              'order/${broadcastSnapshot.data!.data!['orderId']}', {'status': '1'});
                          isBottomSheetOpen.value = true;
                        },
                      ))
              ],
            );
          }),
    );
  }

  void _onItemTapped(int index) async {
    controller.selectedIndex.value = index;
  }

  static List<Widget> widgetOptions = <Widget>[
    const HomeUI(),
    const PerformanceUI(),
    const SuggestRemediesUI(),
    const ChatAssistancePage(),
    ProfileUI()
  ];
}
