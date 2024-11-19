import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/model/PassBookDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../repository/user_repository.dart';

class PassbooksController extends GetxController with WidgetsBindingObserver {
  var selectedDaysData;
  var selectedEarningData;
  UserRepository userRepository = UserRepository();
  var isLoading = false.obs;
  PassBookDataModel? passBookDataModel;
  var startDate;
  var endDate;
  ScrollController scrollController = ScrollController();
  selectDaysType(value) {
    selectedDaysData = value;
    update();
  }

  selectEarningType(value) {
    getPassbookData(value);
    update();
    selectedEarningData = value;
    update();
  }

  setStartDate(var value) {
    startDate = value;
    update();
  }

  setEndDate(var value) {
    endDate = value;
    update();
  }

  var data;
  // dom.Document document = htmlparser.parse(data);

  getPassbookData(value) async {
    isLoading(true);

    int walletType = value == "bonus".tr
        ? 2
        : value == "paid".tr
            ? 1
            : value == "ecom".tr
                ? 3
                : 1;

    Map<String, dynamic> param = {
      "wallet_type": walletType,
      "type": null,
      "start_date": startDate ?? "",
      "end_date": endDate ?? ""
    };

    log("paramssss${param.toString()}");
    isLoading(true);

    try {
      log(222.toString());

      final response = await userRepository.getpassbookData(param);
      if (response.success == true) {
        passBookDataModel = response;

        isLoading(false);
        update();
      } else {
        log(3.toString());

        isLoading(false);
      }
      log("Data Of submit ==> ${jsonEncode(passBookDataModel!.data)}");
    } catch (error) {
      log(33.toString());

      isLoading(false);
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
    update();
  }
}
