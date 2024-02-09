import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/order_history/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/custom_widgets.dart';
import '../performance_controller.dart';

class DateSelection extends GetView<OrderHistoryController> {
  const DateSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(
      assignId: true,
      init: OrderHistoryController(),
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
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
            SizedBox(height: 20.h),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  CustomText(
                    'selectCustomDate'.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectDateOrTime(
                              Get.context!,
                              futureDate: true,
                              title: "selectStartDate".tr,
                              btnTitle: "confirm".tr,
                              pickerStyle: "DateCalendar",
                              looping: true,
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2050),
                              onConfirm: (value) =>
                                  controller.selectChatDate(value),
                              onChange: (value) =>
                                  controller.selectChatDate(value),
                              onClickOkay: (value) {
                                Get.back();
                                DateTime dateTime =
                                    DateFormat("dd MMMM yyyy", "en_US")
                                        .parse(value);
                                String formattedDateString =
                                    DateFormat("yyyy-MM-dd").format(dateTime);
                                controller.startDate = formattedDateString;
                                controller.update();
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 0.6, color: Colors.grey)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 18.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Assets.images.icCalendar.svg(height: 20.h),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    controller.startDate.isEmpty
                                        ? "startDate".tr
                                        : controller.startDate,
                                    style: AppTextStyle.textStyle16(
                                        fontColor: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectDateOrTime(
                              Get.context!,
                              futureDate: true,
                              title: "selectEndDate".tr,
                              btnTitle: "confirm".tr,
                              pickerStyle: "DateCalendar",
                              looping: true,
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2050),
                              onConfirm: (value) =>
                                  controller.selectChatDate(value),
                              onChange: (value) =>
                                  controller.selectChatDate(value),
                              onClickOkay: (value) {
                                Get.back();
                                DateTime dateTime =
                                    DateFormat("dd MMMM yyyy", "en_US")
                                        .parse(value);
                                String formattedDateString =
                                    DateFormat("yyyy-MM-dd").format(dateTime);
                                controller.endDate = formattedDateString;
                                controller.update();
                                print(formattedDateString);
                                print("valuevaluevaluevalue");
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 0.6, color: Colors.grey)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 18.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Assets.images.icCalendar.svg(height: 20.h),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    controller.endDate.isEmpty
                                        ? "endDate".tr
                                        : controller.endDate,
                                    style: AppTextStyle.textStyle16(
                                        fontColor: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  MaterialButton(
                      height: 50,
                      minWidth: MediaQuery.sizeOf(context).width,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      onPressed: () {
                        if (controller.startDate.isEmpty) {
                          divineSnackBar(
                              data: "Please select start date",
                              color: AppColors.redColor);
                        } else if (controller.endDate.isEmpty) {
                          divineSnackBar(
                              data: "Please select end date",
                              color: AppColors.redColor);
                        } else {
                          Get.back(result: {
                            "start_date": controller.startDate,
                            "end_date": controller.endDate,
                          });
                        }
                      },
                      color: AppColors.appYellowColour,
                      child: Text(
                        "submit".tr,
                        style: const TextStyle(color: AppColors.brownColour),
                      )),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
