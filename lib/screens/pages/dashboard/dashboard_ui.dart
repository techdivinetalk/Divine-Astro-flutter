import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/pages/home/home_ui.dart';
import 'package:divine_astrologer/screens/pages/performance/performance_ui.dart';
import 'package:divine_astrologer/screens/pages/suggest_remedies/suggest_remedies_ui.dart';
import 'package:divine_astrologer/screens/pages/wallet/wallet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import '../profile/profile_ui.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.scaffoldkey,
        body:
            Obx(() => widgetOptions.elementAt(controller.selectedIndex.value)),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      controller.selectedIndex.value == 0
                          ? Assets.images.icSelectedHome.svg(height: 24.h)
                          : Assets.images.icUnselectedHome.svg(height: 24.h),
                      const SizedBox(height: 5),
                      Text("Home",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: controller.selectedIndex.value == 0
                                  ? AppColors.darkBlue
                                  : AppColors.lightGrey))
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      controller.selectedIndex.value == 1
                          ? Assets.images.icSelectedPerfom.svg(height: 24.h)
                          : Assets.images.icUnselectedPerfom.svg(height: 24.h),
                      const SizedBox(height: 5),
                      Text("Performance",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: controller.selectedIndex.value == 1
                                  ? AppColors.darkBlue
                                  : AppColors.lightGrey))
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      controller.selectedIndex.value == 2
                          ? Assets.images.icSelectedSuggest.svg(height: 24.h)
                          : Assets.images.icUnselectedSuggest.svg(height: 24.h),
                      const SizedBox(height: 5),
                      Text("Suggest \nRemedies",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: controller.selectedIndex.value == 2
                                  ? AppColors.darkBlue
                                  : AppColors.lightGrey))
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      controller.selectedIndex.value == 3
                          ? Assets.images.icSelectedWallet.svg(height: 24.h)
                          : Assets.images.icUnselectedWallet.svg(height: 24.h),
                      const SizedBox(height: 5),
                      Text("Wallet",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: controller.selectedIndex.value == 3
                                  ? AppColors.darkBlue
                                  : AppColors.lightGrey))
                    ],
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      controller.selectedIndex.value == 3
                          ? Assets.images.icProfilePhoto.svg(height: 24.h)
                          : Assets.images.icProfilePhoto.svg(height: 24.h),
                      const SizedBox(height: 5),
                      Text(
                        "Profile",
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: controller.selectedIndex.value == 4
                                ? AppColors.darkBlue
                                : AppColors.lightGrey),
                      )
                    ],
                  ),
                  label: "",
                ),
              ],
              elevation: 0,
              currentIndex: controller.selectedIndex.value,
              onTap: (value) {
                _onItemTapped(value);
              },
            )));
  }

  void _onItemTapped(int index) {
    controller.selectedIndex.value = index;
  }

  static const List<Widget> widgetOptions = <Widget>[
    HomeUI(),
    PerformanceUI(),
    SuggestRemediesUI(),
    WalletUI(),
    ProfileUI()
  ];
}
