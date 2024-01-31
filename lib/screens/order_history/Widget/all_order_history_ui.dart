import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_options_row.dart';
import '../../../common/routes.dart';
import '../../../model/order_history_model/all_order_history.dart';
import '../order_history_controller.dart';

class AllOrderHistoryUi extends StatelessWidget {
  const AllOrderHistoryUi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(
      id: 'allOrders',
        builder: (controller) {
      return ListView.separated(
        // controller: controller,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: controller.allHistoryList.length,
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return orderDetailView(index, controller.allHistoryList);
        },
      );
    });
  }

  Widget orderDetailView(int index, List<AllHistoryData> data) {
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
              children: [
                Text(
                  "${"orderId".tr} : ${data[index].orderId}",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                ),
                const Icon(
                  Icons.help_outline,
                  size: 20,
                  color: AppColors.darkBlue,
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
                          ? AppColors.appRedColour
                          : AppColors.darkBlue*/
                  ),
                ),
                Text(
                  // "$amount",
                  "${data[index].amount}",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: data[index].amount.toString().contains("+")
                          ? AppColors.lightGreen
                          : AppColors.appRedColour),
                )
              ],
            ),
            Text(
              // "with Username(user id) for 8 minutes "
              "with ${data[index].getCustomers?.name}(${data[index].getCustomers?.id}) for ${data[index].duration} minutes",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  // "$time",
                  DateFormat("dd MMM, hh:mm aa").format(data[index].createdAt!),
                  textAlign: TextAlign.end,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CommonOptionRow(
              leftBtnTitle: "FeedBack".tr,
              onLeftTap: () {},
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
