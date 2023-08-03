import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/TextFieldCustom.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import 'bank_detail_controller.dart';

class BankDetailsUI extends GetView<BankDetailController> {
  const BankDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          AppString.yourBankDetails,
          style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Assets.images.icBankDetail.svg(height: 112.h, width: 112.w),
                  SizedBox(
                    width: 10.w,
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
                AppString.accountHolderName,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.holderNameHintText,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 25.w,
              ),
              //Bank Account Number
              Text(
                AppString.bankAccountNumber,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.accountNumHintText,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 25.w,
              ),
              //IFSC Code
              Text(
                AppString.iFSCCode,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.ifscCodeHintText,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 25.w,
              ),
              //attachments
              Text(
                AppString.attachments,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 25.w,
              ),
              Assets.images.bgTmpBank
                  .svg(height: 18.h, width: 18.w),
            ],
          ),
        ),
      ),
    );
  }
}
