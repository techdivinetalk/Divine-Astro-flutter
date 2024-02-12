import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/pages/wallet/wallet_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/appbar.dart';
import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/common_options_row.dart';

class WalletUI extends GetView<WalletController> {
  const WalletUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: commonAppbar(
          title: "wallet".tr,
          trailingWidget: InkWell(
            onTap: () {
              Get.toNamed(RouteName.orderHistory);
            },
            child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Assets.images.icOrderHistory.svg()),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              durationWidget(),
              const SizedBox(height: 20),
              balanceView(),
              const SizedBox(height: 20),
              Container(
                  height: 1.h, color: appColors.darkBlue.withOpacity(0.5)),
              const SizedBox(height: 20),
              ListView.builder(
                controller: controller.orderScrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.orderList.value,
                itemBuilder: (context, index) {
                  Widget separator = const SizedBox(height: 30);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 2)
                        orderDetailView(
                            orderId: 785421,
                            type: "PENALTY",
                            amount: "- ₹100000",
                            details:
                                "Policy Violation - Shared Personal Information with User  ",
                            time: "23 June 23, 02:46 PM"),
                      if (index % 2 == 0 && index != 2)
                        orderDetailView(
                            orderId: 785421,
                            type: "CHAT",
                            amount: "+ ₹100000",
                            details: "with Username(user id) for 8 minutes ",
                            time: "23 June 23, 02:46 PM"),
                      if (index % 2 == 1)
                        orderDetailView(
                            orderId: 785421,
                            type: "CALL",
                            amount: "- ₹100000",
                            details:
                                "Policy Violation - Shared Personal Information with User  ",
                            time: "23 June 23, 02:46 PM"),
                      separator,
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget durationWidget() {
    return Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.0,
                  offset: const Offset(0.0, 3.0)),
            ],
            color: appColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: durationOptions());
  }

  Widget balanceView() {
    return SizedBox(
      height: 60.h,
      width: ScreenUtil().screenWidth,
      child: ListView.builder(
        controller: controller.amountScrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: controller.amountTypeList.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60.w,
                child: amountDetailView(
                    amountType: controller.amountTypeList[index],
                    amount: "10000",
                    is2linesRequired:
                        controller.amountTypeList[index] == "tds".tr
                            ? false
                            : true,
                    boldTextStyle:
                        controller.amountTypeList[index] == "totalAmount".tr
                            ? true
                            : false),
              ),
              const SizedBox(width: 10)
            ],
          );
        },
      ),
    );
    // Container();
  }

  Widget amountDetailView(
      {required String amountType,
      required String amount,
      required bool is2linesRequired,
      required bool boldTextStyle}) {
    return Column(
      children: [
        if (is2linesRequired)
          Text("$amountType:",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyle.textStyle12(
                  fontColor: appColors.darkBlue,
                  fontWeight:
                      boldTextStyle ? FontWeight.w700 : FontWeight.w400)),
        if (!is2linesRequired)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 9),
            child: Text("${"tds".tr}:",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.textStyle12(
                    fontColor: appColors.darkBlue,
                    fontWeight: FontWeight.w400)),
          ),
        const SizedBox(height: 10),
        Text(amount, //"₹100000",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle10(
                fontColor: appColors.darkBlue,
                fontWeight: boldTextStyle ? FontWeight.w700 : FontWeight.w400)),
      ],
    );
  }

  Widget orderDetailView(
      {required int orderId,
      required String? type,
      required String? amount,
      required String? details,
      required String? time}) {
    return InkWell(
      onTap: () {
        openBottomSheet(Get.context!,
            functionalityWidget: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: detailView(),
                  ),
                ],
              ),
            ));
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
              children: [
                Text(
                  "Order Id : $orderId",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.help_outline,
                  size: 20,
                  color: appColors.darkBlue.withOpacity(0.5),
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
                          ? appColors.appRedColour
                          : appColors.darkBlue),
                ),
                Text(
                  "$amount",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: amount!.contains("+")
                          ? appColors.lightGreen
                          : appColors.appRedColour),
                )
              ],
            ),
            Text(
              "$details ",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: appColors.darkBlue.withOpacity(0.5)),
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
                      fontColor: appColors.darkBlue.withOpacity(0.5)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CommonOptionRow(
              leftBtnTitle: "refund".tr,
              onLeftTap: () {},
              onRightTap: () {},
              rightBtnTitle: "suggestedRemediesEarning".tr,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget detailView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.images.icOrder.svg(),
                const SizedBox(width: 15),
                Text("orderId".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("183837238231",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("name".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("Mrigashree Baruah",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("gender".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("Female",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("dob".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("21 May  2002, 12:38 PM",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("pob".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("Guwahati, Assam, India",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("orderDateTime".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("09 Mar, 12:40Pm ",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("rate".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("₹100/min",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
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
                Text("duration".tr,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("5 mins",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
          ],
        )
      ],
    );
  }

  Widget durationOptions() {
    return Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "June - 2023 ",
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            ),
            items: controller.durationOptions
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          item.tr,
                          style: AppTextStyle.textStyle16(
                              fontWeight: FontWeight.w400,
                              fontColor: appColors.darkBlue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                .toList(),
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: appColors.darkBlue),
            value: controller.selectedValue.value,
            onChanged: (String? value) {
              controller.selectedValue.value = value ?? "daily".tr;
            },
            iconStyleData:  IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down,
              ),
              iconSize: 35,
              iconEnabledColor: appColors.blackColor,
            ),
            dropdownStyleData: DropdownStyleData(
              width: ScreenUtil().screenWidth * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: appColors.white,
              ),
              offset: const Offset(-8, -17),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(false),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ));
  }
}
