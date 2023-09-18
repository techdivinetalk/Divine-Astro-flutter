import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/terms_and_condition_model.dart';
import 'package:divine_astrologer/screens/side_menu/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/custom_widgets.dart';

class TermsConditionUI extends GetView<SettingsController> {
  const TermsConditionUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: Text("Terms And Condition".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors.darkBlue,
            )),
        leading: IconButton(
          highlightColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: FutureBuilder(
        future: controller.getTermsCondition(),
        builder: (context, AsyncSnapshot<TermsConditionModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.h),
                child: Html(data: snapshot.data!.data.termsAndCondition),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.yellow),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: CustomText("Something went wrong", fontSize: 20.sp),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
