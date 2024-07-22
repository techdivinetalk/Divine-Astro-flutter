import 'dart:developer';

import 'package:divine_astrologer/screens/side_menu/testing/testing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../pages/home/home_controller.dart';
import '../../../repository/user_repository.dart';
import '../../live_page/constant.dart';
import '../../technical_issue/issues_screen/technical_issue_controller.dart';

class TestingUI extends GetView<TestingController> {
  const TestingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TechnicalIssuesListController>(
        init: TechnicalIssuesListController(UserRepository()),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              leading: IconButton(
                highlightColor: appColors.transparent,
                splashColor: appColors.transparent,
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              forceMaterialTransparency: true,
              backgroundColor: appColors.white,
              title: Text(
                "Testing".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      final HomeController homeC = Get.find<HomeController>();
                      homeC.chatSwitchFN(onComplete: () {});
                      bool isChatOn = chatSwitch.value;
                      log(isChatOn.toString());
                    },
                    leading: CircleAvatar(
                      backgroundColor: appColors.red,
                      child: Text(
                        "F".tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20.sp,
                          color: appColors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      "Firebase".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    subtitle: Text(
                      "This is used to test and we are enabling the chat enable firebase function."
                          .tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      controller.getTechnicalTickets();
                    },
                    leading: CircleAvatar(
                      backgroundColor: appColors.red,
                      child: Text(
                        "A".tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20.sp,
                          color: appColors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      "Apis".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    subtitle: Text(
                      "This is used to test and we are hitting on api to test apis."
                          .tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: appColors.darkBlue,
                      ),
                    ),
                    trailing: controller.isTechnicalLoading == true
                        ? const CircularProgressIndicator(
                            strokeWidth: 1,
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
