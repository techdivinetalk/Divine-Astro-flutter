import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../model/important_numbers.dart';
import '../../../utils/enum.dart';
import 'important_numbers_controller.dart';

class ImportantNumbersUI extends GetView<ImportantNumbersController> {
  const ImportantNumbersUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        title: Text("importantNumbers".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors.darkBlue,
            )),
      ),
      body: GetBuilder<ImportantNumbersController>(builder: (controller) {
        if (controller.loading == Loading.loading ||
            controller.importantNumbers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(Colors.yellow),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 1.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(width: 1, color: AppColors.redColor),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          "You will get call and chat alerts from these numbers. Save these numbers to avoid any confusion.",
                          style: TextStyle(
                            color: AppColors.redColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.builder(
                    itemCount: controller.importantNumbers.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      MobileNumber phoneNumber =
                          controller.importantNumbers[index];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        phoneNumber.title ?? "".tr,
                                        style: AppTextStyle.textStyle16(
                                            fontColor: AppColors.darkBlue),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        phoneNumber.mobileNumber ?? "".tr,
                                        style: AppTextStyle.textStyle12(
                                            fontColor: AppColors.darkBlue),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    List<String> phoneNumbers = phoneNumber
                                        .mobileNumber!
                                        .split(",")
                                        .toList();
                                    controller.addContact(
                                      contactNumbers: phoneNumbers,
                                      givenName: phoneNumber.title ?? "",
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.lightYellow),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 10.h),
                                      child: Text(
                                        "addContact".tr,
                                        style: AppTextStyle.textStyle16(
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.brownColour),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 25.h),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
