import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Version 0.0.0.0.0",
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close))
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Assets.images.icWaiting.svg(),
              title: Text("waitlist".tr),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.waitList)
              },
            ),
            ListTile(
              leading: Assets.images.icOrderHistory.svg(),
              title: Text("orderHistory".tr),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.orderHistory)
              },
            ),
            ListTile(
              leading: Assets.images.icReport.svg(),
              title: Text("reportAnAstrologer".tr),
              onTap: () => {},
            ),
            ListTile(
              leading: Assets.images.icSetting.svg(),
              title: Text('settings'.tr),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.settingsUI)
              },
            ),
            ListTile(
              leading: Assets.images.icContactUs1.svg(),
              title: Text('contactUs'.tr),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icFeedBack.svg(),
              title: Text('shareFeedback'.tr),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icImportContact.svg(),
              title: Text('importantNumbers'.tr),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.importantNumbers)
              },
            ),
            ListTile(
              leading: Assets.images.icDonations.svg(),
              title: Text('donation'.tr),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.donationUi)
              },
            ),
          ],
        ),
      ),
    );
  }
}
