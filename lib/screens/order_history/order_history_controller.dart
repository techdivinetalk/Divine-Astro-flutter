import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/pages/performance/widget/date_selection_ui.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/order_history_model/all_order_history.dart';
import '../../model/order_history_model/call_order_history.dart';
import '../../model/order_history_model/chat_order_history.dart';
import '../../model/order_history_model/gift_order_history.dart';
import '../../model/order_history_model/remedy_suggested_order_history.dart';
import '../../repository/order_history_repository.dart';

class OrderHistoryController extends GetxController {
  int initialPage = 0;
  Rx<DateTime> selectedChatDate = DateTime.now().obs;
  ScrollController orderScrollController = ScrollController();
  ScrollController orderAllScrollController = ScrollController();
  TabController? tabbarController;

  var durationOptions =
      ['daily'.tr, 'weekly'.tr, 'monthly'.tr, 'custom'.tr].obs;
  RxString selectedValue = "daily".tr.obs;

  var apiCalling = false.obs;
  var emptyMsg = "".obs;

  RxList<AllHistoryData> allHistoryList = <AllHistoryData>[].obs;
  RxList<CallHistoryData> callHistoryList = <CallHistoryData>[].obs;
  RxList<ChatDataList> chatHistoryList = <ChatDataList>[].obs;
  RxList<ChatDataList> feedHistoryList = <ChatDataList>[].obs;
  RxList<GiftDataList> giftHistoryList = <GiftDataList>[].obs;
  RxList<RemedySuggestedDataList> remedySuggestedHistoryList =
      <RemedySuggestedDataList>[].obs;
  final preferenceService = Get.find<SharedPreferenceService>();

  var allPageCount = 1;
  var chatPageCount = 1;
  var callPageCount = 1;
  var liveGiftPageCount = 1;
  var remedyPageCount = 1;

  @override
  void onInit() {
    if (Get.arguments != null) {
      initialPage = Get.arguments;
      print(initialPage);

      getOrderHistory(type: 3, page: liveGiftPageCount);
      update();
    }
    super.onInit();
    getOrderHistory(type: 0, page: allPageCount);
  }

  void selectChatDate(String value) {
    selectedChatDate(value.toDate());
  }

  String startDate = "";
  String endDate = "";

  // fetchData({String? startDate, endDate}) async {
  //   Future.wait([
  //     getOrderHistory(type: 0, page: allPageCount), //wallet
  //     getOrderHistory(type: 1, page: chatPageCount), //chat
  //     getOrderHistory(type: 2, page: callPageCount), //call
  //     getOrderHistory(type: 3, page: liveGiftPageCount), //liveGifts
  //     getOrderHistory(type: 4, page: remedyPageCount), //shop
  //   ]);
  //   update();
  // }

  var preferences = Get.find<SharedPreferenceService>();

  Future<dynamic> getOrderHistory(
      {int? type, int? page, String? startDate, endDate}) async {
    // var userData = preferences.getUserDetail();

    Map<String, dynamic> params = {
      /// role id should be 7 in whole project
      "role_id": 7,

      /// type 4 means suggest remedies
      "type": type!,
      "page": page!,
      "device_token": preferenceService.getDeviceToken(),
      //"flK0vjuwShCgrDVctAlgYb:APA91bHGpnRlw04TwyHThWnR0c7LFQYV5CfqVFQDsHhVZVyuKazeLwxxjwxcfRcicIKvrr2ZaQnLkXQvoFomKuS-TZ7n7sKfVyfJiT3Cv4MTSaKO-LCYMWvoVHY_txFAFWFmy7NEn4mf",
      // "start_date": "2023-02-06",
      // "end_date": "2023-08-06",
      // "start_date":
      //     startDate ?? DateFormat("yyyy-mm-dd").format(DateTime.now()),
      // "end_date": endDate ?? DateFormat("yyyy-mm-dd").format(DateTime.now()),
    };

    // 0: All,
    // 1:Call,
    // 2:Chat,
    // 3:Gift,
    // 4:Remedy Suggested

    try {
      apiCalling.value = true;
      if (type == 0) {
        AllOrderHistoryModelClass data =
            await OrderHistoryRepository().getAllOrderHistory(params);
        apiCalling.value = false;
        var history = data.data;

        if (history!.isNotEmpty && data.data != null) {
          emptyMsg.value = "";
          if (page == 1) allHistoryList.clear();
          allHistoryList.addAll(history);
          // callPageCount++;
        } else {
          emptyMsg.value = data.message ?? "No data found!";
        }
        update(['allOrders']);

      } else if (type == 1) {
        ChatOrderHistoryModelClass data =
        await OrderHistoryRepository().getChatOrderHistory(params);
        apiCalling.value = false;
        var history = data.data;

        if (history!.isNotEmpty && data.data != null) {
          emptyMsg.value = "";
          if (page == 1) chatHistoryList.clear();
          chatHistoryList.addAll(history);
          // shopPageCount++;
        } else {
          emptyMsg.value = data.message ?? "No data found!";
        }
      } else if (type == 2) {
        CallOrderHistoryModelClass data =
        await OrderHistoryRepository().getCallOrderHistory(params);
        apiCalling.value = false;
        var history = data.data;

        if (history!.isNotEmpty && data.data != null) {
          emptyMsg.value = "";
          if (page == 1) callHistoryList.clear();
          callHistoryList.addAll(history);
          // chatPageCount++;
        } else {
          emptyMsg.value = data.message ?? "No data found!";
        }
        update();
      } else if (type == 3) {
        GiftOrderHistoryModelClass data =
            await OrderHistoryRepository().getGiftOrderHistory(params);
        apiCalling.value = false;
        var history = data.data;

        if (history!.isNotEmpty && data.data != null) {
          emptyMsg.value = "";
          if (page == 1) giftHistoryList.clear();
          giftHistoryList.addAll(history);
          // liveGiftPageCount++;
        } else {
          emptyMsg.value = data.message ?? "No data found!";
        }
      } else if (type == 4) {
        RemedySuggestedOrderHistoryModelClass data =
            await OrderHistoryRepository()
                .getRemedySuggestedOrderHistory(params);
        apiCalling.value = false;
        var history = data.data;

        if (history!.isNotEmpty && data.data != null) {
          emptyMsg.value = "";
          if (page == 1) remedySuggestedHistoryList.clear();
          remedySuggestedHistoryList.addAll(history);
          // liveGiftPageCount++;
        } else {
          emptyMsg.value = data.message ?? "No data found!";
        }
      } /*else if(type == 5){
        ChatOrderHistoryModelClass data =
        await OrderHistoryRepository().getChatOrderHistory(params);
        apiCalling.value = false;
        var history = data.data;

        if (history!.isNotEmpty && data.data != null) {
          emptyMsg.value = "";
          if (page == 1) chatHistoryList.clear();
          chatHistoryList.addAll(history);
          // shopPageCount++;
        } else {
          emptyMsg.value = data.message ?? "No data found!";
        }
      }*/
      update();
    } catch (error) {
      apiCalling.value = false;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  /*getFilterDate({String? type}) {
    String startDate = "";
    String endDate = "";
    DateTime now = DateTime.now();

    if ("daily".tr == type) {
      fetchData(
          endDate: DateFormat("yyyy-mm-dd").format(DateTime.now()),
          startDate: DateFormat("yyyy-mm-dd").format(DateTime.now()));
    } else if ('weekly'.tr == type) {
      int currentDayOfWeek = now.weekday;

      DateTime startOfWeek = now.subtract(Duration(days: currentDayOfWeek - 1));

      DateTime endOfWeek =
          now.add(Duration(days: DateTime.daysPerWeek - currentDayOfWeek));

      startDate = DateFormat("yyyy-MM-dd").format(
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day));
      endDate = DateFormat("yyyy-MM-dd")
          .format(DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day));
      fetchData(endDate: endDate, startDate: startDate);
      update();
    } else if ('monthly'.tr == type) {
      startDate =
          DateFormat("yyyy-MM-dd").format(DateTime(now.year, now.month, 1));

      DateTime firstDayOfNextMonth = (now.month < 12)
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      endDate = DateFormat("yyyy-MM-dd")
          .format(firstDayOfNextMonth.subtract(const Duration(days: 1)));
      fetchData(endDate: endDate, startDate: startDate);
      update();
    } else {
      Get.bottomSheet(const DateSelection()).then((value) {
        if (value != null) {
          fetchData(endDate: value["end_date"], startDate: value["start_date"]);
          durationOptions[4] = "${value["start_date"]} - ${value["end_date"]}";
          update();
        }
      });
    }
  }*/
}
