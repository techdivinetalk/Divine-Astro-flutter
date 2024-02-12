import 'package:divine_astrologer/model/order_history_model/call_order_history.dart';
import 'package:divine_astrologer/screens/order_history/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_options_row.dart';
import '../../../common/routes.dart';

class CallOrderHistory extends StatelessWidget {
  const CallOrderHistory({super.key, this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(builder: (controller) {
      return ListView.separated(
        // controller: controller,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: controller.callHistoryList.length,
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return orderDetailView(index, controller.callHistoryList);
          /*return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 2)
                  orderDetailView(
                      orderId: 785421,
                      type: "PENALTY",
                      amount: "- ₹100000",
                      details:
                          "Policy Violation - Shared Personal Information with User  ",
                      time: "23 June 23, 02:46 PM"),
                if (index % 2 == 0 && index != 2)
                  orderDetailView(
                      orderId: 785421,
                      type: "chat".tr,
                      amount: "+ ₹100000",
                      details: "with Username(user id) for 8 minutes ",
                      time: "23 June 23, 02:46 PM"),
                if (index % 2 == 1)
                  orderDetailView(
                      orderId: 785421,
                      type: "call".tr,
                      amount: "- ₹100000",
                      details:
                          "Policy Violation - Shared Personal Information with User  ",
                      time: "23 June 23, 02:46 PM"),
                separator,
              ],
            );*/
        },
      );
    });
  }

  Widget orderDetailView(int index, List<CallHistoryData> data) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: appColors.white,
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
              children: [
                Text(
                  "${"orderId".tr} : ${data[index].orderId}",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                ),
                 Icon(
                  Icons.help_outline,
                  size: 20,
                  color: appColors.darkBlue,
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // "chat".tr,
                  "${data[index].productType}",
                  style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400,
                    /*fontColor: "$type" == "PENALTY"
                          ? appColors.appRedColour
                          : appColors.darkBlue*/
                  ),
                ),
                Text(
                  // "- ₹100000",
                  "${data[index].amount}",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: data[index].amount.toString().contains("+")
                          ? appColors.lightGreen
                          : appColors.appRedColour),
                )
              ],
            ),
            Text(
              // "with Username(user id) for 8 minutes ",
              "with ${data[index].getCustomers?.name}(${data[index].getCustomers?.id}) for ${data[index].duration} minutes",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat("dd MMM, hh:mm aa").format(data[index].createdAt!),
                  textAlign: TextAlign.end,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: appColors.darkBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CommonOptionRow(
              leftBtnTitle: "FeedBack".tr,
              onLeftTap: () {
                Get.toNamed(RouteName.feedback, arguments: {
                  'order_id': data[index].id,
                  'product_type': data[index].productType,
                });
              },
              onRightTap: () {
                Get.toNamed(RouteName.suggestRemediesView, arguments: data[index].id);
              },
              rightBtnTitle: "suggestedRemediesEarning".tr,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
