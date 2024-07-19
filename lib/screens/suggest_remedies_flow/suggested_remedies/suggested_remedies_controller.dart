import 'dart:developer';
import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/order_history_model/remedy_suggested_order_history.dart';
import 'package:divine_astrologer/repository/order_history_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestedRemediesController extends GetxController {
  var suggestApiCalling = false.obs;
  final scrollController = ScrollController();
  var allPageCount = 1;
  var emptyMsg = "".obs;
  RxList<RemedySuggestedDataList> remedySuggestedHistoryList =
      <RemedySuggestedDataList>[].obs;
  var remedyPageCount = 1;

  @override
  void onInit() {
    // TODO: implement onInit
    getOrderHistory(type: 4, page: allPageCount);
    super.onInit();
  }

  Future<dynamic> getOrderHistory(
      {int? type, int? page, String? startDate, endDate}) async {
    Map<String, dynamic> params = {
      /// role id should be 7 in whole project
      "role_id": 7,

      /// type 4 means suggest remedies
      "type": type!,
      "page": page!,
      "device_token": preferenceService.getDeviceToken(),
    };
    log("paramparam ${params.toString()}");
    try {
      suggestApiCalling.value = true;
      update();
      RemedySuggestedOrderHistoryModelClass data =
          await OrderHistoryRepository().getRemedySuggestedOrderHistory(params);
      suggestApiCalling.value = false;
      var history = data.data;
      if (history!.isNotEmpty && data.data != null) {
        emptyMsg.value = "";
        if (page == 1) remedySuggestedHistoryList.clear();
        remedySuggestedHistoryList.addAll(history);
        remedyPageCount++;
      } else {
        emptyMsg.value = data.message ?? "No data found!";
      }
      update();
    } catch (error) {
      suggestApiCalling.value = false;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  Widget paginationLoadingWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CircularProgressIndicator(color: appColors.guideColor),
      );
}
