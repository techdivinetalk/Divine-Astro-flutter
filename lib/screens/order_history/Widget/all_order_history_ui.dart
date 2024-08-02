import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/order_history/Widget/empty_widget.dart';
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
  AllOrderHistoryUi({super.key});

  final controller = Get.find<OrderHistoryController>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            onRefresh: () async {
              controller.allPageCount = 1;
              controller.getOrderHistory(
                  type: 0, page: controller.allPageCount);
            },
            backgroundColor: appColors.guideColor,
            color: appColors.white,
            child: GetBuilder<OrderHistoryController>(
                id: 'allOrders',
                builder: (context) {
                  scrollController.addListener(() {
                    if (scrollController.position.maxScrollExtent ==
                        scrollController.position.pixels) {
                      if (!controller.allApiCalling.value) {
                        controller.getOrderHistory(
                            type: 0, page: controller.allPageCount);
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
                          itemCount: controller.allHistoryList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(top: 30, bottom: 20),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return orderDetailView(
                                index, controller.allHistoryList);
                          },
                        ),
                      ),
                      if (controller.allApiCalling.value &&
                          controller.allPageCount > 1)
                        controller.paginationLoadingWidget(),
                    ],
                  );
                })),
        if (controller.allHistoryList.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmptyNew('noDataToShow'.tr),
            ],
          ),
      ],
    );
  }

  Widget orderDetailView(int index, List<AllHistoryData> data) {
    String productTypeText;

    // 1	astrologer_product	products
    // 2	agora_gift	giftings
    // 3	agora_video_call	astrologers
    // 4	agora_audio_call	astrologers
    // 5	agora_anonymous_call	astrologers
    // 7	exotel_audio_call	astrologers
    // 8	meditation	meditations
    // 9	ayurveda_product	ayurveda_products
    // 10	pooja	poojas
    // 11	donation	donations
    // 12	personnel_chat	astrologers
    // 14	ecom custom product	custom_ecom_products
    switch (data[index].productType) {
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

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: appColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            offset: const Offset(0.3, 3.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              openBottomSheet(
                Get.context!,
                functionalityWidget: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: detailView(index, data, Get.context),
                      ),
                    ],
                  ),
                ),
              );
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
                productTypeText,
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                ),
              ),
              data[index].is_po_served.toString() == "1"
                  ? Text(
                      "PO Not Served",
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.black,
                      ),
                    )
                  : Text(
                      "+ ₹${data[index].amount ?? "0"}",
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.lightGreen,
                      ),
                    ),
            ],
          ),
          Text(
            productTypeText == "Gifts"
                ? "with ${data[index].getCustomers?.name}(${data[index].getCustomers?.id})"
                : "with ${data[index].getCustomers?.name}(${data[index].getCustomers?.id}) for ${data[index].duration} minutes",
            textAlign: TextAlign.start,
            style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w400,
              fontColor: appColors.darkBlue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                data[index].createdAt != null
                    ? DateFormat("dd MMM, hh:mm aa")
                        .format(data[index].createdAt!)
                    : "N/A",
                textAlign: TextAlign.end,
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: appColors.darkBlue,
                ),
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
              Get.toNamed(RouteName.suggestRemediesView,
                  arguments: data[index].id);
            },
            rightBtnTitle: "suggestedRemediesEarning".tr,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget detailView(int index, List<AllHistoryData> data, context) {
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                "${data[index].orderId}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
              ),
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
              DateFormat('dd MMM yyyy, hh:mm a')
                  .format(
                      data[index].getCustomers?.dateOfBirth ?? DateTime.now())
                  .toString(),
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Assets.images.icLocation.svg(),
                const SizedBox(width: 15),
                Text(
                  "pob".tr,
                  style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "${data[index].getCustomers?.placeOfBirth ?? 'N/A'}",
                overflow: TextOverflow.visible,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
              ),
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
              "₹${data[index].partnerPrice ?? "${data[index].getGift?.giftPrice ?? "0"}"} ${data[index].getGift == null ? "/min" : ""}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        data[index].productType != 2
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Assets.images.icClock.svg(),
                      const SizedBox(width: 15),
                      Text(
                        "duration".tr,
                        style: AppTextStyle.textStyle14(
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Text(
                    "${data[index].duration ?? "N/a"} mins",
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
                  ),
                ],
              )
            : SizedBox.shrink()
      ],
    );
  }
}
