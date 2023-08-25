import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/order_history_model/remedy_suggested_order_history.dart';
import '../order_history_controller.dart';

class SuggestRemedies extends StatelessWidget {
  const SuggestRemedies({Key? key}) : super(key: key);

  // final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(
      builder: (controller) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.remedySuggestedHistoryList.length,
          padding: const EdgeInsets.only(top: 30),
          itemBuilder: (context, index) {
            Widget separator = const SizedBox(height: 20);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                remediesDetail(index,controller.remedySuggestedHistoryList),
                // if (index % 2 == 0 && index != 2)
                //   remediesDetail(
                //       orderId: 785421,
                //       type: "chat".tr,
                //       amount: "+ ₹100000",
                //       details: "with Username(user id) for 8 minutes ",
                //       time: "23 June 23, 02:46 PM"),
                // if (index % 2 == 1)
                //   remediesDetail(
                //       orderId: 785421,
                //       type: "call".tr,
                //       amount: "- ₹100000",
                //       details:
                //       "Policy Violation - Shared Personal Information with User  ",
                //       time: "23 June 23, 02:46 PM"),
                separator,
              ],
            );
          },
        );
      }
    );
  }

  Widget remediesDetail(int index,List<RemedySuggestedDataList> remedySuggestedDataList) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3.0,
                  offset: const Offset(0.3, 3.0)),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assets.images.bgTmpUser.svg(width: 65),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Id : ${remedySuggestedDataList[index].orderId}",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue)),
                        Text("Username",
                            style: AppTextStyle.textStyle20(
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.darkBlue))
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 90,
                    height: 37,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: AppColors.lightGreen, width: 1.0),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Complete",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date Time :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
                Text("09 Mar, 12:40Pm",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Remedy Suggested :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
                Text("Rudrabhishek Puja",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${"clientPaid".tr} :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
                Text("₹1000",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Referral Bonus :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
                Text("30%",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: AppColors.greyColor),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Earning",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w600),
                ),
                Text("₹300",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.lightGreen)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}