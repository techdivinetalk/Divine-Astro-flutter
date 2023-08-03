import 'package:divine_astrologer/common/strings.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/pages/wallet/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/appbar.dart';
import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../side_menu/side_menu_ui.dart';

class WalletUI extends GetView<WalletController> {
  const WalletUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const SideMenuDrawer(),
      appBar: commonAppbar(
          title: "Wallet",
          trailingWidget: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                width: 90.w,
                height: 28.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkBlue, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹ 999",
                      style: AppTextStyle.textStyle10(
                          fontWeight: FontWeight.w700,
                          fontColor: AppColors.darkBlue),
                    ),
                  ],
                ),
              ),
            ),
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
                  height: 1.h, color: AppColors.darkBlue.withOpacity(0.5)),
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
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "June - 2023 ",
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w400, fontColor: AppColors.darkBlue),
          ),
          Assets.images.icDownArrow.svg()
        ],
      ),
    );
  }

  Widget balanceView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(AppString.availableBalance,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 10),
            Text("₹100000",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        const SizedBox(width: 6),
        Column(
          children: [
            Text(AppString.pgCharges,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 10),
            Text("₹100000",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        const SizedBox(width: 6),
        Column(
          children: [
            Text(AppString.subTotal,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 10),
            Text("₹100000",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        const SizedBox(width: 6),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Text("${AppString.tds}  ",
                  maxLines: 2,
                  style: AppTextStyle.textStyle12(
                      fontColor: AppColors.darkBlue,
                      fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 10),
            Text("₹100000",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        // const SizedBox(width: 6),
        // Text(AppString.gst,
        //     maxLines: 2,
        //     style: AppTextStyle.textStyle12(
        //         fontColor: AppColors.darkBlue,
        //         fontWeight: FontWeight.w400)),
        const SizedBox(width: 6),
        Column(
          children: [
            Text(AppString.payableAmount,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle12(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text("₹100000",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle10(
                    fontColor: AppColors.darkBlue,
                    fontWeight: FontWeight.w700)),
          ],
        ),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  detailView(),
                ],
              ),
            ));
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
                  "Order Id : $orderId",
                  style: AppTextStyle.textStyle12(fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.help_outline,
                  size: 20,
                  color: AppColors.darkBlue.withOpacity(0.5),
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
                  "$amount",
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w400,
                      fontColor: amount!.contains("+")
                          ? AppColors.lightGreen
                          : AppColors.appRedColour),
                )
              ],
            ),
            Text(
              "$details ",
              textAlign: TextAlign.start,
              style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  fontColor: AppColors.darkBlue.withOpacity(0.5)),
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
                      fontColor: AppColors.darkBlue.withOpacity(0.5)),
                ),
              ],
            ),
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
                Text(AppString.orderId,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.name,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.gender,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.dob,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.pob,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.orderDateTime,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.rate,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
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
                Text(AppString.duration,
                    style:
                        AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
              ],
            ),
            Text("data",
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
          ],
        )
      ],
    );
  }
}
