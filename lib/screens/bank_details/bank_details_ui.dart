import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/bank_details/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Scaffold(
        backgroundColor: appColors.white,
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: CustomMaterialButton(
            height: 50.h,
            buttonName: "submit".tr,
            textColor: appColors.brownColour,
            onPressed: () => controller.submit(),
          ),
        ),
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
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                title("bankName".tr),
                                sizedBox5,
                                WrapperContainer(
                                  child: BankDetailsField(
                                    validator: bankDetailValidator,
                                    controller: controller.state.bankName,
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
                                    controller: controller.state.holderName,
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
                                    controller: controller.state.accountNumber,
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
                                    controller: controller.state.ifscCode,
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
                                    title("status".tr +" : " + controller.state.status,)
                                  ],
                                ),
                                sizedBox5,
                              ],
                            )),
                        GetBuilder<BankDetailController>(
                          builder: (controller) => Row(
                            children: [
                              ImagePickerButton(
                                title: "passBook".tr,
                                file: controller.passBook,
                                onTap: () {
                                  controller.pickFile().then((value) {
                                    if (value != null) {
                                      controller.addPassBook(value);
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 12.w),
                              ImagePickerButton(
                                file: controller.cancelledCheque,
                                title: "cancelledCheque".tr,
                                onTap: () {
                                  controller.pickFile().then((value) {
                                    if (value != null) {
                                      controller.addCancelledCheque(value);
                                    }
                                  });
                                },
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
  }
}
