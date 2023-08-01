import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/pages/home/home_ui.dart';
import 'package:divine_astrologer/screens/pages/performance/performance_ui.dart';
import 'package:divine_astrologer/screens/pages/suggest_remedies/suggest_remedies_ui.dart';
import 'package:divine_astrologer/screens/pages/wallet/wallet_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import '../profile/profile_ui.dart';
import '../side_menu/side_menu_ui.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonDashboardAppBar(),
        drawer: const SideMenuDrawer(),
        key: controller.scaffoldkey,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Obx(() => widgetOptions.elementAt(controller.selectedIndex.value)),
          ],
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Assets.images.icHome.image(),
                      const SizedBox(height: 5),
                      Text("Home",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: AppColors.darkGreen))
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Assets.images.icPerformance.image(),
                      const SizedBox(height: 5),
                      Text("Performance",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: AppColors.darkGreen))
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.images.icSuggestRemedies.image(),
                      const SizedBox(height: 5),
                      Text("Suggest \nRemedies",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: AppColors.darkGreen))
                    ],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Assets.images.icWallet.image(),
                      const SizedBox(height: 5),
                      Text("Wallet",
                          maxLines: 2,
                          style: AppTextStyle.textStyle10(
                              fontColor: AppColors.darkGreen))
                    ],
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Assets.images.icProfile.image(),
                      const SizedBox(height: 5),
                      const Text(
                        "Profile",
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  label: "",
                ),
              ],
              elevation: 0,
              currentIndex: controller.selectedIndex.value,
              selectedItemColor: Colors.amber[800],
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

  PreferredSizeWidget commonDashboardAppBar() {
    return AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Obx(
          () => SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.isShowTitle.isTrue
                    ? Text(
                        controller.appbarTitle.value,
                        style: AppTextStyle.textStyle16(),
                      )
                    : Container(),
                InkWell(
                    onTap: () {
                      controller.isShowTitle.value =
                          !controller.isShowTitle.value;
                    },
                    child: const Icon(Icons.visibility))
              ],
            ),
          ),
        ));
  }
}
