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

  selectDaysType(value) {
    selectedDaysData = value;
    update();
  }

  selectEarningType(value) {
    selectedEarningData = value;
    getPassbookData();
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

  getPassbookData() async {
    isLoading(true);
    isLoading(true);
    int walletType = selectedEarningData == "Bonus"
        ? 2
        : selectedEarningData == "Paid"
            ? 1
            : selectedEarningData == "Ecomm"
                ? 3
                : 1;

    Map<String, dynamic> param = {
      "wallet_type": null,
      "type": walletType.toString(),
      "start_date": startDate == null ? "" : startDate,
      "end_date": endDate == null ? "" : endDate
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
