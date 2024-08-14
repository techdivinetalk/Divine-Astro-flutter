// ignore_for_file: must_be_immutable

import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/order_history/Widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/order_history_model/remedy_suggested_order_history.dart';
import '../order_history_controller.dart';

class SuggestRemedies extends StatelessWidget {
  SuggestRemedies({super.key});

  final controller = Get.find<OrderHistoryController>();
  final scrollController = ScrollController();

  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            onRefresh: () async {
              controller.remedyPageCount = 1;
              controller.getOrderHistory(
                  type: 4, page: controller.remedyPageCount);
            },
            backgroundColor: appColors.guideColor,
            color: appColors.white,
            child: GetBuilder<OrderHistoryController>(builder: (context) {
              scrollController.addListener(() {
                if (scrollController.position.maxScrollExtent ==
                    scrollController.position.pixels) {
                  if (!controller.suggestApiCalling.value) {
                    controller.getOrderHistory(
                        type: 4, page: controller.remedyPageCount);
                  }
                }
              });
              /*if (controller.remedySuggestedHistoryList.isEmpty) {
                return const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }*/
              return Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.remedySuggestedHistoryList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(top: 30, bottom: 20),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return remediesDetail(
                          index, controller.remedySuggestedHistoryList);
                    },
                  )),
                  if (controller.suggestApiCalling.value &&
                      controller.remedyPageCount > 1)
                    controller.paginationLoadingWidget(),
                ],
              );
            })),
        if (controller.remedySuggestedHistoryList.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmptyNew('noDataToShow'.tr),
            ],
          ),
      ],
    );
  }

  Widget remediesDetail(int index, List<RemedySuggestedDataList> data) {
    print(
        "images ${"${preferenceService.getBaseImageURL()}/${data[index].getCustomers?.avatar}"}");
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
                                url: data[index].getCustomers?.avatar,
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
                                fontColor: appColors.darkBlue)),
                        SizedBox(
                          width: 140,
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
                IntrinsicWidth(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: getStatusColor("${data[index].status}"),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${data[index].status}",
                            style: AppTextStyle.textStyle10(
                              fontWeight: FontWeight.w500,
                              fontColor:
                                  getStatusColor("${data[index].status}"),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 9, vertical: 6),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date Time :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
                Text(
                    /*data[index].createdAt != null
                        ? DateFormat("dd MMM, hh:mm aa")
                            .format(data[index].createdAt!)
                        : "N/A",*/
                    data[index].createdAt != null
                        ? controller
                            .newFormatDateTime(data[index].createdAt.toString())
                        : "N/A",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
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
                          fontColor: appColors.darkBlue)),
                ),
                Expanded(
                  child: Text(
                      data[index].shopId == 0
                          ? "${data[index].poojaDetails?.poojaName}"
                          : "${data[index].productDetails?.prodName}",
                      textAlign: TextAlign.end,
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue,
                      )),
                ),
              ],
            ),
            // const SizedBox(height: 8),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("${"clientPaid".tr} :",
            //         style: AppTextStyle.textStyle12(
            //             fontWeight: FontWeight.w400,
            //             fontColor: appColors.darkBlue)),
            //     Text(
            //         data[index].getOrder?.amount != null &&
            //                 data[index].getOrder?.amount != 0
            //             ? "₹${data[index].getOrder?.amount}"
            //             : "₹0",
            //         style: AppTextStyle.textStyle12(
            //             fontWeight: FontWeight.w400,
            //             fontColor: appColors.darkBlue)),
            //   ],
            // ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Referral Bonus :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
                Text(
                    data[index].shopId == 0
                        ? data[index].poojaDetails?.payoutType == 1
                            ? "${data[index].poojaDetails?.payoutValue}%"
                            : "Rs ${data[index].poojaDetails?.payoutValue}"
                        : data[index].productDetails?.payoutType == 1
                            ? "${data[index].productDetails?.payoutValue}%"
                            : "Rs ${data[index].productDetails?.payoutValue}",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: appColors.greyColor),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Earning",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w600),
                ),
                Text(
                  data[index].shopId == 0
                      ? data[index].status == "completed" &&
                              data[index].poojaDetails!.payoutType == 1
                          ? controller
                              .calculatePercentage(
                                  double.parse(data[index]
                                      .poojaDetails!
                                      .payoutValue
                                      .toString()),
                                  double.parse(data[index]
                                      .poojaDetails!
                                      .pooja_starting_price_inr
                                      .toString()))
                              .toString()
                          : data[index].status == "completed" &&
                                  data[index].poojaDetails!.payoutType == 2
                              ? data[index].poojaDetails!.payoutValue.toString()
                              : "Nil"
                      : data[index].status == "completed" &&
                              data[index].productDetails!.payoutType == 1
                          ? controller
                              .calculatePercentage(
                                  double.parse(data[index]
                                      .productDetails!
                                      .payoutValue
                                      .toString()),
                                  double.parse(data[index]
                                      .productDetails!
                                      .prod_starting_price_inr
                                      .toString()))
                              .toString()
                          : data[index].status == "completed" &&
                                  data[index].productDetails!.payoutType == 2
                              ? data[index]
                                  .productDetails!
                                  .payoutValue
                                  .toString()
                              : "Nil",
                  // data[index].status == "approved" ||
                  //        data[index].status == "completed"
                  //    ? controller
                  //        .calculatePercentage(
                  //          data[index].shopId == 0
                  //              ? double.parse(data[index]
                  //                  .poojaDetails!
                  //                  .payoutValue
                  //                  .toString())
                  //              : double.parse(data[index]
                  //                  .productDetails!
                  //                  .payoutValue
                  //                  .toString()),
                  //          data[index].shopId == 0
                  //              ? double.parse(data[index]
                  //                  .poojaDetails!
                  //                  .pooja_starting_price_inr
                  //                  .toString())
                  //              : double.parse((data[index]
                  //                  .productDetails!
                  //                  .payoutValue
                  //                  .toString())),
                  //        )
                  //        .toString()
                  //    : "Nil",
                  style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w600,
                    fontColor: data[index].status == "approved" ||
                            data[index].status == "completed"
                        ? appColors.lightGreen
                        : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'initiated':
        return appColors.initiateColor;
      case 'pending':
        return appColors.pendingColor;
      case 'completed':
        return appColors.completeColor;
      default:
        return Colors.black;
    }
  }
}
