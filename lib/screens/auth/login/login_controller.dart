import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController countryCodeController;
  late TextEditingController mobileNumberController;
  RxString get countryCode => countryCodeController.text.obs;

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

  @override
  void onInit() {
    super.onInit();
    countryCodeController = TextEditingController(text: "+91");
    mobileNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    countryCodeController.dispose();
    mobileNumberController.dispose();
  }
}
