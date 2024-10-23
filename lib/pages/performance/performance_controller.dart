import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/model/performance_response.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/app_exception.dart';
import '../../model/AstroRitentionModel.dart';
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

  Rx<Loading> loading = Loading.initial.obs;
  var txt =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry...";

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

  var durationValue = ['yesterday', 'last_week', 'last_month'].obs;
  var durationOptions = ['Yesterday', 'Last Week', 'Last Month'].obs;

  RxString selectedValue = "yesterday".obs;
  RxString selectedOption = "Yesterday".obs;

  void updateDurationValue(String val) {
    if (selectedOption.value != val) {
      // if(selectedOption.value =="Yesterday"){
      //   selectedOption.value = val;
      //
      // }else{}
      selectedOption.value = val;
      int index = durationOptions.indexOf(val);
      selectedValue.value = durationValue[index];
      log("=======${selectedValue.value}");
      getPerformance();
    }
  }

  var performanceData = Rxn<PerformanceResponse>(); // Reactive variable

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
    isInit = true;

    init();
  }

  Future<void> init() async {
    await getPerformance();
    await getRitentionDataApi();

    // await getRitentionDataApi();
  }

  RxList<dynamic> overAllScoreList = <dynamic>[].obs;

  Future<void> getPerformance() async {
    loading.value = Loading.loading;
    update();
    try {
      Map<String, dynamic> params = {"filter": selectedValue.value};
      log('-------${params.toString()}');

      var response = await PerformanceRepository().getPerformance(params);
      log('😻😻😻😻😻😻😻😻😻');
      log("Res-->${jsonEncode(response.data)}");
      performanceData.value = response; // Assigning response to performanceData
      overAllScoreList.value = [
        response.data?.conversionRate,
        response.data?.repurchaseRate,
        response.data?.onlineHours,
        response.data?.liveHours,
        response.data?.ecom,
        response.data?.busyHours,
      ];

      update();
      log('🤟🤟🤟🤟🤟🤟🤟');
      log("performanceData==>${jsonEncode(performanceData.value?.data)}");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    loading.value = Loading.loaded;
  }

  AstroRitentionModel? getRitentionModel;
  var loadingritention = false.obs;
  getRitentionDataApi() async {
    loadingritention.value = true;
    update();
    try {
      var data = await userRepository.getRitentionData({});
      if (data.statusCode == 200) {
        getRitentionModel = data;
        loadingritention.value = false;
      } else {
        getRitentionModel = null;
      }
      print(
          "-----------------------getRitentionData -------- ${data.toJson().toString()}");

      print(
          "-----------------------getRitentionData -------- ${getRitentionModel!.toJson().toString()}");
      update();
    } catch (error) {
      loadingritention.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        //  divineSnackBar(data: error.toString(), color: appColors.redColor);
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
