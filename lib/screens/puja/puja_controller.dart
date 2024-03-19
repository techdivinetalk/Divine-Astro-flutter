import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/faq_response.dart';
import 'package:divine_astrologer/repository/faqs_repository.dart';
import 'package:divine_astrologer/screens/puja/model/pooja_listing_model.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaController extends GetxController {
  List<PujaListingData> pujaData = [];
  bool isPujaLoading = false;
  String noPoojaFound = "";
  var pref = Get.find<SharedPreferenceService>();
  ScrollController orderScrollController = ScrollController();

  @override
  void onInit() {
    getPujaList();
    super.onInit();
  }

  getPujaList() async {
    isPujaLoading = true;
    try {
      Map<String, dynamic> params = {"role_id": userData?.roleId};
      var response = await userRepository.getPujaList(params);
      if (response.data!.isNotEmpty) {
        pujaData = response.data!;
        isPujaLoading = false;
      } else {
        isPujaLoading = false;
        noPoojaFound = "No Puja found!.";
      }
      update();
      log("Data Of Pooja ==> ${jsonEncode(response.data)}");
    } catch (error) {
      isPujaLoading = false;
      noPoojaFound = "No Puja found!.";
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

  ///{{url}}/api/astro/v7/getPoojaNameMaster
  /// {{url}}/api/astro/v7/getProductNameMaster
}
