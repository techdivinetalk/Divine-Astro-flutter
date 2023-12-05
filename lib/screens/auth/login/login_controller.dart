import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/app_exception.dart';
import '../../../common/routes.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/firebase_model.dart';
import '../../../model/res_login.dart';
import '../../../model/send_otp.dart';
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
  FocusNode numberFocus = FocusNode();
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
    //deviceToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> params = {
      "mobile_no": mobileNumberController.text,
      "country_code": countryCodeController.text,
      //"device_token": await FirebaseMessaging.instance.getToken()
    };
    try {
      SendOtpModel data = await userRepository.sentOtp(params);
      navigateToOtpPage(data);
      //updateLoginDatainFirebase(data);
      //navigateToDashboard(data);
    } catch (error) {
      enable.value = true;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  void navigateToOtpPage(SendOtpModel data) {
    Get.toNamed(RouteName.otpVerificationPage,
        arguments: [data.data.mobileNo, data.data.sessionId, countryCodeController.text]);
    mobileNumberController.clear();
    enable.value = true;
  }

  navigateToDashboard(ResLogin data) async {
    preferenceService.erase();

    preferenceService.setUserDetail(data.data!);
    preferenceService.setToken(data.token!);
    mobileNumberController.clear();
    preferenceService.setDeviceToken(deviceToken ?? "");
    final socket = AppSocket();
    socket.socketConnect();
    Get.offAllNamed(RouteName.dashboard,
        arguments: [data.data!.phoneNo, data.data!.sessionId]);
    enable.value = true;
  }

  void updateLoginDatainFirebase(ResLogin data) {
    FirebaseUserData firebaseUserData = FirebaseUserData(
      data.data!.name!,
      data.data!.deviceToken!,
      data.data!.image ?? "",
      RealTime(
          isEngagedStatus: 0,
          uniqueId: data.data!.deviceModel ?? "",
          walletBalance: 0),
    );
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

    final DatabaseReference databaseRef =
        firebaseDatabase.ref().child("astrologer/${data.data?.id}");
    databaseRef.set(firebaseUserData.toJson());
  }

  @override
  void onInit() {
    super.onInit();
    getLoginImages();
    countryCodeController = TextEditingController(text: "+91");
    mobileNumberController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    super.dispose();
    countryCodeController.dispose();
    mobileNumberController.dispose();
  }

  LoginImages? loginImages;

  List<LoginDatum> get images => loginImages?.data.data ?? <LoginDatum>[];

  String get amazonUrl => loginImages!.data.baseurl;

  List<SvgPicture> staticImages = [
    Assets.svg.pleaseRegister1.svg(),
    Assets.svg.pleaseRegister2.svg(),
  ];
  List<String> imageDec = [
    "Please Enter your Registered mobile number to proceed as an astrologer to the platform.",
    "You will get a call on the registered mobile number for verification."
  ];

  void getLoginImages() async {
    if (preferenceService.getLoginImages() != null) {
      loginImages = preferenceService.getLoginImages()!;
      update();
    } else {
      loginImages = await getInitialLoginImages();
      update();
    }
  }

  Future<LoginImages> getInitialLoginImages() async {
    final response = await userRepository.getInitialLoginImages();
    return response;
  }

  /*@override
  void onDetached() {
    log('----> detached');
  }

  @override
  void onInactive() {
    numberFocus.unfocus();
  }

  @override
  void onPaused() {
    numberFocus.unfocus();
  }

  @override
  void onResumed() {
    numberFocus.requestFocus();
  }*/
}
