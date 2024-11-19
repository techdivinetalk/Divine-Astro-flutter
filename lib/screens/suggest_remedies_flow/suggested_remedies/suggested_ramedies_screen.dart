import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_astrologer_response.dart';
import 'package:divine_astrologer/model/order_history_model/remedy_suggested_order_history.dart';
import 'package:divine_astrologer/screens/suggest_remedies_flow/suggested_remedies/suggested_remedies_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/build_empty.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';

class SuggestedRemediesScreen extends StatelessWidget {
  SuggestedRemediesScreen({super.key});

  final controller = Get.put(SuggestedRemediesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        backgroundColor: appColors.white,
        title: Text("suggestedRemedies".tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: appColors.darkBlue,
            )),
      ),
      body: Obx(() =>
          controller.suggestApiCalling.value && controller.remedyPageCount == 1
              ? const GenericLoadingWidget()
              : suggestRemedies()),
      // bottomNavigationBar: SizedBox(
      //   height: 70,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 8),
      //         child: Container(
      //           height: 50,
      //           width: MediaQuery.of(context).size.width * 0.9,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(14),
      //             color: appColors.guideColor,
      //           ),
      //           child: Center(
      //             child: Text(
      //               "My Remedies Listing",
      //               style: TextStyle(
      //                 fontSize: 16.sp,
      //                 fontWeight: FontWeight.w600,
      //                 fontFamily: FontFamily.poppins,
      //                 color: appColors.white,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget suggestRemedies() {
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
            child: GetBuilder<SuggestedRemediesController>(builder: (context) {
              controller.scrollController.addListener(() {
                if (controller.scrollController.position.maxScrollExtent ==
                    controller.scrollController.position.pixels) {
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
                    controller: controller.scrollController,
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

  String formatDateTime(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    DateFormat formatter = DateFormat('dd MMM yy, hh:mm a');
    return formatter.format(dateTime);
  }

  Widget remediesDetail(int index, List<RemedySuggestedDataList> data) {
    print("create at  ${data[index].createdAt}");
    return InkWell(
      onTap: () {
        DataList dataList = DataList();
        dataList.name = data[index].getCustomers!.name;
        dataList.id = data[index].getCustomers!.id;
        dataList.image = data[index].getCustomers!.avatar;
        Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
      },
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
                        Text("${"orderId".tr} : ${data[index].orderId}",
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
                Text("${"dateTime".tr} :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
                Text(
                    /*data[index].createdAt != null
                        ? DateFormat("dd MMM, hh:mm aa")
                            .format(data[index].createdAt!)
                        : "N/A"*/
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
                  child: Text("${"remedySuggested".tr} :",
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
            const SizedBox(height: 8),
            Text("click_to_connect_with_user".tr,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400,
                    fontColor: appColors.guideColor))
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${"clientPaid".tr} :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
                Text( data[index].getOrder?.amount != null &&
                    data[index].getOrder?.amount != 0
                    ? "₹${data[index].getOrder?.amount}"
                    : "₹0",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Referral Bonus :",
                    style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.darkBlue)),
                Text("${data[index].productDetails?.payoutType}%",
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
                  data[index].getOrder?.amount != null &&
                      data[index].getOrder?.amount != 0
                      ? "₹${data[index].getOrder?.amount}"
                      : "₹0",
                  style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w600,
                    fontColor: data[index].getOrder?.amount != null &&
                        data[index].getOrder?.amount != 0
                        ? appColors.lightGreen
                        : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),*/
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

  Widget suggestedRemedies() {
    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: appColors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 8, bottom: 2),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 15,
          //       ),
          //       Text(
          //         "Repeat",
          //         style: TextStyle(
          //           fontSize: 16.sp,
          //           fontFamily: FontFamily.poppins,
          //           fontWeight: FontWeight.w400,
          //           color: appColors.red,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       SizedBox(
          //         height: 20,
          //         child: VerticalDivider(
          //           color: appColors.grey.withOpacity(0.4),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Text(
          //         "fjdfdjfkdjfjfd",
          //         style: TextStyle(
          //           fontSize: 16.sp,
          //           fontFamily: FontFamily.poppins,
          //           fontWeight: FontWeight.w400,
          //           color: Color.fromRGBO(252, 183, 66, 1),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, right: 8),
          //   child: Divider(
          //     color: appColors.grey.withOpacity(0.4),
          //   ),
          // ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: CachedNetworkPhoto(
                    url: "fjdfdjfkdjfjfd",
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "fjdfdjfkdjfjfd",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.poppins,
                          color: appColors.black,
                        ),
                      ),
                      // if (waitingCustomer.level != null &&
                      //     waitingCustomer.level != "")
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: LevelWidget(level: "1" ?? ""),
                      ),
                    ],
                  ),
                  Text(
                    "01 Aug 24, 05:01 PM",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.poppins,
                      color: appColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.18,
                        child: Text(
                          "Order Id",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.poppins,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.01,
                        child: Text(
                          ":",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.poppins,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.22,
                        child: Text(
                          "fjdfdjfkdjfjfd",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: FontFamily.poppins,
                            color: appColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.18,
                        child: Text(
                          "Product Name",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.poppins,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.01,
                        child: Text(
                          ":",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.poppins,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.22,
                        child: Text(
                          "Job Healing",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: FontFamily.poppins,
                            color: appColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.18,
                        child: Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.poppins,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.01,
                        child: Text(
                          ":",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.poppins,
                            color: appColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width * 0.22,
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: FontFamily.poppins,
                            color: appColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                    child: Container(
                        height: 38.sp,
                        width: MediaQuery.of(Get.context!).size.width * 0.4.sp,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: appColors.red,
                            )),
                        child: Center(
                          child: Text(
                            "Chat with us",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: FontFamily.poppins,
                              color: appColors.red,
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                          height: 38.sp,
                          width:
                              MediaQuery.of(Get.context!).size.width * 0.4.sp,
                          decoration: BoxDecoration(
                            color: appColors.red,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: appColors.red,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Request to close",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: FontFamily.poppins,
                                color: appColors.white,
                              ),
                            ),
                          )),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: Container(
                  //         height: 38,
                  //         width: MediaQuery.of(context).size.width * 0.4,
                  //         decoration: BoxDecoration(
                  //           color: appColors.grey.withOpacity(0.5),
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(
                  //             color: appColors.grey.withOpacity(0.5),
                  //           ),
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             "Requested to close",
                  //             style: TextStyle(
                  //               fontSize: 14.sp,
                  //               fontWeight: FontWeight.w400,
                  //               fontFamily: FontFamily.poppins,
                  //               color: appColors.white,
                  //             ),
                  //           ),
                  //         )),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// new design
/*
Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        data[index].poojaDetails != null ? data[index].poojaDetails?.poojaName ?? ""
                        : data[index].productDetails?.prodName ?? "",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontColor: appColors.guideColor,
                        maxLines: 2,
                      ),
                      4.verticalSpace,
                      CustomText(
                        "Category - ",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.textColor,
                      ),
                      4.verticalSpace,
                      CustomText(
                        "Name - ${data[index].getCustomers?.name} (Id : ${data[index].getCustomers?.id})",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.textColor,
                      ),
                      4.verticalSpace,
                      CustomText(
                        "Date & Time - ${formatDateTime(data[index].createdAt.toString())}",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.textColor,
                      ),
                      4.verticalSpace,
                      CustomText(
                        "Price - ${data[index].poojaDetails != null ? data[index].poojaDetails?.pooja_starting_price_inr
                        : data[index].productDetails?.prod_starting_price_inr}",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.textColor,
                      ),
                      4.verticalSpace,
                      CustomText(
                        "Type - ",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontColor: appColors.textColor,
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          CustomText(
                            "Status - ",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.textColor,
                          ),
                          CustomText(
                            data[index].status ?? "",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            fontColor: data[index].status?.toLowerCase() == "booked" ? appColors.green
                            : appColors.textColor,
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          CustomText(
                            "Description - ",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.textColor,
                          ),
                          CustomText(
                            "123",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            fontColor: appColors.darkBlue1.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                5.horizontalSpace,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 96.0,
                      width: 96.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          "${preferenceService.getAmazonUrl()}/${data[index].poojaDetails != null ? data[index].poojaDetails?.pooja_img ?? "" : data[index].productDetails?.prodImage ?? ""}",
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              color: Colors.red.withOpacity(0.5),
                              size: 50.0,
                            );
                          },
                        ),
                      ),
                    ),
                    45.verticalSpace,
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteName.remediesView),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: appColors.guideColor,
                        ),
                        child: const CustomText(
                            "Suggest Next Remedy",
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
 */
