import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/screens/otp_verification/timer_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/routes.dart';
import '../../model/firebase_model.dart';
import '../../model/res_login.dart';
import '../../model/send_otp.dart';
import '../../model/verify_otp.dart';
import '../../repository/user_repository.dart';

class OtpVerificationController extends GetxController {
  OtpVerificationController(this.userRepository);

  final UserRepository userRepository;

  var enableSubmit = true.obs;
  TextEditingController pinController = TextEditingController();
  RxInt otpLength = RxInt(0);
  var attempts = 3.obs;
  var countryCode = "";
  var sessionId = "";
  //String? token;
  var number = "".obs;
  var isWrongOtp = false.obs;
  var validationMsg = "".obs;
  String? deviceToken;

  final timerController = Get.put(TimerController());

  @override
  void onReady() async {
    var arguments = Get.arguments;
    if (arguments != null) {
      var args = arguments as List;
      number.value = args.first;
      sessionId = args[1];
      countryCode = args[2];
    }
    super.onReady();
  }

  resendOtp() async {
    Map<String, dynamic> params = {"mobile_no": number.value};
    try {
      SendOtpModel data = await userRepository.sentOtp(params);
      divineSnackBar(data: "OTP Re-send successfully.");
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else if (error is OtpInvalidTimerException) {
        timerController.extractTimerValue(error.message);
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.red);
      }
    }
  }

  bool isValid() {
    String pin = pinController.text;
    if (!pin.isNotEmpty || pin.length < 6) {
      validationMsg.value = "Please enter valid OTP";
      return false;
    }
    return true;
  }

  verifyOtp() async {
    if (!isValid()) {
      return false;
    }
    Map<String, dynamic> params = {
      "mobile_no": number.value,
      "country_code": countryCode,
      "otp": pinController.text,
      "session_id": sessionId
    };
    try {
      enableSubmit.value = false;
      VerifyOtpModel data = await userRepository.verifyOtp(params);
      await astroLogin();
      enableSubmit.value = true;
    } catch (error) {
      enableSubmit.value = true;
      debugPrint("error $error");
      if (error is AppException) {
        isWrongOtp.value = true;
        removeAttempts();
        validationMsg.value = (error as CustomException).message;
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.red);
      }
    }
  }

  Future<void> astroLogin() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> params = {
      "mobile_no": number.value,
      "device_token": await FirebaseMessaging.instance.getToken()
    };
    try {
      ResLogin data = await userRepository.userLogin(params);
      updateLoginDatainFirebase(data);
      navigateToDashboard(data);
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: AppColors.redColor);
      }
    }
  }

  // Future<void> updateLoginDatainFirebase(ResLogin data) async {
  //   String uniqueId = await getDeviceId() ?? '';
  //   FirebaseUserData firebaseUserData = FirebaseUserData(
  //     data.data!.name!,
  //     data.data!.deviceToken!,
  //     data.data!.image ?? "",
  //     RealTime(
  //         isEngagedStatus: 0,
  //         uniqueId: uniqueId,
  //         walletBalance: 0),
  //   );
  //   FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  //
  //   final DatabaseReference databaseRef =
  //   firebaseDatabase.ref().child("astrologer/${data.data?.id}");
  //   databaseRef.set(firebaseUserData.toJson());
  // }

  Future<void> updateLoginDatainFirebase(ResLogin data) async {
    String uniqueId = await getDeviceId() ?? '';
    FirebaseUserData firebaseUserData = FirebaseUserData(
      data.data!.name!,
      data.data!.deviceToken!,
      data.data!.image ?? "",
      RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0),
    );
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

    final DatabaseReference databaseRef =
        firebaseDatabase.ref().child("astrologer/${data.data?.id}");
    databaseRef.set(firebaseUserData.toJson());
    final appFirebaseService = AppFirebaseService();
    debugPrint(
        'preferenceService.getUserDetail()!.id ${preferenceService.getUserDetail()!.id}');
    appFirebaseService.readData(
        'astrologer/${preferenceService.getUserDetail()!.id}/realTime');
  }

  navigateToDashboard(ResLogin data) async {
    preferenceService.erase();

    preferenceService.setUserDetail(data.data!);
    preferenceService.setToken(data.token!);
    preferenceService.setDeviceToken(deviceToken ?? "");
    Get.offAllNamed(RouteName.dashboard,
        arguments: [data.data!.phoneNo, data.data!.sessionId]);
  }

  removeAttempts() {
    if (attempts.value > 0) {
      attempts.value = attempts.value - 1;
    }
  }
}
