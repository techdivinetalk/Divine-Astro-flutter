import 'dart:collection';

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
  var isLoading = false.obs;

  @override
  void onReady() async {
    var arguments = Get.arguments;
    if (arguments != null) {
      var args = arguments as List;
      number.value = args.first;
      sessionId = args[1];
      countryCode = args[2];
    }
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint(value);
      deviceToken = value;
    });
    super.onReady();
  }

  var isResendOtp = false.obs;

  resendOtp() async {
    Map<String, dynamic> params = {"mobile_no": number.value};
    try {
      isResendOtp.value = true;
      SendOtpModel data = await userRepository.sentOtp(params);
      isResendOtp.value = false;
      divineSnackBar(data: "OTP Re-send successfully.");
      update();
    } catch (error) {
      isResendOtp.value = false;
      update();
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else if (error is OtpInvalidTimerException) {
        timerController.extractTimerValue(error.message);
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
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
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  Future<void> astroLogin() async {
    update();
    print("UserStatus login api");
    Map<String, dynamic> params = {
      "mobile_no": number.value,
      "device_token": deviceToken ?? await FirebaseMessaging.instance.getToken()
    };
    try {
      ResLogin data = await userRepository.userLogin(params);
      print(data.data!.image);
      print("datadatadatadata");
      await updateLoginDataInFirebase(data);
    } catch (error) {
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
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

  updateLoginDataInFirebase(ResLogin data) async {
    await FirebaseDatabase.instance.goOnline();
    String uniqueId = await getDeviceId() ?? '';
    String firebaseNodeUrl = 'astrologer/${data.data?.id}';
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    firebaseDatabase
        .ref()
        .child(firebaseNodeUrl)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        print("userStatus  New user");
        FirebaseUserData firebaseUserData = FirebaseUserData(
            data.data!.name!,
            deviceToken ?? FirebaseMessaging.instance.getToken().toString(),
            data.data!.image ?? "",
            RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0));
        firebaseDatabase
            .ref()
            .child(firebaseNodeUrl)
            .set(firebaseUserData.toJson());
        navigateToDashboard(data);
      } else {
        print("userStatus existing user");
        HashMap<String, dynamic> realTime = HashMap();
        realTime["uniqueId"] = uniqueId; // Add to HashMap
        HashMap<String, dynamic> deviceTokenNode = HashMap();
        deviceTokenNode["deviceToken"] = deviceToken; // Add to HashMap
        firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
        firebaseDatabase
            .ref()
            .child("$firebaseNodeUrl/realTime")
            .update(realTime);
        navigateToDashboard(data);
      }
      final appFirebaseService = AppFirebaseService();

      appFirebaseService.readData('$firebaseNodeUrl/realTime');
    });
  }

  navigateToDashboard(ResLogin data) async {
    preferenceService.erase();
    preferenceService.setUserDetail(data.data!);
    preferenceService.setToken(data.token!);
    preferenceService.setDeviceToken(deviceToken ?? "");
    Get.offAllNamed(RouteName.dashboard);
    //Get.offAllNamed(RouteName.dashboard, arguments: [data.data!.phoneNo, data.data!.sessionId]);
  }

  removeAttempts() {
    if (attempts.value > 0) {
      attempts.value = attempts.value - 1;
    }
  }
}
