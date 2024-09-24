import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/order_history_model/chat_order_history.dart';
import 'package:divine_astrologer/repository/waiting_list_queue_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/order_history_model/call_order_history.dart';
import '../../../model/waiting_list_queue.dart';
import '../../../repository/order_history_repository.dart';
import '../../../utils/enum.dart';

class WaitListUIController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var preference = Get.find<SharedPreferenceService>();
  final WaitingListQueueRepo repository;
  TabController? tabbarController;
  ScrollController scrollController = ScrollController();
  ScrollController chatScrollView = ScrollController();
  ScrollController callScrollView = ScrollController();
  WaitListUIController(this.repository);
  var tabOpened = 0.obs;
  Loading loading = Loading.initial;
  List<WaitingListQueueData> waitingPersons = <WaitingListQueueData>[];

  bool isInit = false;
  @override
  void onReady() {
    isInit = false;
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint("test_onInit: call");
    tabbarController = TabController(length: 4, vsync: this, initialIndex: 0);
    isInit = true;
    getWaitingList();
  }

  onAccept() {}

  getWaitingList() async {
    loading = Loading.loading;
    update();
    try {
      final response = await repository.fetchData();
      if (response.data != null) {
        waitingPersons = response.data!;
        update();
      }
      loading = Loading.loaded;
      update();
    } catch (err) {
      divineSnackBar(data: err.toString(), color: appColors.redColor);
    }
  }

  RxList<CallHistoryData> callHistoryList = <CallHistoryData>[].obs;

  var callApiCalling = false.obs;
  var emptyMsg = "".obs;
  var allApiCalling = false.obs;
  var callPageCount = 1;
  var callLoading = false.obs;
  Future<dynamic> getCallOrderHistory(
      {int? page, String? startDate, endDate}) async {
    Map<String, dynamic> params = {
      "role_id": 7,
      "type": 1,
      "page": page!,
      "device_token": preferenceService.getDeviceToken(),
    };
    log("paramparam ${params.toString()}");

    try {
      callApiCalling.value = true;
      if (callHistoryList.isEmpty) {
        callLoading.value = true;
      }
      update();
      CallOrderHistoryModelClass data =
          await OrderHistoryRepository().getCallOrderHistory(params);
      callApiCalling.value = false;

      var history = data.data;

      if (history!.isNotEmpty && data.data != null) {
        emptyMsg.value = "";
        if (page == 1) callHistoryList.clear();
        if (callHistoryList.isEmpty && page == 1) {
          callLoading.value = false;
        }
        callHistoryList.addAll(history);
        callPageCount++;
      } else {
        emptyMsg.value = data.message ?? "No data found!";
      }

      update();
    } catch (error) {
      callApiCalling.value = false;
      callLoading.value = false;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  RxList<ChatDataList> chatHistoryList = <ChatDataList>[].obs;

  var chatApiCalling = false.obs;
  var emptyMsg2 = "".obs;
  var allApiCalling2 = false.obs;
  var chatPageCount = 1;
  var chatLoading = false.obs;
  Future<dynamic> getChatOrderHistory(
      {int? page, String? startDate, endDate}) async {
    Map<String, dynamic> params = {
      "role_id": 7,
      "type": 2,
      "page": page!,
      "device_token": preferenceService.getDeviceToken(),
    };
    log("paramparam ${params.toString()}");

    try {
      chatApiCalling.value = true;
      if (chatHistoryList.isEmpty) {
        chatLoading.value = true;
      }
      update();
      ChatOrderHistoryModelClass data =
          await OrderHistoryRepository().getChatOrderHistory(params);
      chatApiCalling.value = false;

      var history = data.data;

      if (history!.isNotEmpty && data.data != null) {
        emptyMsg.value = "";
        if (page == 1) chatHistoryList.clear();
        if (chatHistoryList.isEmpty && page == 1) {
          chatLoading.value = false;
        }
        chatHistoryList.addAll(history);
        chatPageCount++;
      } else {
        emptyMsg.value = data.message ?? "No data found!";
      }
      update();
    } catch (error) {
      chatApiCalling.value = false;
      chatLoading.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  acceptChatButtonApi({String? queueId, orderId, int? index}) async {
    try {
      Map<String, dynamic> data = {
        "queue_id": queueId,
        "order_id": orderId,
      };
      final response = await repository.acceptChatApi(body: data);
      debugPrint("test_response: ${response.toString()}");

      if (response.isNotEmpty &&
          response == "success" &&
          waitingPersons.isNotEmpty &&
          waitingPersons.length > index!) {
        waitingPersons.removeAt(index);
        update();

        // for (int i = 0; i < waitingPersons.length; i++) {
        //   if (waitingPersons[i].id.toString() == queueId.toString()) {
        //     waitingPersons.removeAt(i);
        //     break;
        //   }
      }

      // update();
    } catch (err) {
      divineSnackBar(data: err.toString(), color: appColors.redColor);
    }
  }
}
