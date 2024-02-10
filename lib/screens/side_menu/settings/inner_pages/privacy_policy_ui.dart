import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/model/pivacy_policy_model.dart';
import 'package:divine_astrologer/screens/side_menu/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PrivacyPolicyUI extends GetView<SettingsController> {
  const PrivacyPolicyUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.white,
        surfaceTintColor: appColors.white,
        title: Text("privacyPolicy".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
        leading: IconButton(
          highlightColor: appColors.transparent,
          splashColor: appColors.transparent,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: FutureBuilder(
        future: controller.getPrivacyPolicy(),
        builder: (context, AsyncSnapshot<PrivacyPolicyModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.h),
                child: Html(data: snapshot.data!.data.privacyPolicy),
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
              child: CustomText("somethingWentWrong".tr, fontSize: 20.sp),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
