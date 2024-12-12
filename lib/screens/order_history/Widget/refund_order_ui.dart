import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/order_history/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/build_empty.dart';
import '../../../model/order_history_model/RefundLogsModel.dart';

class RefundOrderUi extends StatelessWidget {
  RefundOrderUi({super.key});

  final controller = Get.find<OrderHistoryController>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            onRefresh: () async {
              controller.refundLogsPageCount = 1;
              controller.getOrderHistory(
                  type: 7, page: controller.refundLogsPageCount);
            },
            backgroundColor: appColors.guideColor,
            color: appColors.white,
            child: GetBuilder<OrderHistoryController>(builder: (context) {
              scrollController.addListener(() {
                if (scrollController.position.maxScrollExtent ==
                    scrollController.position.pixels) {
                  if (!controller.orderApiCalling.value) {
                    controller.getOrderHistory(
                        type: 7, page: controller.refundLogsPageCount);
                  }
                }
              });
              return Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.refundHistoryList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(top: 30, bottom: 20),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return orderDetailView(
                          context, index, controller.refundHistoryList);
                    },
                  )),
                  if (controller.orderFineCalling.value &&
                      controller.refundLogsPageCount > 1)
                    controller.paginationLoadingWidget(),
                ],
              );
            })),
        if (controller.refundHistoryList.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmptyNew('noDataToShow'.tr),
            ],
          ),
      ],
    );
  }

  Widget orderDetailView(context, int index, List<RefundLogsModelList> data) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appColors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 3.0,
                offset: const Offset(0.3, 3.0)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.17,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Remark".tr,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          fontColor: appColors.textColor,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          "dateTime".tr,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          fontColor: appColors.textColor,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        ":",
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        fontColor: appColors.textColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        ":",
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        fontColor: appColors.textColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: CustomText(
                          data[index].remark == null
                              ? ""
                              : data[index].remark ?? "",
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          fontColor: appColors.textColor,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: CustomText(
                          data[index].createdAt == null
                              ? ""
                              : data[index].createdAt.toString(),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          fontColor: appColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CustomText(
                data[index].rechargeAmount == null
                    ? ""
                    : "+ ₹${data[index].rechargeAmount}",
                fontSize: 18.sp,
                fontColor: appColors.green,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
