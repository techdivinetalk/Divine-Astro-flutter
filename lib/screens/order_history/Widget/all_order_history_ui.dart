import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
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
        if (controller.allHistoryList.isEmpty) {
          return const Center(
            child: Text(
              'No data found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.separated(
          // controller: controller,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: controller.allHistoryList.length,
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            return orderDetailView(index, controller.allHistoryList);
          },
        );
      },
    );
  }

  Widget orderDetailView(int index, List<AllHistoryData> data) {
    return Container(
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
          GestureDetector( onTap: () {
            openBottomSheet(Get.context!,
                functionalityWidget: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: detailView(index, data),
                      ),
                    ],
                  ),
                ));
          },

            child: Row(
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
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // "chat".tr,
                data[index].productType != 7 ? 'Chat' : 'Call',
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  /*fontColor: "$type" == "PENALTY"
                          ? appColors.appRedColour
                          : appColors.darkBlue*/
                ),
              ),
              Text(
                // "$amount",
                "+ ₹${data[index].amount}",
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400,
                    fontColor: /*data[index].amount.toString().contains("+")
                          ?*/ appColors.lightGreen
                  /* : appColors.appRedColour*/),
              )
            ],
          ),
          Text(
            // "with Username(user id) for 8 minutes "
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
                // "$time",
                data[index].createdAt != null
                    ? DateFormat("dd MMM, hh:mm aa")
                    .format(data[index].createdAt!)
                    : "N/A",
                textAlign: TextAlign.end,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CommonOptionRow(
            leftBtnTitle: "FeedBack".tr,
            feedbackReviewStatus: data[index].feedbackReviewStatus ?? 0,
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
    );
  }

  Widget detailView(int index, List<AllHistoryData> data) {
    String getGenderText(int? gender) {
      switch (gender) {
        case 0:
          return 'Male';
        case 1:
          return 'Female';
        default:
          return 'Other';
      }
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icOrder.svg(),
                const SizedBox(width: 15),
                Text(
                  "orderId".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "${data[index].orderId}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icUser.svg(),
                const SizedBox(width: 15),
                Text(
                  "name".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "${data[index].getCustomers?.name ?? 'N/A'}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icGender.svg(),
                const SizedBox(width: 15),
                Text(
                  "gender".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              getGenderText(data[index].getCustomers?.gender),
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icCalendar.svg(),
                const SizedBox(width: 15),
                Text(
                  "dob".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "${DateFormat('dd MMM yyyy, hh:mm a').format(data[index].getCustomers?.dateOfBirth ?? DateTime.now())}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icLocation.svg(),
                const SizedBox(width: 15),
                Text(
                  "pob".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "${data[index].getCustomers?.placeOfBirth ?? 'N/A'}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icCalendar.svg(),
                const SizedBox(width: 15),
                Text(
                  "orderDateTime".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "${DateFormat('dd MMM, hh:mma').format(data[index].createdAt ?? DateTime.now())}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icRate.svg(),
                const SizedBox(width: 15),
                Text(
                  "rate".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "₹${data[index].partnerPrice ?? "N/a"}/min",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icClock.svg(),
                const SizedBox(width: 15),
                Text(
                  "duration".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Text(
              "${data[index].duration ?? "N/a"} mins",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}
