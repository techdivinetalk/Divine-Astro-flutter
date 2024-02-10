import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/routes.dart';
import '../../pages/home/home_controller.dart';

class SideMenuDrawer extends GetView<HomeController> {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    checkInternetSpeed(true,context);
    return Drawer(
      backgroundColor: appColors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${'version'.tr} 0.0.0.0.0",
                  style:  TextStyle(fontSize: 16, color: appColors.grey),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
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
              onTap: () => {Get.back(), Get.toNamed(RouteName.orderHistory)},
            ),
            ListTile(
              leading: Assets.images.icMessageTemplate.svg(),
              title: Text("Message Template"),
              onTap: () => {Get.back(), Get.toNamed(RouteName.messageTemplate)},
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
              leading: Assets.images.icCustomerCare.svg(),
              title: Text('customerCare'.tr),
              onTap: () => {Navigator.of(context).pop(), controller.whatsapp()},
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
