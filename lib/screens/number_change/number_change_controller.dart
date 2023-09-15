import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NumberChangeReqController extends GetxController {
  final pref = Get.find<SharedPreferenceService>();
  late UserData userData;
  late final TextEditingController controller;
  late final TextEditingController pinController;
  Rx<String> countryCode = "+91".obs;
  FocusNode focusNodeOtp = FocusNode();

  RxBool enableUpdateButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    userData = pref.getUserDetail()!;
    controller = TextEditingController(text: userData.phoneNo);
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
    if (userData.phoneNo == controller.text) {
      enableUpdateButton.value = false;
    } else {
      enableUpdateButton.value = true;
    }
  }
}
