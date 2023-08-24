import 'package:divine_astrologer/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../repository/shop_repository.dart';
import 'all_option_controller.dart';

class AllTabInfo extends GetView<AllOptionController> {
  const AllTabInfo({Key? key}) : super(key: key);

  // final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    Get.put(AllOptionController(Get.put(ShopRepository())));
    return Obx(() => controller.allOrderHistorySync.value
        ? ListView.builder(
            controller: controller.orderScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: controller.orderHistoryData?.length ?? 0,
            padding: const EdgeInsets.only(top: 30),
            itemBuilder: (context, index) {
              Widget separator = const SizedBox(height: 20);
              var orderDetails = controller.orderHistoryData?[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  orderDetailView(
                      orderId: orderDetails?.orderId ?? 0,
                      type: orderDetails?.productName,
                      amount: "${orderDetails?.amount ?? ""}",
                      details: orderDetails?.status,
                      time: orderDetails?.dateTime,
                      customerId: "${orderDetails?.customerId}",
                      customerName: orderDetails?.customerName,
                      duration: orderDetails?.duration,
                      index: index),
                  separator,
                ],
              );
            },
          )
        : const SizedBox());
  }

  Widget orderDetailView({
    required int orderId,
    required String? type,
    required String? amount,
    required String? details,
    required String? time,
    required String? customerId,
    required String? customerName,
    required String? duration,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        controller.showDetails(index: index);
      },
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
                  "+ $amount",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.lightGreen),
                )
              ],
            ),
            Text(
              "with $customerName ($customerId) for ${controller.getDuration(duration: duration!)}",
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
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.suggestRemediesView, arguments: orderId);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 172,
                    height: 37,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1.0,
                            offset: const Offset(0.0, 3.0)),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.appYellowColour,
                          AppColors.gradientBottom
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Center(
                      child: Text(
                        "suggestRemedies".tr,
                        style: AppTextStyle.textStyle14(
                            fontColor: AppColors.brownColour,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
