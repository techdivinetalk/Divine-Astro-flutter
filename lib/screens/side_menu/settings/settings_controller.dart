import 'dart:developer';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/app_exception.dart';
import '../../../common/common_functions.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/delete_customer_model_class.dart';

class SettingsController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

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
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  void logOut() {
    userRepository.logOut().then(
      (value) async {
        if (value.statusCode == 200 && value.success == true) {
          preferenceService.erase().whenComplete(
                () => Get.offAllNamed(RouteName.login),
              );
        }
      },
    ).onError((error, stackTrace) {
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    });
  }
}
