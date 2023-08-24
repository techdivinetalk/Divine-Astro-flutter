import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_options_row.dart';
import '../../../common/routes.dart';

class CallOrderHistory extends StatelessWidget {
  const CallOrderHistory({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 7,
      padding: EdgeInsets.only(top: 30),
      itemBuilder: (context, index) {
        Widget separator = const SizedBox(height: 20);
        return Column(
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
        );
      },
    );
  }

  Widget orderDetailView(
      {required int orderId,
      required String? type,
      required String? amount,
      required String? details,
      required String? time}) {
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
                  "${"orderId".tr} : $orderId",
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
                  "$type",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: "$type" == "PENALTY"
                          ? AppColors.appRedColour
                          : AppColors.darkBlue),
                ),
                Text(
                  "$amount",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: amount!.contains("+")
                          ? AppColors.lightGreen
                          : AppColors.appRedColour),
                )
              ],
            ),
            Text(
              "$details ",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$time",
                  textAlign: TextAlign.end,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.darkBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CommonOptionRow(
              leftBtnTitle: "refund".tr,
              onLeftTap: () {},
              onRightTap: () {
                Get.toNamed(RouteName.categoryDetail);
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
