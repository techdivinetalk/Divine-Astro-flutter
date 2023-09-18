import 'dart:convert';
import 'dart:developer';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
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

  var durationValue = ['today', 'last_week', 'last_month'].obs;

  var durationOptions = ['Today', 'Last Week', 'Last Month'].obs;
  RxString selectedValue = "today".obs;
  RxString selectedOption = "Today".obs;

  updateDurationValue(String val) {
    selectedOption.value = val;
    int index = durationOptions.indexOf(val);
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

  RxList<BusyHours?> overAllScoreList = <BusyHours?>[].obs;

  getPerformanceList() async {
    try {
      // Map<String, dynamic> params = {"filter": selectedOption.value};
      Map<String, dynamic> params = {"filter": 'last_month'};
      var response = await PerformanceRepository().getPerformance(params);
      log("Res-->${jsonEncode(response.data)}");
      performanceData = response;
      overAllScoreList.value = [
        response.data?.response?.conversionRate,
        response.data?.response?.repurchaseRate,
        response.data?.response?.onlineHours,
        response.data?.response?.liveHours,
        response.data?.response?.eCommerce,
        response.data?.response?.busyHours,
      ];

      update();
      RankSystemController rankSystemController = Get.put(RankSystemController());
      rankSystemController.rankSystemList = performanceData?.data?.rankSystem;

      log("performanceData==>${jsonEncode(performanceData!.data)}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(),color: AppColors.redColor);
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
