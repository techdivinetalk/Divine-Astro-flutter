import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import 'on_boarding_issue_controller.dart';

class OnBoardingIssueBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingIssueController());
  }
}

class OnBoardingIssueScreen extends GetView<OnBoardingIssueController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingIssueController>(
      init: OnBoardingIssueController(),
      assignId: true,
      builder: (controller) {
        // controller.getStatusFromFir();

        return PopScope(
          canPop: false,
          onPopInvoked: (bool) async {
            // controller.showExitAppDialog();
          },
          child: Scaffold(
            backgroundColor: appColors.white,
            appBar: AppBar(
              backgroundColor: AppColors().white,
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: Text(
                "Something went wrong",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.darkBlue,
                ),
              ),
            ),
            body: Column(
              children: [],
            ),
          ),
        );
      },
    );
  }
}
