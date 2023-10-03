import 'package:divine_astrologer/common/common_bottomsheet.dart';
import 'package:divine_astrologer/model/res_order_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';

import '../../../di/shared_preference_service.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/res_login.dart';
import '../../../repository/shop_repository.dart';

class AllOptionController extends GetxController {
  ScrollController orderScrollController = ScrollController();

  final ShopRepository shopRepository;
  AllOptionController(this.shopRepository);
  UserData? userData;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  List<OrderData>? orderHistoryData;
  RxBool allOrderHistorySync = false.obs;

  showDetails({required int index}) {
    openBottomSheet(Get.context!,
        functionalityWidget: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: detailView(index: index),
              ),
            ],
          ),
        ));
  }

  Widget detailView({required int index}) {
    var details = orderHistoryData?[index];
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
            Text("${details?.orderId}",
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
            Text("${details?.customerName}",
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
            Text("${details?.dateTime}",
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
            Text("",
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
            Text(getDuration(duration: "${details?.duration}"),
                style: AppTextStyle.textStyle14(fontWeight: FontWeight.w400)),
          ],
        )
      ],
    );
  }

  String getDuration({required String duration}) {
    List time = duration.split(':').toList();
    debugPrint("Time $time");
    String returnString = "";
    if (time[0] != "00") {
      returnString = "${time[0]} hours ";
    }
    if (time[1] != "00") {
      returnString = "$returnString${time[1]} minutes ";
    }
    if (time[2] != "00") {
      returnString = "$returnString${time[2]} seconds";
    }
    return returnString;
  }

// //API Call
//   getOrderHistory() async {
//     Map<String, dynamic> params = {
//       "type": 1,
//       "role_id": 7,
//       "page": 1,
//       "device_token":
//           "cxAfLAIyQuaF6bwXpQaR1A:APA91bHPWkT5Qh7a8ESzOqhBcwLjSvogGmlqkO2Kr4aFNn8xXmyUlHD8UFj--uiSZcss5UopDakvn3tS8yypcXlSg4hYehlEji7jQDrNpPdriSXv3rRgrEtuzDbm-pHiozkm8qS03Cmz"
//     };
//     try {
//       var response = await shopRepository.getOrderHistory(params);
//       orderHistoryData = response.data;
//     } catch (error) {
//       if (error is AppException) {
//         error.onException();
//       } else {
//         Get.snackbar("Error", error.toString()).show();
//       }
//     }
//     allOrderHistorySync.value = true;
//   }
}
