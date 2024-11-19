import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/order_history/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/build_empty.dart';
import '../../../model/order_history_model/Fine_order_histroy_model.dart';

class FineOrderHistory extends StatelessWidget {
  FineOrderHistory({super.key});

  final controller = Get.find<OrderHistoryController>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            onRefresh: () async {
              controller.finePageCount = 1;
              controller.getOrderHistory(
                  type: 6, page: controller.finePageCount);
            },
            backgroundColor: appColors.guideColor,
            color: appColors.white,
            child: GetBuilder<OrderHistoryController>(builder: (context) {
              scrollController.addListener(() {
                if (scrollController.position.maxScrollExtent ==
                    scrollController.position.pixels) {
                  if (!controller.orderApiCalling.value) {
                    controller.getOrderHistory(
                        type: 6, page: controller.finePageCount);
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
                    itemCount: controller.fineHistoryList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(top: 30, bottom: 20),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return orderDetailView(
                          context, index, controller.fineHistoryList);
                    },
                  )),
                  if (controller.orderFineCalling.value &&
                      controller.finePageCount > 1)
                    controller.paginationLoadingWidget(),
                ],
              );
            })),
        if (controller.fineHistoryList.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmptyNew('noDataToShow'.tr),
            ],
          ),
      ],
    );
  }

  Widget orderDetailView(context, int index, List<FineData> data) {
    String productTypeText = "";
    if (controller.fineHistoryList[index].getOrder == null) {
    } else {
      switch (data[index].getOrder!.productType) {
        case 1:
          productTypeText = 'Astrologer Products';
          break;
        case 2:
          productTypeText = 'Gifts';
          break;
        case 3:
          productTypeText = 'Video Call';
          break;
        case 4:
          productTypeText = 'Audio Call';
          break;
        case 5:
          productTypeText = 'Anonymous Call';
          break;
        case 7:
          productTypeText = 'Audio Call';
          break;
        case 8:
          productTypeText = 'Meditations';
          break;
        case 9:
          productTypeText = 'Ayurveda Products';
          break;
        case 10:
          productTypeText = "Pooja's";
          break;
        case 11:
          productTypeText = 'Donation';
          break;
        case 12:
          productTypeText = 'Customer Chat';
          break;
        case 14:
          productTypeText = 'Ecommerce Product';
          break;
        default:
          productTypeText = 'Unknown';
      }
    }
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
                          "orderId".tr,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          fontColor: appColors.textColor,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          "type".tr,
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
                      CustomText(
                        data[index].getOrder == null
                            ? "N/A"
                            : data[index].getOrder!.orderId == null
                                ? ""
                                : data[index].getOrder!.orderId.toString(),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        fontColor: appColors.textColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        productTypeText == "" ? "N/A" : productTypeText,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        fontColor: appColors.textColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        data[index].getOrder == null
                            ? "N/A"
                            : data[index].getOrder!.createdAt == null
                                ? ""
                                : data[index].getOrder!.createdAt.toString(),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        fontColor: appColors.textColor,
                      ),
                    ],
                  ),
                ],
              ),
              CustomText(
                data[index].amount == null ? "" : "- ₹${data[index].amount}",
                fontSize: 20.sp,
                fontColor: appColors.appRedColour,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
