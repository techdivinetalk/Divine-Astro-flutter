import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/wallet/wallet_model.dart';
import 'package:divine_astrologer/pages/wallet/wallet_controller.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../common/date_picker/date_picker_widget.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.isDropDownShow.value = false;
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: appColors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 50,
        iconTheme: IconThemeData(color: appColors.blackColor),
        titleSpacing: 0,
        leading: IconButton(
          highlightColor: appColors.transparent,
          splashColor: appColors.transparent,
          onPressed: () {
            if (controller.isOrderHistoryBack) {
              Get.offNamed(RouteName.orderHistory);
            } else {
              Get.back();
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "wallet".tr,
          style: AppTextStyle.textStyle16(
            fontWeight: FontWeight.w400,
            fontColor: appColors.darkBlue,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.offNamed(RouteName.orderHistory),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Assets.images.icOrderHistory.svg(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              /*balanceView()*/
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              //   child: Container(
              //     // height: 40,
              //     padding: EdgeInsets.all(8.h),
              //     decoration: BoxDecoration(
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.black.withOpacity(0.2),
              //             blurRadius: 3.0,
              //             offset: const Offset(0.0, 3.0)),
              //       ],
              //       color: appColors.white,
              //       borderRadius: const BorderRadius.all(Radius.circular(10)),
              //     ),
              //     child: GetBuilder<WalletController>(builder: (controller) {
              //       return Obx(
              //         () => DropdownButtonHideUnderline(
              //           child: DropdownButton2<String>(
              //             isDense: true,
              //             isExpanded: true,
              //             hint: Text(
              //               "select".tr,
              //               style: AppTextStyle.textStyle16(
              //                   fontWeight: FontWeight.w400,
              //                   fontColor: appColors.darkBlue),
              //             ),
              //             items: controller.durationOptions
              //                 .map((String item) => DropdownMenuItem<String>(
              //                       value: item,
              //                       child: Padding(
              //                         padding: const EdgeInsets.only(left: 20),
              //                         child: Text(
              //                           item.tr,
              //                           style: AppTextStyle.textStyle16(
              //                               fontWeight: FontWeight.w400,
              //                               fontColor: appColors.darkBlue),
              //                           overflow: TextOverflow.ellipsis,
              //                         ),
              //                       ),
              //                     ))
              //                 .toList(),
              //             style: AppTextStyle.textStyle16(
              //                 fontWeight: FontWeight.w400,
              //                 fontColor: appColors.darkBlue),
              //             value: controller.selectedOption.value,
              //             onChanged: (String? value) {
              //               if (value == "Select Custom") {
              //                 controller.updateDurationValue(value!);
              //                 showCupertinoModalPopup(
              //                   context: Get.context!,
              //                   barrierColor: appColors.darkBlue.withOpacity(0.5),
              //                   builder: (context) => SelectDateTypesWidget(),
              //                 );
              //               } else {
              //                 controller.updateDurationValue(value!);
              //               }
              //             },
              //             iconStyleData: IconStyleData(
              //               icon: const Icon(
              //                 Icons.keyboard_arrow_down,
              //               ),
              //               iconSize: 35,
              //               iconEnabledColor: appColors.blackColor,
              //             ),
              //             dropdownStyleData: DropdownStyleData(
              //               width: ScreenUtil().screenWidth * 0.95,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(14),
              //                 color: appColors.white,
              //               ),
              //               offset: const Offset(-10, -17),
              //               scrollbarTheme: ScrollbarThemeData(
              //                 radius: const Radius.circular(40),
              //                 thickness: MaterialStateProperty.all<double>(6),
              //                 thumbVisibility:
              //                     MaterialStateProperty.all<bool>(false),
              //               ),
              //             ),
              //             menuItemStyleData: const MenuItemStyleData(
              //               height: 40,
              //               padding: EdgeInsets.only(left: 14, right: 14),
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
              //   ),
              // ),
              // Obx(() {
              //   return GestureDetector(
              //     onTap: () {
              //       controller.isDropDownShow.value =
              //           !controller.isDropDownShow.value;
              //     },
              //     child: Container(
              //       margin: EdgeInsets.symmetric(
              //         horizontal: 20,
              //       ),
              //       height: 40,
              //       width: Get.width,
              //       decoration: BoxDecoration(
              //         color: appColors.white,
              //         borderRadius: BorderRadius.circular(10),
              //         boxShadow: [
              //           BoxShadow(
              //             color: appColors.darkBlue.withOpacity(0.2),
              //             blurRadius: 5,
              //             offset: const Offset(0, 3),
              //           ),
              //         ],
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16),
              //         child: Row(
              //           children: [
              //             Text(
              //               controller.dropDownValue.value,
              //               style: TextStyle(
              //                 fontFamily: 'Poppins',
              //                 color: appColors.black,
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //             const Spacer(),
              //             SvgPicture.asset(
              //               Assets.images.icDownArrow.path,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   );
              // }),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 65.w,
                      child: Column(
                        children: [
                          Text(
                            '${"availableBalance".tr} :',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${controller.walletListRepo.value.data?.totalAmountEarned.amountEarned ?? 0}',
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: Column(
                        children: [
                          Text(
                            '${"pgCharges".tr} :',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${controller.walletListRepo.value.data?.productRevenue.amount ?? 0}',
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 65.w,
                      child: Column(
                        children: [
                          Text(
                            '${"subTotal".tr} :',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${controller.walletListRepo.value.data?.weeklyOrder.count ?? 0}',
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 65.w,
                      child: Column(
                        children: [
                          Text(
                            '${"product_sold".tr} :',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${controller.walletListRepo.value.data?.productSold.count ?? 0}',
                            style: AppTextStyle.textStyle12(
                                fontColor: appColors.darkBlue,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: 60.w,
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'TDS:',
                    //         textAlign: TextAlign.center,
                    //         maxLines: 2,
                    //         style: AppTextStyle.textStyle12(
                    //             fontColor: appColors.darkBlue,
                    //             fontWeight: FontWeight.w400),
                    //       ),
                    //       const SizedBox(height: 10),
                    //       Text(
                    //         '₹${controller.walletListRepo.value.data?.productSold.count ?? 0}',
                    //         style: AppTextStyle.textStyle12(
                    //             fontColor: appColors.darkBlue,
                    //             fontWeight: FontWeight.w400),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      width: 65.w,
                      child: Column(
                        children: [
                          Text(
                            '${"totalAmount".tr} :',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${controller.walletListRepo.value.data?.totalAmountEarned.amountEarned ?? 0}',
                            style: AppTextStyle.textStyle12(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).scrollHorizontal();
              }),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: 1.h, color: appColors.darkBlue.withOpacity(0.5)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.loadNextPage();
                    }
                    return true;
                  },
                  child: Obx(
                    () {
                      final paymentLogList =
                          controller.walletListRepo.value.data?.paymentLog;
                      if (controller.loading == Loading.loading) {
                        return const GenericLoadingWidget();
                      } else if (paymentLogList != null &&
                          paymentLogList.isNotEmpty) {
                        return ListView.separated(
                          physics: const ScrollPhysics(),
                          itemCount: paymentLogList.length + 1,
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(bottom: 20),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            if (index <
                                controller.walletListRepo.value.data!.paymentLog
                                    .length) {
                              final log = controller
                                  .walletListRepo.value.data?.paymentLog[index];

                              return PaymentLogTile(log: log!);
                            } else {
                              return Text(
                                "Load More",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: appColors.guideColor,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          // Obx(() => controller.isDropDownShow.value
          //     ? Positioned(
          //         top: 50,
          //         child: WalletDropDownItems(),
          //       )
          //     : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget SelectDateTypesWidget() {
    return Material(
      color: appColors.transparent,
      child: GetBuilder<WalletController>(builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: appColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30.0)),
                color: appColors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, bottom: 20, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select Custom Date",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: Get.context!,
                              builder: (context) {
                                return selectDateWid(
                                  name: "Start Date",
                                  looping: true,
                                  buttonTitle: "Confirm",
                                  initialDate: DateTime.now(),
                                  onConfirm: (String value) {
                                    controller.setStartDate(value);
                                  },
                                  onChange: (String value) {
                                    controller.setStartDate(value);
                                  },
                                );
                              });
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(Get.context!).width * 0.44,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                              color: appColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.startDate == null
                                    ? Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                        color: appColors.grey.withOpacity(0.8),
                                      )
                                    : SizedBox(),
                                controller.startDate == null
                                    ? SizedBox(
                                        width: 5,
                                      )
                                    : SizedBox(),
                                Text(
                                  controller.startDate == null
                                      ? "Start Date"
                                      : "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: controller.startDate == null
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    color: controller.startDate == null
                                        ? appColors.grey.withOpacity(0.8)
                                        : appColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: Get.context!,
                              builder: (context) {
                                return selectDateWid(
                                  name: "End Date",
                                  looping: true,
                                  buttonTitle: "Confirm",
                                  initialDate: DateTime.now(),
                                  onConfirm: (String value) {
                                    controller.setEndDate(value);
                                  },
                                  onChange: (String value) {
                                    controller.setEndDate(value);
                                  },
                                );
                              });
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(Get.context!).width * 0.44,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                              color: appColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.endDate == null
                                    ? Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                        color: appColors.grey.withOpacity(0.8),
                                      )
                                    : SizedBox(),
                                controller.endDate == null
                                    ? SizedBox(
                                        width: 5,
                                      )
                                    : SizedBox(),
                                Text(
                                  controller.endDate == null
                                      ? "End Date"
                                      : "${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: controller.endDate == null
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    color: controller.endDate == null
                                        ? appColors.grey.withOpacity(0.8)
                                        : appColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  controller.startDate == null || controller.endDate == null
                      ? SizedBox(height: 20)
                      : Column(
                          children: [
                            SizedBox(height: 20),
                            MaterialButton(
                              height: 50,
                              highlightElevation: 0,
                              elevation: 0.0,
                              minWidth:
                                  MediaQuery.sizeOf(Get.context!).width * 0.92,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                controller.startSelectedDate =
                                    controller.startDate;
                                controller.endSelectedDate = controller.endDate;
                                controller.durationOptions.add(
                                    "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year} to ${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}");
                                controller.selectedOption.value =
                                    "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year} to ${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}";

                                Get.back();
                              },
                              color: appColors.guideColor,
                              child: Text(
                                "Confirm Dates",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: appColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class WalletDropDownItems extends StatelessWidget {
  List<String> items = ['Today', 'Last Week', 'Last Month', 'Select Custom'];

  WalletDropDownItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      width: Get.width - 40,
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: appColors.darkBlue.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: items.map((e) {
            return GestureDetector(
              onTap: () {
                if (e == 'Select Custom') {
                  Get.find<WalletController>().dropDownValue.value = e;

                  Get.find<WalletController>().isDropDownShow.value = false;

                  showCupertinoModalPopup(
                    context: Get.context!,
                    barrierColor: appColors.darkBlue.withOpacity(0.5),
                    builder: (context) => SelectDateTypesWidget(),
                  );
                  Get.find<WalletController>().isDropDownShow.value = false;
                  return;
                }
                Get.find<WalletController>().dropDownValue.value = e;
                Get.find<WalletController>().isDropDownShow.value = false;
              },
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      e,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: appColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget SelectDateTypesWidget() {
    return Material(
      color: appColors.transparent,
      child: GetBuilder<WalletController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: appColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30.0)),
                color: appColors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, bottom: 20, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select Custom Date",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: Get.context!,
                              builder: (context) {
                                return selectDateWid(
                                  name: "Start Date",
                                  looping: true,
                                  buttonTitle: "Confirm",
                                  initialDate: DateTime.now(),
                                  onConfirm: (String value) {
                                    controller.setStartDate(value);
                                  },
                                  onChange: (String value) {
                                    controller.setStartDate(value);
                                  },
                                );
                              });
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(Get.context!).width * 0.44,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                              color: appColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.startDate == null
                                    ? Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                        color: appColors.grey.withOpacity(0.8),
                                      )
                                    : SizedBox(),
                                controller.startDate == null
                                    ? SizedBox(
                                        width: 5,
                                      )
                                    : SizedBox(),
                                Text(
                                  controller.startDate == null
                                      ? "Start Date"
                                      : "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: controller.startDate == null
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    color: controller.startDate == null
                                        ? appColors.grey.withOpacity(0.8)
                                        : appColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: Get.context!,
                              builder: (context) {
                                return selectDateWid(
                                  name: "End Date",
                                  looping: true,
                                  buttonTitle: "Confirm",
                                  initialDate: DateTime.now(),
                                  onConfirm: (String value) {
                                    controller.setEndDate(value);
                                  },
                                  onChange: (String value) {
                                    controller.setEndDate(value);
                                  },
                                );
                              });
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(Get.context!).width * 0.44,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                              color: appColors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.endDate == null
                                    ? Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                        color: appColors.grey.withOpacity(0.8),
                                      )
                                    : SizedBox(),
                                controller.endDate == null
                                    ? SizedBox(
                                        width: 5,
                                      )
                                    : SizedBox(),
                                Text(
                                  controller.endDate == null
                                      ? "End Date"
                                      : "${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: controller.endDate == null
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    color: controller.endDate == null
                                        ? appColors.grey.withOpacity(0.8)
                                        : appColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  controller.startDate == null || controller.endDate == null
                      ? SizedBox(height: 20)
                      : Column(
                          children: [
                            SizedBox(height: 20),
                            MaterialButton(
                              height: 50,
                              highlightElevation: 0,
                              elevation: 0.0,
                              minWidth:
                                  MediaQuery.sizeOf(Get.context!).width * 0.92,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                controller.startSelectedDate =
                                    controller.startDate;
                                controller.endSelectedDate = controller.endDate;
                                controller.durationOptions.add(
                                    "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year} to ${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}");
                                controller.selectedOption.value =
                                    "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year} to ${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}";
                                Get.find<WalletController>()
                                        .dropDownValue
                                        .value =
                                    "${DateTime.parse(controller.startDate).day}-${DateTime.parse(controller.startDate).month}-${DateTime.parse(controller.startDate).year} to ${DateTime.parse(controller.endDate).day}-${DateTime.parse(controller.endDate).month}-${DateTime.parse(controller.endDate).year}";

                                Get.back();
                              },
                              color: appColors.guideColor,
                              child: Text(
                                "Confirm Dates",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: appColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class PaymentLogTile extends StatelessWidget {
  final PaymentLog log;

  const PaymentLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    /* String productTypeText;

    switch (log.productType) {
      case 7:
        productTypeText = 'Chat';
        break;
      case 12:
        productTypeText = 'Call';
        break;
      case 2:
        productTypeText = 'Gifts';
        break;
      case 3:
        productTypeText = 'Remedy Suggested';
        break;
      default:
        productTypeText = 'Unknown';
    }*/

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
          GestureDetector(
            onTap: () {
              openBottomSheet(Get.context!,
                  functionalityWidget: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: detailView(log, context),
                        ),
                      ],
                    ),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"orderId".tr} : ${log.orderId.toString()}",
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
                log.payoutFor ?? "Na",
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  /*fontColor: "$type" == "PENALTY"
                          ? appColors.appRedColour
                          : appColors.darkBlue*/
                ),
              ),
              Text(
                "+ ₹${log.actualPayments.toString()}",
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400,
                    fontColor: /*data[index].amount.toString().contains("+")
                          ?*/
                        appColors.lightGreen /*: appColors.appRedColour*/),
              )
            ],
          ),
          Text(
            // "with Username(user id) for 8 minutes "
            log.payoutFor == "gift"
                ? "with ${log.customerDetails?.name}(${log.customerDetails?.id.toString()})"
                : "with ${log.customerDetails?.name}(${log.customerDetails?.id.toString()}) for ${log.callDuration.toString()} minutes",
            // "with ${log.customerDetails?.name}(${log.customerDetails?.id.toString()}) for ${log.callDuration.toString()} minutes",
            textAlign: TextAlign.start,
            style: AppTextStyle.textStyle12(
                fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                log.date != null ? log.date! : "N/A",
                textAlign: TextAlign.end,
                style: AppTextStyle.textStyle12(
                    fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
              ),
            ],
          ),
          const SizedBox(height: 20),
          /*CommonOptionRow(
            feedbackReviewStatus: data[index].feedbackReviewStatus ?? 0,
            leftBtnTitle: "FeedBack".tr,
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
          ),*/
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Container(
          //     width: 135,
          //     decoration: BoxDecoration(
          //       color: appColors.white,
          //       border: Border.all(
          //         color: appColors.appRedColour,
          //       ),
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     child: Padding(
          //       padding:
          //           EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             "Feedback",
          //             textAlign: TextAlign.end,
          //             style: AppTextStyle.textStyle13(
          //                 fontWeight: FontWeight.w500,
          //                 fontColor: appColors.appRedColour),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Container(
          //             decoration: BoxDecoration(
          //               color: appColors.appRedColour,
          //               border: Border.all(color: appColors.white),
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Padding(
          //               padding: EdgeInsets.only(left: 10, right: 10),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     "New",
          //                     textAlign: TextAlign.end,
          //                     style: AppTextStyle.textStyle10(
          //                         fontWeight: FontWeight.w500,
          //                         fontColor: appColors.white),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget detailView(PaymentLog log, context) {
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
              "${log.orderId}",
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
              log.customerDetails?.name ?? 'N/A',
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
              getGenderText(log.customerDetails?.gender),
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
                  .format(log.customerDetails!.dateOfBirth ?? DateTime.now())
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
                "${log.customerDetails?.placeOfBirth ?? 'N/A'}",
                overflow: TextOverflow.fade,
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
              log.date != null ? log.date! : "N/A",
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
              "₹${log.partnerPrice ?? "N/a"} ${log.payoutFor == "gift" ? "" : "/min"}",
              style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 10),
        log.payoutFor != 'gift'
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
                    "${log.callDuration ?? "N/a"} mins",
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

class selectDateWid extends StatelessWidget {
  const selectDateWid(
      {Key? key,
      required this.initialDate,
      required this.looping,
      required this.onConfirm,
      required this.onChange,
      required this.buttonTitle,
      required this.name})
      : super(key: key);

  final String buttonTitle;
  final DateTime? initialDate;
  final bool looping;
  final Function(String) onConfirm, onChange;
  final String name;

  @override
  Widget build(BuildContext context) {
    String pickerStartData = "";
    String pickerEndData = "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: appColors.white),
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              color: appColors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            color: appColors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_sharp,
                    size: 20,
                    color: appColors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    color: appColors.transparent,
                    child: Text(
                      name.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: appColors.darkBlue,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DatePickerWidget(
                  initialDate: initialDate,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900, 1, 1),
                  dateFormat: "MMM/dd/yyyy",
                  pickerType: "DateCalendar",
                  looping: looping,
                  onConfirm: (DateTime newDate, _) {
                    pickerStartData = newDate.toString();
                    // onConfirmStart(newDate.toString());
                  },
                  onChange: (DateTime newDate, _) {
                    pickerStartData = newDate.toString();

                    // onStartChange(newDate.toString());
                  },
                  pickerTheme: DateTimePickerTheme(
                    pickerHeight: 180,
                    itemHeight: 44,
                    backgroundColor: appColors.white,
                    itemTextStyle: TextStyle(
                        color: appColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    dividerColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              MaterialButton(
                height: 50,
                highlightElevation: 0,
                elevation: 0.0,
                minWidth: MediaQuery.sizeOf(context).width * 0.75,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: () {
                  onConfirm(pickerStartData.toString());
                  onChange(pickerStartData.toString());

                  Get.back();
                },
                color: appColors.guideColor,
                child: Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: appColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}

//
// class DurationUI extends StatelessWidget {
//   const DurationUI({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 40,
//       padding: EdgeInsets.all(8.h),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 3.0,
//               offset: const Offset(0.0, 3.0)),
//         ],
//         color: appColors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//       ),
//       child: GetBuilder<WalletController>(builder: (controller) {
//         return Obx(
//           () => DropdownButtonHideUnderline(
//             child: DropdownButton2<String>(
//               isDense: true,
//               isExpanded: true,
//               hint: Text(
//                 "select".tr,
//                 style: AppTextStyle.textStyle16(
//                     fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
//               ),
//               items: controller.durationOptions
//                   .map((String item) => DropdownMenuItem<String>(
//                         value: item,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 20),
//                           child: Text(
//                             item.tr,
//                             style: AppTextStyle.textStyle16(
//                                 fontWeight: FontWeight.w400,
//                                 fontColor: appColors.darkBlue),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ))
//                   .toList(),
//               style: AppTextStyle.textStyle16(
//                   fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
//               value: controller.selectedOption.value,
//               onChanged: (String? value) {
//             if(value == "Select Custom"){
//               controller.updateDurationValue(value!);
//                 showCupertinoModalPopup(
//                   context: Get.context!,
//                   barrierColor:
//                   appColors.darkBlue.withOpacity(0.5),
//                   builder: (context) => const DateSelection(),
//                 );
//             }else{
//                 controller.updateDurationValue(value!);
//                }},
//               iconStyleData: IconStyleData(
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down,
//                 ),
//                 iconSize: 35,
//                 iconEnabledColor: appColors.blackColor,
//               ),
//               dropdownStyleData: DropdownStyleData(
//                 width: ScreenUtil().screenWidth * 0.95,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(14),
//                   color: appColors.white,
//                 ),
//                 offset: const Offset(-10, -17),
//                 scrollbarTheme: ScrollbarThemeData(
//                   radius: const Radius.circular(40),
//                   thickness: MaterialStateProperty.all<double>(6),
//                   thumbVisibility: MaterialStateProperty.all<bool>(false),
//                 ),
//               ),
//               menuItemStyleData: const MenuItemStyleData(
//                 height: 40,
//                 padding: EdgeInsets.only(left: 14, right: 14),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
