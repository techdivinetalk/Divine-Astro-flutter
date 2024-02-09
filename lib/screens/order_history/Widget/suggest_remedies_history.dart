// ignore_for_file: must_be_immutable

import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/order_history_model/remedy_suggested_order_history.dart';
import '../order_history_controller.dart';

class SuggestRemedies extends StatelessWidget {
  SuggestRemedies({Key? key}) : super(key: key);

  // final ScrollController? controller;

  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(builder: (controller) {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: controller.remedySuggestedHistoryList.length,
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return remediesDetail(index, controller.remedySuggestedHistoryList);
        },
      );
    });
  }

  Widget remediesDetail(int index, List<RemedySuggestedDataList> data) {
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
                    data[index].getCustomers != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 65,
                              width: 65,
                              child: CachedNetworkPhoto(
                                url:
                                    "${preferenceService.getBaseImageURL()}/${data[index].getCustomers!.avatar!}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Assets.images.bgTmpUser.svg(width: 65),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Id : ${data[index].orderId}",
                            style: AppTextStyle.textStyle12(
                                fontWeight: FontWeight.w400,
                                fontColor: AppColors.darkBlue)),
                        Text(
                            "${data[index].getCustomers != null ? data[index].getCustomers!.name : "Username"}",
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
                          "${data[index].status}",
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date Time :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
                Text(
                    DateFormat("dd MMM, hh:mm aa")
                        .format(data[index].createdAt!),
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text("Remedy Suggested :",
                      style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                ),
                Expanded(
                  child: Text("${data[index].productDetails?.prodName}",
                      textAlign: TextAlign.end,
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: AppColors.darkBlue,
                      )),
                ),
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
                Text("₹${data[index].getOrder?.amount}",
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
