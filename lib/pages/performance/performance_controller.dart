import 'dart:convert';
import 'dart:developer';
import 'package:divine_astrologer/screens/rank_system/rank_system_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../common/app_exception.dart';
import '../../model/performance_model_class.dart';
import '../../repository/performance_repository.dart';

class PerformanceController extends GetxController {
  var percentageSubTitle = <ScoreModelClass>[
    ScoreModelClass("Total user converted from first user offer."),
    ScoreModelClass("Total repeated orders out of total orders received."),
    ScoreModelClass(
        "Total online hours spent on application on chat and call ."),
    ScoreModelClass("Total duration spent on application over live session."),
    ScoreModelClass("Total revenue generated through product selling."),
    ScoreModelClass(
        "Total busy hours out of online hours when busy over consultation."),
  ].obs;

  var txt =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It ";

  var scoreList = <ScoreModelClass>[
    ScoreModelClass("conversionRate".tr),
    ScoreModelClass("repurchaseRate".tr),
    ScoreModelClass("onlineHours".tr),
    ScoreModelClass("liveHours".tr),
    ScoreModelClass("eCommerce".tr),
    ScoreModelClass("busyHours".tr),
  ].obs;

  var percentageList = <PercentageModelClass>[
    PercentageModelClass("0-7hrs", '0'),
    PercentageModelClass("7-14hrs", '10'),
    PercentageModelClass("14-21hrs", '20'),
    PercentageModelClass("21-28hrs ", '40'),
    PercentageModelClass("28-35hrs", '60'),
    PercentageModelClass("35-45hrs", '80'),
    PercentageModelClass("45+", '100'),
  ].obs;

  var durationValue = ['today', 'last_week', 'last_month', 'Select Custom'].obs;

  var durationOptions =
      ['Today', 'Last Week', 'Last Month', 'Select Custom'].obs;
  RxString selectedValue = "today".obs;
  RxString selectedOption = "Today".obs;


  updateDurationValue(String val) {
    selectedOption.value = val;
    int index =durationOptions.indexOf(val);
    selectedValue.value = durationValue[index];
  }

  PerformanceModelClass? performanceData;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await getPerformanceList();
  }

  //Today's available

  String? availableChat, busyChat;
  String? availableCall, busyCall;
  String? availableLive, busyLive;

  //Last 30 days
  String? lastAvailableChat, lastAvailableCall;
  String? lastBusyCall, lastBusyChat, lastBusyLive;

  getPerformanceList() async {
    try {
      // Map<String, dynamic> params = {"filter": selectedOption.value};
      Map<String, dynamic> params = {"filter": 'last_week'};
      var response = await PerformanceRepository().getPerformance(params);
      performanceData = response;
      //Today's available
      availableChat =
          performanceData?.data?.todaysAvailiblity?.availableChat.toString();
      print("availableChat-->$availableChat");
      busyChat = performanceData?.data?.todaysAvailiblity?.busyChat.toString();
      availableCall =
          performanceData?.data?.todaysAvailiblity?.availableCall.toString();
      busyCall = performanceData?.data?.todaysAvailiblity?.busyCall.toString();
      availableLive =
          performanceData?.data?.todaysAvailiblity?.availableLive.toString();
      busyLive = performanceData?.data?.todaysAvailiblity?.busyLive.toString();
      //Last 30 days
      lastAvailableChat = performanceData
          ?.data?.last30DaysAvailiblity?.availableChat
          .toString();
      lastAvailableCall = performanceData
          ?.data?.last30DaysAvailiblity?.availableCall
          .toString();
      lastBusyChat =
          performanceData?.data?.last30DaysAvailiblity?.busyChat.toString();
      lastBusyCall =
          performanceData?.data?.last30DaysAvailiblity?.busyCall.toString();
      lastBusyLive =
          performanceData?.data?.last30DaysAvailiblity?.busyLive.toString();

      update(['permomre']);
      //Rank System
      RankSystemController rankSystemController =
          Get.put(RankSystemController());
      rankSystemController.rankSystemList = performanceData?.data?.rankSystem;

      log("performanceData==>${jsonEncode(performanceData!.data)}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }
}

class ScoreModelClass {
  String? scoreName;

  ScoreModelClass(this.scoreName);
}

class PercentageModelClass {
  String? name, score;

  PercentageModelClass(this.name, this.score);
}
