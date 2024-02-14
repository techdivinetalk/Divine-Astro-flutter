import 'dart:io';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/screens/bank_details/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../gen/assets.gen.dart';
import 'bank_detail_controller.dart';
import 'package:flutter/material.dart';

class BankDetailsUI extends GetView<BankDetailController> {
  const BankDetailsUI({super.key});

  Widget get sizedBox25 => SizedBox(height: 20.w);

  Widget get sizedBox5 => SizedBox(height: 8.w);

  Widget title(String data) => Text(
        data,
        style: AppTextStyle.textStyle16(
          fontWeight: FontWeight.w400,
          fontColor: appColors.darkBlue,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDetailController>(
      assignId: true,
      init: BankDetailController(),
      builder: (controller) {
        return Theme(
          data: ThemeData(useMaterial3: false),
          child: Scaffold(
            backgroundColor: appColors.white,
            bottomNavigationBar: controller.status == ""
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    child: CustomMaterialButton(
                      height: 50.h,
                      buttonName: "submit".tr,
                      textColor: appColors.brownColour,
                      onPressed: () => controller.submit(),
                    ),
                  )
                : const SizedBox(),
            body: SafeArea(
              child: Column(
                children: [
                  BackNavigationWidget(
                    title: "yourBankDetails".tr,
                    onPressedBack: () => Get.back(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 17.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                                key: controller.formState,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    title("bankName".tr),
                                    sizedBox5,
                                    WrapperContainer(
                                      child: BankDetailsField(
                                        validator: bankDetailValidator,
                                        controller: controller.bankName,
                                        hintText: "holderNameHintText".tr,
                                        inputAction: TextInputAction.next,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    sizedBox25,
                                    title("accountHolderName".tr),
                                    sizedBox5,
                                    WrapperContainer(
                                      child: BankDetailsField(
                                        validator: bankDetailValidator,
                                        controller: controller.holderName,
                                        hintText: "holderNameHintText".tr,
                                        inputAction: TextInputAction.next,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    sizedBox25,
                                    title("bankAccountNumber".tr),
                                    sizedBox5,
                                    WrapperContainer(
                                      child: BankDetailsField(
                                        validator: bankDetailValidator,
                                        controller: controller.accountNumber,
                                        hintText: "accountNumHintText".tr,
                                        inputAction: TextInputAction.next,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    sizedBox25,
                                    title("iFSCCode".tr),
                                    sizedBox5,
                                    WrapperContainer(
                                      child: BankDetailsField(
                                        validator: bankDetailValidator,
                                        controller: controller.ifscCode,
                                        hintText: "ifscCodeHintText".tr,
                                        inputAction: TextInputAction.next,
                                        inputType: TextInputType.text,
                                      ),
                                    ),
                                    sizedBox25,
                                    Row(
                                      children: [
                                        title("attachments".tr),
                                        const Spacer(),
                                        controller.status.isNotEmpty
                                            ? title(
                                                "status".tr +
                                                    " : " +
                                                    controller.status,
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    sizedBox5,
                                  ],
                                )),
                            GetBuilder<BankDetailController>(
                              builder: (controller) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.passBook == null && controller.passBookUrl.isEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .pickFile()
                                                      .then((value) {
                                                    print(value);
                                                    print(
                                                        "valuevaluevaluevaluevalue");
                                                    if (value != null) {
                                                      controller
                                                          .addPassBook(value);
                                                      controller.passBookUrl =
                                                          "";
                                                      print(controller
                                                              .passBookUrl
                                                              .isEmpty
                                                          ? controller
                                                              .passBook!.path
                                                          : controller
                                                              .passBookUrl);

                                                      controller.update();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: appColors.grey
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.h),
                                                  ),
                                                  height: 120,
                                                  child: Assets.svg.icAdd.svg(),
                                                ),
                                              )
                                            :   CommonImageView(
                                                    imagePath:
                                                    controller.passBookUrl.isEmpty
                                                        ? ("file://"+controller.passBook!.path):   controller.passBookUrl,
                                                    height: 120,
                                                    onTap: () {},
                                                    radius:
                                                        BorderRadius.circular(
                                                            10.h),
                                                  ),
                                        SizedBox(
                                          height: 5.h
                                        ),
                                        Text("passBook".tr),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),

                                  Expanded(
                                    child:controller.cancelledCheque == null && controller.cancelledChequeUrl.isEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              controller
                                                  .pickFile()
                                                  .then((value) {
                                                if (value != null) {
                                                  controller.addCancelledCheque(
                                                      value);
                                                }
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: appColors.grey
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(10.h),
                                              ),
                                              height: 120, 
                                              child: Assets.svg.icAdd.svg(),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonImageView(
                                                  imagePath: controller.cancelledChequeUrl.isEmpty
                                                      ? ("file://"+controller.cancelledCheque!.path):   controller.cancelledChequeUrl,
                                                  radius: BorderRadius.circular(
                                                      10.h),
                                                  height: 120,
                                                  onTap: () {
                                                    controller
                                                        .pickFile()
                                                        .then((value) {
                                                      if (value != null) {
                                                        controller
                                                            .addCancelledCheque(
                                                                value);
                                                      }
                                                    });
                                                  }),
                                              SizedBox(
                                                  height: 5.h
                                              ),
                                              Text("cancelledCheque".tr),

                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
