import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/common/generic_loading_widget.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/wallet/wallet_model.dart';
import 'package:divine_astrologer/pages/wallet/wallet_controller.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/appbar.dart';
import '../../../common/colors.dart';

class WalletPage extends GetView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: commonAppbar(
        title: "wallet".tr,
        trailingWidget: InkWell(
          onTap: () => Get.offNamed(RouteName.orderHistory),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Assets.images.icOrderHistory.svg(),
          ),
        ),
      ),
      body: Column(
        children: [
          /*  balanceView(),*/
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             SizedBox(
               width: 60.w,
               child: Column(
                 children: [
                   Text(
                     'Available Balance:',
                     textAlign: TextAlign.center,
                     maxLines: 2,
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                   const SizedBox(height: 10),
                   Text(
                     '₹${controller.walletListRepo.value.data?.totalAmountEarned.amountEarned ?? 0}',
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                 ],
               ),
             ),
             SizedBox(
               width: 60.w,
               child: Column(
                 children: [
                   Text(
                     'PG \n Charges:',
                     textAlign: TextAlign.center,
                     maxLines: 2,
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                   const SizedBox(height: 10),
                   Text(
                     '₹${controller.walletListRepo.value.data?.productRevenue.amount ?? 0}',
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                 ],
               ),
             ),
             SizedBox(
               width: 60.w,
               child: Column(
                 children: [
                   Text(
                     'Sub \n Total:',
                     textAlign: TextAlign.center,
                     maxLines: 2,
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                   const SizedBox(height: 10),
                   Text(
                     '₹${controller.walletListRepo.value.data?.weeklyOrder.count ?? 0}',
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                 ],
               ),
             ),
             SizedBox(
               width: 60.w,
               child: Column(
                 children: [
                   Text(
                     'Product  \n Sold:',
                     textAlign: TextAlign.center,
                     maxLines: 2,
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                   const SizedBox(height: 10),
                   Text(
                     '₹${controller.walletListRepo.value.data?.productSold.count ?? 0}',
                     style: AppTextStyle.textStyle12(
                         fontColor: appColors.darkBlue,
                         fontWeight: FontWeight.w400
                     ),
                   ),
                 ],
               ),
             ),
             SizedBox(
               width: 60.w,
               child: Column(
                 children: [
                   Text(
                     'Total \n Amount',
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
         ).scrollHorizontal(),
           const SizedBox(height: 20),
              Container(
                  height: 1.h, color: appColors.darkBlue.withOpacity(0.5)),
              const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(
                      () {
                    final paymentLogList =
                        controller.walletListRepo.value.data?.paymentLog;
                    if (controller.loading == Loading.loading) {
                      return const GenericLoadingWidget();
                    } else if (paymentLogList != null &&
                        paymentLogList.isNotEmpty) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentLogList.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final log = paymentLogList[index];
                          return PaymentLogTile(log: log!);
                        },
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}

class PaymentLogTile extends StatelessWidget {
  final PaymentLog log;

  const PaymentLogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
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
                          child: detailView(),
                        ),
                      ],
                    ),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${"orderId".tr} : ${log.orderId}",
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
                log.payoutFor != "chat" ? 'Chat' : 'Call',
                style: AppTextStyle.textStyle12(
                  fontWeight: FontWeight.w400,
                  /*fontColor: "$type" == "PENALTY"
                          ? appColors.appRedColour
                          : appColors.darkBlue*/
                ),
              ),
              Text(
                "+ ₹${log.totalAmount}",
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
            "with ${log.customerDetails?.name}(${log.customerDetails?.id}) for ${log.callDuration} minutes",
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
          const SizedBox(height: 10),
        ],
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
}
