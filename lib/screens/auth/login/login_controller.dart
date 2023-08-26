import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/routes.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/firebase_model.dart';
import '../../../model/res_login.dart';
import '../../../repository/user_repository.dart';

class LoginController extends GetxController {
  LoginController(this.userRepository);
  final UserRepository userRepository;
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  late TextEditingController countryCodeController;
  late TextEditingController mobileNumberController;
  RxString get countryCode => countryCodeController.text.obs;
  var enable = true.obs;
  String? deviceToken;

  RxBool hasError = false.obs;

  final List<Widget> imgList = [
    Assets.images.bgRegisterLogo.image(
        width: ScreenUtil().screenWidth * 0.9,
        height: ScreenUtil().screenHeight * 0.25,
        fit: BoxFit.contain),
    Assets.images.bgServiceLogo.image(
        width: ScreenUtil().screenWidth * 0.9,
        height: ScreenUtil().screenHeight * 0.25,
        fit: BoxFit.contain),
  ];

  final List<String> infoList = [
    "Please Enter your Registered mobile number to proceed as an astrologer to the platform.",
    "You will get a call on the registered mobile number for verification.",
  ];
  void setCode(String value) {
    if (!value.contains("+")) value = "+$value";
    countryCodeController.text = value;
    update();
  }

  login() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> params = {
      "mobile_no": mobileNumberController.text,
      "device_token": await FirebaseMessaging.instance.getToken()
    };
    try {
      ResLogin data = await userRepository.userLogin(params);
      updateLoginDatainFirebase(data);
      navigateToDashboard(data);
    } catch (error) {
      enable.value = true;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        Get.snackbar("Error", error.toString()).show();
      }
    }
  }

  navigateToDashboard(ResLogin data) {
    preferenceService.erase();
    preferenceService.setUserDetail(data.data!);
    preferenceService.setToken(data.token!);

    mobileNumberController.clear();
    preferenceService.setDeviceToken(deviceToken ?? "");
    Get.offAllNamed(RouteName.dashboard,
        arguments: [data.data!.phoneNo, data.data!.sessionId]);
    enable.value = true;
  }

  void updateLoginDatainFirebase(ResLogin data) {
    FirebaseUserData userData = FirebaseUserData(
      data.data!.name!,
      data.data!.deviceToken!,
      data.data!.image!,
      RealTime(0, data.data!.deviceModel!),
    );
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

    final DatabaseReference databaseRef =
    firebaseDatabase.ref().child("astrologer/${data.data?.id}");
    databaseRef.set(userData.toJson());
  }

  @override
  void onInit() {
    super.onInit();
    countryCodeController = TextEditingController(text: "+91");
    mobileNumberController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    super.dispose();
    countryCodeController.dispose();
    mobileNumberController.dispose();
  }
}
