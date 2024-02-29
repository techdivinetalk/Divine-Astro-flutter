// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/order_history_model/gift_order_history.dart';
import 'package:divine_astrologer/screens/order_history/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../di/shared_preference_service.dart';

class LiveGiftsHistory extends StatelessWidget {
  LiveGiftsHistory({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;
  SharedPreferenceService preferenceService = Get.find<SharedPreferenceService>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHistoryController>(builder: (controller) {
      if (controller.giftHistoryList.isEmpty) {
        return const Center(
          child: Text(
            'No data found',
            style: TextStyle(fontSize: 18),
          ),
        );
      }
      return ListView.separated(
        // controller: controller,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: controller.giftHistoryList.length,
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return orderDetailView(controller.giftHistoryList, index);
          /*return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 2)
                orderDetailView(
                    orderId: 785421,
                    type: "PENALTY",
                    amount: "- ₹100000",
                    details: "Policy Violation - Shared Personal Information with User  ",
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
                    details: "Policy Violation - Shared Personal Information with User  ",
                    time: "23 June 23, 02:46 PM"),
              separator,
            ],
          );*/
        },
      );
    });
  }

  Widget orderDetailView(List<GiftDataList> data, int index) {
    print("giftImage :: ${preferenceService.getBaseImageURL()}/${data[index].getGift?.giftImage ?? ''}");
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: appColors.white, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 3.0, offset: const Offset(0.3, 3.0)),
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
                    data[index].getGift != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 65,
                              width: 65,
                              child: CachedNetworkImage(
                                imageUrl: "${preferenceService.getBaseImageURL()}/${data[index].getGift?.giftImage ?? ''}",
                                errorWidget: (context, s, d) => Assets.images.bgTmpUser.svg(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Assets.images.bgTmpUser.svg(width: 65),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${'orderId'.tr} : ${data[index].orderId}",
                            style: AppTextStyle.textStyle9(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
                        SizedBox(
                          width: 140, // Set a specific width if needed
                          child: CustomText(
                            "${data[index].getCustomers != null ? data[index].getCustomers?.name : "UserName"}",
                            fontWeight: FontWeight.w600,
                            fontColor: appColors.darkBlue,
                            fontSize: 16.sp,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  width: 70,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: appColors.lightGreen, width: 1.0),
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${data[index].status}",
                        style: AppTextStyle.textStyle10(fontWeight: FontWeight.w500, fontColor: appColors.lightGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${'dateTime'.tr} :",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
                Text(
                  data[index].createdAt != null
                      ? DateFormat("dd MMM, hh:mm aa")
                      .format(data[index].createdAt!)
                      : "N/A",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${'giftName'.tr} :",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
                Text("${data[index].getGift?.giftName}",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${'giftPrice'.tr} :",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
                Text("₹${data[index].getGift?.giftPrice}",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${'quantity'.tr} :",
                    style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
                Text("${data[index].quantity}", style: AppTextStyle.textStyle12(fontWeight: FontWeight.w400, fontColor: appColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: appColors.greyColor),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "totalEarning".tr,
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w600),
                ),
                Text("₹${data[index].amount}", style: AppTextStyle.textStyle12(fontWeight: FontWeight.w600, fontColor: appColors.lightGreen)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    /*return InkWell(
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
                  "${"orderId".tr} : $orderId",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                ),
                const Icon(
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
                  "$type",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor:
                          "$type" == "PENALTY" ? appColors.appRedColour : appColors.darkBlue),
                ),
                Text(
                  "$amount",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor:
                          amount!.contains("+") ? appColors.lightGreen : appColors.appRedColour),
                )
              ],
            ),
            Text(
              "$details ",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$time",
                  textAlign: TextAlign.end,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
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
    );*/


    String _truncateText(String text, int maxWords) {
      if (text.split(' ').length <= maxWords) {
        return text;
      } else {
        List<String> words = text.split(' ');
        return '${words.take(maxWords).join(' ')}...';
      }
    }
  }
}
