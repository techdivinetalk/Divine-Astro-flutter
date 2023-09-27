import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/number_change_request_model/number_change_response_model.dart';
import 'package:divine_astrologer/model/number_change_request_model/verify_otp_response.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/repository/number_change_req_repository.dart';
import 'package:divine_astrologer/screens/number_change/sub_screen/otp_screen_for_update_mobile_number.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NumberChangeReqController extends GetxController {
  final pref = Get.find<SharedPreferenceService>();
  late UserData userData;
  late final TextEditingController controller;
  late final TextEditingController pinController;
  Rx<String> countryCode = "+91".obs;
  FocusNode focusNodeOtp = FocusNode();
  final repository = Get.put(NumberChangeReqRepository());
  late NumberChangeResponse numberChangeResponse;
  RxBool enableUpdateButton = false.obs;

  VerifyOtpResponse? verifyOtpResponse;

  int get remainingCount => numberChangeResponse.data!.remainingAttempt!;

  @override
  void onInit() {
    super.onInit();
    userData = pref.getUserDetail()!;
    controller = TextEditingController(text: userData.mobileNumber);
    controller.addListener(listenerForNumberChange);
    pinController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    pinController.dispose();
  }

  void listenerForNumberChange() {
    if (userData.mobileNumber == controller.text) {
      enableUpdateButton.value = false;
    } else {
      enableUpdateButton.value = true;
    }
  }

  void sendOtp() async {
    try {
      Map<String, dynamic> param = {
        "mobile_no": controller.text.trim(),
      };
      final response = await repository.sendOtpForNumberChange(param);
      if (response.statusCode == 200 && response.success!) {
        numberChangeResponse = response;
        update();
        Get.toNamed(RouteName.numberChangeOtpScreen);
        focusNodeOtp.requestFocus();
      }
    } catch (err) {
      if (err is CustomException) {
        //err.onException();
        showOtpSheet(
          context: Get.context!,
          message: err.message,
        );
      }
    }
  }

  String? errorMessage;

  void verifyOtp() async {
    try {
      if (pinController.text.isEmpty || pinController.text.length != 6) return;
      Map<String, dynamic> param = {
        "session_id": "${numberChangeResponse.data?.sessionId}",
        "mobile_no": controller.text.trim(),
        "otp": pinController.text.trim()
      };
      final response = await repository.verifyOtpAPi(param);
      verifyOtpResponse = response;
      if (response.statusCode == 200 && response.success!) {
        divineSnackBar(data: response.message.toString());
        Get.back();
        await preferenceService.erase();
        Get.offNamed(RouteName.login);
      }
    } catch (err) {
      if (err is CustomException) {
        errorMessage = err.message;
        update();
        //err.onException();
      }
    }
  }
}
