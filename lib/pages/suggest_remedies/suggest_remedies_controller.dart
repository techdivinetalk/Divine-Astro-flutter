import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/common_bottomsheet.dart';
import '../../common/strings.dart';
import '../../gen/assets.gen.dart';

class SuggestRemediesController extends GetxController {
  var item = [
    ["Pooja"],
    ["Puja Saman"],
    ["Puja Saman"],
    ["Puja Saman"],
    ["Puja Saman"],
  ];

  remediesLeftPopup(BuildContext context) async {
    await openBottomSheet(
      context,
      functionalityWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                Assets.images.icRemediesLeft.svg(),
                SizedBox(height: 10.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '10  ',
                          style: AppTextStyle.textStyle20(
                              fontColor: AppColors.redColor,
                              fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: "remediesLeft".tr,
                          style: AppTextStyle.textStyle20(
                              fontColor: AppColors.darkBlue,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'You can only suggest 10 remedies to the users per day. Please suggest carefully.',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.textStyle16(fontColor: AppColors.darkBlue),
                ),
                SizedBox(height: 25.h),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.lightYellow),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Center(
                              child: Text(
                                'okay'.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.brownColour,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
