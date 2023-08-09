import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
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
              title: Text(AppString.waitlist),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.waitList)
              },
            ),
            ListTile(
              leading: Assets.images.icOrderHistory.svg(),
              title: Text(AppString.orderHistory),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.orderHistory)
              },
            ),
            ListTile(
              leading: Assets.images.icReport.svg(),
              title: const Text('Report an Astrologer'),
              onTap: () => {},
            ),
            ListTile(
              leading: Assets.images.icSetting.svg(),
              title: const Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icContactUs1.svg(),
              title: const Text('Contact Us'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icFeedBack.svg(),
              title: const Text('Share Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icImportContact.svg(),
              title: const Text('Important numbers'),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.importantNumbers)
              },
            ),
            ListTile(
              leading: Assets.images.icDonations.svg(),
              title: const Text('Donation'),
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
