import 'dart:developer';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/pivacy_policy_model.dart';
import 'package:divine_astrologer/model/terms_and_condition_model.dart';
import 'package:divine_astrologer/screens/auth/login/login_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/app_exception.dart';
import '../../../common/common_functions.dart';
import '../../../di/shared_preference_service.dart';
import '../../../firebase_service/firebase_authentication.dart';
import '../../../model/delete_customer_model_class.dart';

class SettingsController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  RxString currLanguage = "".obs;

  @override
  void onReady() {
    super.onReady();
    setLocalLanguage();
  }

  setLocalLanguage() {
    Locale locale = Get.locale!;

    if (locale.languageCode == "en") {
      currLanguage.value = "english".tr;
    } else if (locale.languageCode == "hi") {
      currLanguage.value = "hindi".tr;
    } else if (locale.languageCode == "mr") {
      currLanguage.value = "marathi".tr;
    } else if (locale.languageCode == "gu") {
      currLanguage.value = "gujarati".tr;
    }
    update();
  }

  deleteUserAccounts() async {
    Map<String, dynamic> params = {};
    try {
      DeleteAccountModelClass data =
          await userRepository.deleteUserAccount(params);
      var userData = data;
      log("DeleteUser==>${userData.message}");
      Get.offAllNamed(RouteName.login);
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  void logOut() {
    print("logOutlogOutlogOut start");
    userRepository.logOut().then(
      (value) async {
        if (value.statusCode == 200 && value.success == true) {
          preferenceService.erase().whenComplete(() async {
            await Auth().handleSignOut();
            Get.offAllNamed(RouteName.login);
            update();
          });
        }
      },
    ).onError((error, stackTrace) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    });
  }

  Future<TermsConditionModel> getTermsCondition() async {
    return userRepository.getTermsCondition();
  }

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    return userRepository.getPrivacyPolicy();
  }
}
