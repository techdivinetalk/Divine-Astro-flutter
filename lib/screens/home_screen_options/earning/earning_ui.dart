import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/strings.dart';
import 'package:divine_astrologer/screens/home_screen_options/earning/earning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';

class YourEarning extends GetView<YourEarningController> {
  const YourEarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: AppString.yourEarning),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              durationWidget(),
              const SizedBox(height: 20),
              ListView.builder(
                controller: controller.earningScrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.earningList.length,
                itemBuilder: (context, index) {
                  Widget separator = const SizedBox(height: 30);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      earningOptionDetail(
                          image: controller.earningImgList[index],
                          optionTitle: controller.earningList[index],
                          amount: "₹ 10000",
                          onTap: () {}),
                      separator,
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget durationWidget() {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppString.lifeTimeEarning,
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
          ),
          Assets.images.icDownArrow.svg()
        ],
      ),
    );
  }

  Widget earningOptionDetail(
      {required Widget image,
      required String? optionTitle,
      required String amount,
      required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10.h, 20, 10.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          image,
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$optionTitle",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              Text(
                amount,
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AppStrings {}
