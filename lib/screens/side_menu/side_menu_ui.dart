import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/routes.dart';
import '../../pages/home/home_controller.dart';

class SideMenuDrawer extends GetView<HomeController> {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // checkInternetSpeed(true,context);
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*Text(
                 */ /* "${'version'.tr} 4.1.0"*/ /*"",
                  style: TextStyle(fontSize: 16, color: appColors.grey),
                ),*/
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const SizedBox(width: 10),
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
              title: Text("messageTemplate".tr),
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
              onTap: () async {
                Navigator.of(context).pop();
                bool isPermission = await requestPermissions();
                if (isPermission) {
                  Get.toNamed(RouteName.importantNumbers);
                } else {
                  divineSnackBar(data: "Please give permission for contacts");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: Text('Technical Issues'.tr),
              onTap: () async {
                Navigator.of(context).pop();
                Get.toNamed(RouteName.technicalIssues);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: Text('Financial Support'.tr),
              onTap: () async {
                Navigator.of(context).pop();
                Get.toNamed(RouteName.financialSupport);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: Text('Support'.tr),
              onTap: () async {
                Navigator.of(context).pop();
                Get.toNamed(RouteName.newSupportScreen);
              },
            ),
            kDebugMode
                ? ListTile(
                    leading: const Icon(Icons.check_box_outline_blank),
                    title: Text('Testing'.tr),
                    onTap: () async {
                      Navigator.of(context).pop();
                      Get.toNamed(RouteName.testingScreen);
                    },
                  )
                : const SizedBox(),
            // ListTile(
            //   leading: Assets.images.icImportContact.svg(),
            //   title: Text("leaveresignation".tr),
            //   onTap: () async {
            //     Navigator.of(context).pop();
            //     Get.toNamed(RouteName.resignation);
            //
            //     // bool isPermission = await requestPermissions();
            //     // if (isPermission) {
            //     //   Get.toNamed(RouteName.importantNumbers);
            //     // } else {
            //     //   divineSnackBar(data: "Please give permission for contacts");
            //     // }
            //   },
            // ),
            /*  ListTile(
              leading: Assets.images.icDonations.svg(),
              title: Text('donation'.tr),
              onTap: () => {
                Navigator.of(context).pop(),
                Get.toNamed(RouteName.donationUi)
              },
            ),*/
          ],
        ),
      ),
    );
  }

  requestPermissions() async {
    var status = await Permission.contacts.status;
    bool isGranted = false;
    if (!status.isGranted) {
      await Permission.contacts.request().then((value) {
        print("is granted contact permission ? ==> ${isGranted}");
      });
    } else {}
    return Permission.contacts.isGranted;
  }
}
