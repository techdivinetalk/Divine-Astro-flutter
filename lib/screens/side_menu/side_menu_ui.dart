import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/routes.dart';
import '../../pages/home/home_controller.dart';
import '../live_page/constant.dart';

class SideMenuDrawer extends GetView<HomeController> {
  final from;
  SideMenuDrawer({this.from});

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
                  onTap: () {
                    if (from == "Home") {
                      Get.put(HomeController()).homeScreenKey
                        ..currentState?.closeDrawer();
                    } else {
                      Get.back();
                    }
                    Get.put(HomeController()).showPopup = true;
                  },
                  child: const Icon(Icons.close),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            if (isWaitlist.value == 1)
              ListTile(
                leading: Assets.images.icWaiting.svg(),
                title: Text("waitlist".tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.waitList);
                },
              ),
            if (isOrderHistory.value == 1)
              ListTile(
                leading: Assets.images.icOrderHistory.svg(),
                title: Text("orderHistory".tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.orderHistory);
                },
              ),
            if (isMessageTemplate.value == 1)
              ListTile(
                leading: Assets.images.icMessageTemplate.svg(),
                title: Text("messageTemplate".tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.messageTemplate);
                },
              ),
            /*ListTile(
              leading: Assets.images.icSetting.svg(),
              title: Text('settings'.tr),
              onTap: () {
                Get.put(HomeController()).homeScreenKey
                  ..currentState?.closeDrawer();

                Get.back();
                Get.toNamed(RouteName.settingsUI);
              },
            ),*/
            if (isAstroCare.value == 1)
              ListTile(
                leading: Assets.images.icCustomerCare.svg(),
                title: Text('customerCare'.tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  controller.whatsapp();
                },
              ),
            if (isImportantNumber.value == 1)
              ListTile(
                leading: Assets.images.icImportContact.svg(),
                title: Text('importantNumbers'.tr),
                onTap: () async {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  bool isPermission = await requestPermissions();
                  if (isPermission) {
                    Get.toNamed(RouteName.importantNumbers);
                  } else {
                    divineSnackBar(data: "Please give permission for contacts");
                  }
                },
              ),
            if (isNotice.value == 1)
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text("noticeBoard".tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.noticeBoard);
                },
              ),
            ecomSupport.value.toString() == "1"
                ? ListTile(
                    leading: const Icon(Icons.shop_outlined),
                    title: Text('ecom_support'.tr),
                    onTap: () async {
                      if (from == "Home") {
                        Get.put(HomeController()).homeScreenKey
                          ..currentState?.closeDrawer();
                      } else {
                        Get.back();
                      }
                      Get.put(HomeController()).showPopup = true;

                      controller.is_ecom_supportWhatAspp();
                    },
                  )
                : SizedBox(),
            if (isTechnicalSupport.value == 1)
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: Text('technical_support'.tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.technicalIssues);
                },
              ),
            if (isFinancialSupport.value == 1)
              ListTile(
                leading: const Icon(Icons.request_quote_outlined),
                title: Text('financial_support'.tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.financialSupport);
                },
              ),
            if (isDrawerSupport.value == 1)
              ListTile(
                leading: const Icon(Icons.contact_support_outlined),
                title: Text('support'.tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.newSupportScreen);
                },
              ),
            kDebugMode
                ? ListTile(
                    leading: const Icon(Icons.check_box_outline_blank),
                    title: Text('Testing'.tr),
                    onTap: () {
                      if (from == "Home") {
                        Get.put(HomeController()).homeScreenKey
                          ..currentState?.closeDrawer();
                      } else {
                        Get.back();
                      }
                      Get.put(HomeController()).showPopup = true;

                      Get.toNamed(RouteName.testingScreen);
                    },
                  )
                : const SizedBox(),
            if (isSetting.value == 1)
              ListTile(
                leading: Assets.images.icSetting.svg(),
                title: Text('settings'.tr),
                onTap: () {
                  if (from == "Home") {
                    Get.put(HomeController()).homeScreenKey
                      ..currentState?.closeDrawer();
                  } else {
                    Get.back();
                  }
                  Get.put(HomeController()).showPopup = true;

                  Get.toNamed(RouteName.settingsUI);
                },
              ),
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
