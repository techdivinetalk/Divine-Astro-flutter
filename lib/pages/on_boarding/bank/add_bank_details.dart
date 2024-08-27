import 'dart:io';

import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/pages/on_boarding/widgets/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/routes.dart';
import 'bank_controller.dart';

class AddBankDetails extends GetView<BankController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankController>(
      assignId: true,
      init: BankController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: appColors.white,
          appBar: AppBar(
            backgroundColor: AppColors().white,
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4),
                constraints: BoxConstraints.loose(Size.zero),
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titleSpacing: 0,
            title: Text(
              "Bank Details",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.darkBlue,
              ),
            ),
            actions: [
              Text(
                "Skip",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: appColors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: "Enter Bank Name",
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hint: "Account Holder Name",
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hint: "Bank Account Number",
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hint: "IFSC Code",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "attachments".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.updateProfileImage("passBook");
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: appColors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: controller.passBookImage != null
                                  ? Image.file(
                                      File(controller.passBookImage.toString()),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.add,
                                      color: appColors.white,
                                      size: 80,
                                    ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Upload Passbook".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: appColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.updateProfileImage("cheque");
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: appColors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: controller.blankChequeImage != null
                                  ? Image.file(
                                      File(controller.blankChequeImage
                                          .toString()),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.add,
                                      color: appColors.white,
                                      size: 80,
                                    ),
                            ),
                          ),

                          // CommonImageView(
                          //     imagePath: Assets.images.defaultProfile.path,
                          //     radius: BorderRadius.circular(10.h),
                          //     height: 120,
                          //     width: MediaQuery.of(context).size.width * 0.4,
                          //     onTap: () {}),
                          SizedBox(height: 5.h),
                          Text(
                            "Upload Cancelled Cheque".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: appColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 110,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: RichText(
                      text: TextSpan(
                        text:
                            '* Confused? Don’t worry, We are here to help you! ',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: appColors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: 'Click here for a tutorial video.',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.poppins,
                              fontWeight: FontWeight.w400,
                              color: appColors.red,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle tap
                                print('Link tapped');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            RouteName.addEcomAutomation,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: appColors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                color: AppColors().white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
