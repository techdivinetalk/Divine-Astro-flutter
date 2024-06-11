import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/screens/remedies/model/remedies_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemediesController extends GetxController{
  List<Remedy> remdiesData = [];
  bool isRemdiesLoading = false;
  String noRemediesFound = "";
  var pref = Get.find<SharedPreferenceService>();


  @override
  void onInit() {
    getPujaList();
    super.onInit();
  }

  getPujaList() async {
    isRemdiesLoading = true;
    try {
      Map<String, dynamic> params = {"role_id": userData?.roleId};
      var response = await userRepository.getRemedyList(params);
      if (response.data != null) {
        remdiesData = response.data!;
        isRemdiesLoading = false;
      } else {
        isRemdiesLoading = false;
        noRemediesFound = "No Puja found!.";
      }
      update();
      log("Data Of Pooja ==> ${jsonEncode(response.data)}");
    } catch (error) {
      isRemdiesLoading = false;
      noRemediesFound = "No Puja found!.";
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void deletePujaApi({String? deleteId}) async {
    try {
      final response = await userRepository.deletePujaApi(id: deleteId);
      if (response.statusCode == 200) {
        Get.back(result: 1);
      }
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }
}