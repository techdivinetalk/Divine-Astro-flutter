import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_exception.dart';
import '../../di/shared_preference_service.dart';
import '../../model/order_history_model/all_order_history.dart';
import '../../model/order_history_model/call_order_history.dart';
import '../../model/order_history_model/chat_order_history.dart';
import '../../model/order_history_model/gift_order_history.dart';
import '../../model/order_history_model/remedy_suggested_order_history.dart';
import '../../repository/order_history_repository.dart';

class OrderHistoryController extends GetxController {
  ScrollController orderScrollController = ScrollController();
  ScrollController orderAllScrollController = ScrollController();
  TabController? tabbarController;

  var durationOptions = ['daily'.tr, 'weekly'.tr, 'monthly'.tr, 'custom'.tr].obs;
  RxString selectedValue = "daily".tr.obs;

  var apiCalling = false.obs;
  var emptyMsg = "".obs;

  RxList<AllHistoryData> allHistoryList = <AllHistoryData>[].obs;
  RxList<CallHistoryData> callHistoryList = <CallHistoryData>[].obs;
  RxList<ChatDataList> chatHistoryList = <ChatDataList>[].obs;
  RxList<GiftDataList> giftHistoryList = <GiftDataList>[].obs;
  RxList<RemedySuggestedDataList> remedySuggestedHistoryList = <RemedySuggestedDataList>[].obs;

  var allPageCount = 1;
  var chatPageCount = 1;
  var callPageCount = 1;
  var liveGiftPageCount = 1;
  var remedyPageCount = 1;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  fetchData() async {
    Future.wait([
      getOrderHistory(0, allPageCount), //wallet
      getOrderHistory(1, chatPageCount), //chat
      getOrderHistory(2, callPageCount), //call
      getOrderHistory(3, liveGiftPageCount), //liveGifts
      getOrderHistory(4, remedyPageCount), //shop
    ]);
    update();
  }

  var preferences = Get.find<SharedPreferenceService>();

  Future<dynamic> getOrderHistory(int type, int page) async {
    var userData = preferences.getUserDetail();
    // print("token-->${userData!.deviceToken}");

    /* Map<String, dynamic> params = {
      "role_id": 7,
      "type": type,
      "page": page,
      "device_token": userData!.deviceToken,
      "start_date": "2023-02-06",
      "end_date": "2023-08-06"
    };*/

    Map<String, dynamic> params = {
      "role_id": 7,
      "type": 4,
      "page": 1,
      "device_token": "asdasdsadasdsa12313",
      "start_date": "2023-02-06",
      "end_date": "2023-08-06"
    };

    /*Map<String, String> headers = {
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5IiwianRpIjoiYzZjMGM5MTc1NzY4MjkwZWY5MzJmYWRjNDFhMTlhYzdjNGRmY2ExYzcyNDc0Mzk2ZmFhZjU2Zjg2NTdiNTI2MGJmOTJhNWIzOGY5MDQ4ODkiLCJpYXQiOjE2OTI4OTI3MDMuMjU3MjgsIm5iZiI6MTY5Mjg5MjcwMy4yNTcyODIsImV4cCI6MTg1MDc0NTUwMy4yNTE0NjYsInN1YiI6IjU3MyIsInNjb3BlcyI6W119.uyNgoUiddFlTuc_Fkq26HhorNaZ_uZt1v89-7DYAyyGu4iXTTPudUNJuHsCbMw7OM4bUqm-7OQDtjOWulPfOMF1l-hZl2VK0KDqZtnnSzF0O8Tl4OsVd4ndMpd3iMNrEmKfrEaICO81gD_mXs03RBljn8v2OgYFusJ6WIzcoyGx9KS69RmDe3_CWqRd8Il310zxfe3_Q7wExYgUKj9qzPmebJ3RlVi6rCpas35HsolJOYPiywoV20k5zVXEwxjh_u0YJqQR640wohpHNf8bqjtYFHHtEOHOIeAw-vL1Onb3wfPy-XZdlIPbJp5TegMWHJ9PNwV9XoRV028L4PHvSy8HrkIiRHAqzCw45_UPp8CWZqRLFxfwkhVKopsm5UAmXMzAY9Z50GuCfPu5n72Gdmqx9njue4Fcf1d0jEIcFOM1s81MQlVFDj6B7nUSrWAtkNwDltVsp4nZVyTpNzX3AcYkCGf1B-Nhh3g01rKigeqUggos5VtP0nBjpotNB0K7a89CR97ywmQVZxJ4QNzBYhSckLEnKql4ux0dBASsqyx0PKOF7wSTr7VoycDVdLAoEwgEfyHLeOu_IRNxisq7dAzM8H_RPj9m2GsvA0lOwnvdhjyknlit4h5QnHa8iCX6A8Pxipw5GOcF7zZ3fTXJwxgd3FXJ6ba5PHQ2dp8REh18",
      "Content-type": "application/json",
      "Cookie":
          "XSRF-TOKEN=eyJpdiI6InhaMncwZnBRSjhBMWs2Wm9sYjM4ZUE9PSIsInZhbHVlIjoiZVFDeTA2R29VbElhV3B5V2Z4N1dXQ0NidWwySzBFVFZaRENsdGJKMkk0azVXM3ZCcEdDblFIeEdYejhkcURqRi9wRHlxQnRPTEtYRGJYVVhTZGNHbGhZWGVKMjFndjZpQ2xOdEdGODl4TlY3dXdvZlA3M09YdHpZdm0rM21YYS8iLCJtYWMiOiIyYmVlOTk5M2IzMjIzMDRmYzRkN2ZhZTFkYjJjODNkNGUzMjhlNjJhOWQxZjhjMDA1YTAxNzVmMWE4MGJkNjAwIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6IjQ2d0NTSUdOcStUeHYyc29kSWFsVnc9PSIsInZhbHVlIjoiMTlnVitFQUtvdmw1U2lYaFRDcEpIdjR6N2dSbUd1VFRGQ1I3WGFaRk51Y1JVU3psczdVRXZCQWd4ZUl5VENaK2RJNlZ4ZmltZHFaajU3SXJydlN0QzhvVnlaczNvbkxsYVo4bnp0VU5HR0VmaFNNbUkwRklvUmJRUGZzV1NtdXAiLCJtYWMiOiI4OTk1MDUyMDMzZWU3NTA2MWJiNTM3M2JmZDdhMDk5NTI0NjA1NjE3MmI2NWMxMmM4YmEyYTk2MWFjN2U1MjU1IiwidGFnIjoiIn0%3D"
    };*/

    // 0: All,
    // 1:Call,
    // 2:Chat,
    // 3:Gift,
    // 4:Remedy Suggested

    try {
      apiCalling.value = true;
      if (type == 0) {
        AllOrderHistoryModelClass data = await OrderHistoryRepository().getAllOrderHistory(params);
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
      } else if (type == 1) {
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
      } else if (type == 2) {
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
            await OrderHistoryRepository().getRemedySuggestedOrderHistory(params);
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
      }
    } catch (error) {
      apiCalling.value = false;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }
}
