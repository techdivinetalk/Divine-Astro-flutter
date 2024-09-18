import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/repository/waiting_list_queue_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../di/shared_preference_service.dart';
import '../../../model/waiting_list_queue.dart';
import '../../../utils/enum.dart';

class WaitListUIController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var preference = Get.find<SharedPreferenceService>();
  final WaitingListQueueRepo repository;
  TabController? tabbarController;
  ScrollController scrollController = ScrollController();
  WaitListUIController(this.repository);

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
    tabbarController = TabController(length: 2, vsync: this, initialIndex: 0);
    isInit = true;
    getWaitingList();
  }

  onAccept() {}

  getWaitingList() async {
    try {
      final response = await repository.fetchData();
      if (response.data != null) {
        waitingPersons = response.data!;
      }
      loading = Loading.loaded;
      update();
    } catch (err) {
      divineSnackBar(data: err.toString(), color: appColors.redColor);
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
