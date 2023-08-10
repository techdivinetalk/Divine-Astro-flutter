import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/text_field_custom.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../common/appbar.dart';
import 'bank_detail_controller.dart';

class BankDetailsUI extends GetView<BankDetailController> {
  const BankDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonDetailAppbar(title: "yourBankDetails".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Assets.images.icBankDetail.svg(height: 100.h, width: 101.w),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    "State Bank Of \nIndia",
                    style: AppTextStyle.textStyle24(
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.darkBlue),
                  ),
                ],
              ),
              SizedBox(
                height: 25.w,
              ),
              //account Holder Name
              Text(
                "accountHolderName".tr,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: "holderNameHintText".tr,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 25.w,
              ),
              //Bank Account Number
              Text(
                "bankAccountNumber".tr,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: "accountNumHintText".tr,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 25.w,
              ),
              //IFSC Code
              Text(
                "iFSCCode".tr,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: "ifscCodeHintText".tr,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 25.w,
              ),
              //attachments
              Text(
                "attachments".tr,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 25.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
