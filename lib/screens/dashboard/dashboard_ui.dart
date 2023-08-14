// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
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
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        key: controller.scaffoldkey,
        body:
            Obx(() => widgetOptions.elementAt(controller.selectedIndex.value)),
        bottomNavigationBar: Obx(() => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 1),
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
                                color: controller.selectedIndex.value == 0
                                    ? AppColors.darkBlue
                                    : AppColors.lightGrey),
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
                                color: controller.selectedIndex.value == 1
                                    ? AppColors.darkBlue
                                    : AppColors.lightGrey),
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
                                color: controller.selectedIndex.value == 2
                                    ? AppColors.darkBlue
                                    : AppColors.lightGrey),
                            const SizedBox(height: 5),
                          ],
                        ),
                        label: 'suggestRemediesHome'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Column(
                          children: [
                            Assets.images.icChatBottom.svg(
                                height: 22.h,
                                color: controller.selectedIndex.value == 3
                                    ? AppColors.darkBlue
                                    : AppColors.lightGrey),
                            const SizedBox(height: 5),
                          ],
                        ),
                        label: "chatAssistance".tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Column(
                          children: [
                            Assets.images.icProfilePhoto.svg(
                                height: 22.h,
                                color: controller.selectedIndex.value == 4
                                    ? AppColors.darkBlue
                                    : AppColors.lightGrey),
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
            )));
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
