import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/common/constants.dart';
import 'package:divine_astrologer/di/firebase_network_service.dart';
import 'package:divine_astrologer/di/network_service.dart';
import 'package:divine_astrologer/di/progress_service.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_authentication.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/screens/otp_verification/timer_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/routes.dart';
import '../../model/res_login.dart';
import '../../model/send_otp.dart';
import '../../model/verify_otp.dart';
import '../../repository/user_repository.dart';
import 'package:sms_autofill/sms_autofill.dart';

//var globalToken = "";
class OtpVerificationController extends GetxController with CodeAutoFill {
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
     listenForCode();
    var arguments = Get.arguments;
    if (arguments != null) {
      var args = arguments as List;
      number.value = args.first;
      sessionId = args[1];
      countryCode = args[2];
    }
    try {
      FirebaseMessaging.instance.getToken().then((value) {
        debugPrint(value);
        deviceToken = value;
      });
    } catch (e) {
      print("Error getting FCM token: $e");
      FirebaseCrashlytics.instance.recordError(e, null);
    }
    super.onReady();
  }

  var isResendOtp = false.obs;

  resendOtp() async {
    Map<String, dynamic> params = {"mobile_no": number.value};
    try {
      isResendOtp.value = true;
      SendOtpModel data = await userRepository.sentOtp(params);
      sessionId = data.data!.sessionId!;
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

      // isPrivacyPolicy.value == 1 ? Get.offAllNamed(RouteName.termsAndConditionScreen, arguments: {"mobile" : number.value}) : await astroLogin();
      if(isPrivacyPolicy.value == 1){
        Get.offAllNamed(RouteName.termsAndConditionScreen, arguments: {"mobile" : number.value});
        enableSubmit.value = true;
      } else{
        await astroLogin();
      }
      // enableSubmit.value = true;
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
    print(
        "UserStatus login api ${await FirebaseMessaging.instance.getToken()}");
    Map<String, dynamic> params = {
      "mobile_no": number.value,
      "device_token": deviceToken ?? await FirebaseMessaging.instance.getToken()
    };
    try {
      ResLogin data = await userRepository.userLogin(params);

      await preferenceService.erase();
      await preferenceService.setUserDetail(data.data!);
      await preferenceService.setToken(data.token!);
      await preferenceService.setDeviceToken(deviceToken ?? "");
      log('😈😈😈😈😈😈😈😈');
      log(jsonEncode(data.data));
      print("jsonEncode(data.data)");
      if (data.data != null) {
        var commonConstants = await userRepository.constantDetailsData();
        if(commonConstants.data != null){
          imageUploadBaseUrl.value = commonConstants.data?.imageUploadBaseUrl ?? "";
        }
        if (isCustomToken.value.toString() == "1") {
          print("firebaseAuthEmail");
          await customTokenWithFirebase(
            token: commonConstants.data!.token,
          );
        } else {
          print("firebaseAuthPassword");
          if (commonConstants.data!.firebaseAuthEmail != null &&
              commonConstants.data!.firebaseAuthPassword != null) {
            await Auth().handleSignInEmail(commonConstants.data!.firebaseAuthEmail!,
                commonConstants.data!.firebaseAuthPassword!);
          }
        }
        await updateLoginDataInFirebase(data);
      }
    } catch (error) {
      enableSubmit.value = true;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  customTokenWithFirebase({String? token}) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token!);
      print(userCredential);
      print("Sign-in successful.");
    } on FirebaseAuthException catch (e) {
      print(e.email);
      print("e.emaile.emaile.email");
      switch (e.code) {
        case "invalid-custom-token":
          print("The supplied token is not a Firebase custom auth token.");
          break;
        case "custom-token-mismatch":
          print("The supplied token is for a different Firebase project.");
          break;
        default:
          print("Unkown error.");
      }
    }
  }

  Future<void> updateLoginDataInFirebase(ResLogin data) async {
    await FirebaseDatabase.instance.goOnline();
    final String uniqueId = await getDeviceId() ?? '';
    final String firebaseNodeUrl = 'astrologer/${data.data?.id}';
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    await firebaseDatabase
        .ref()
        .child("$firebaseNodeUrl/realTime/uniqueId")
        .remove();
    //final DatabaseReference ref = firebaseDatabase.ref();
    // final DataSnapshot dataSnapshot = await ref.child(firebaseNodeUrl).get();
    // if (dataSnapshot.exists) {
    final HashMap<String, dynamic> realTime = HashMap();
    realTime["uniqueId"] = uniqueId;
    realTime["voiceCallStatus"] = (data.data?.callPreviousStatus ?? 0);
    realTime["chatStatus"] = (data.data?.chatPreviousStatus ?? 0);
    realTime["videoCallStatus"] = (data.data?.videoCallPreviousStatus ?? 0);
    realTime["is_call_enable"] = (data.data?.isCall ?? 0) == 1;
    realTime["is_chat_enable"] = (data.data?.isChat ?? 0) == 1;
    realTime["is_video_call_enable"] = (data.data?.isVideo ?? 0) == 1;
    realTime["is_live_enable"] = (data.data?.isLive ?? 0) == 1;
    final HashMap<String, dynamic> deviceTokenNode = HashMap();
    deviceTokenNode["deviceToken"] =
        deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "";
    firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
    firebaseDatabase.ref().child("$firebaseNodeUrl/realTime").update(realTime);
    await navigateToDashboard(data);
    // } else {
    //   final FirebaseUserData userData = FirebaseUserData(
    //     data.data?.name ?? "",
    //     deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "",
    //     data.data?.image ?? "",
    //     RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0),
    //   );
    //   firebaseDatabase.ref().child(firebaseNodeUrl).set(userData.toJson());
    //   navigateToDashboard(data);
    // }
    return Future<void>.value();
  }

  // late StreamSubscription<DatabaseEvent> _counterSubscription;
  // Future<void> updateLoginDataInFirebase(ResLogin data) async {
  //   final String uniqueId = await getDeviceId() ?? '';
  //   final String firebaseNodeUrl = 'astrologer/${data.data?.id}';
  //   final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  //   print("resultresultresultresult 411");
  //   _counterSubscription = firebaseDatabase.ref().child(firebaseNodeUrl).onValue.listen(
  //         (DatabaseEvent event) async {
  //           DataSnapshot dataSnapshot = event.snapshot;
  //           if (dataSnapshot.exists) {
  //             print("resultresultresultresult 4");
  //             final HashMap<String, dynamic> realTime = HashMap();
  //             realTime["uniqueId"] = uniqueId;
  //             realTime["voiceCallStatus"] = (data.data?.callPreviousStatus ?? 0);
  //             realTime["chatStatus"] = (data.data?.chatPreviousStatus ?? 0);
  //             realTime["videoCallStatus"] = (data.data?.videoCallPreviousStatus ?? 0);
  //             realTime["is_call_enable"] = (data.data?.isCall ?? 0) == 1;
  //             realTime["is_chat_enable"] = (data.data?.isChat ?? 0) == 1;
  //             realTime["is_video_call_enable"] = (data.data?.isVideo ?? 0) == 1;
  //             realTime["is_live_enable"] = (data.data?.isLive ?? 0) == 1;
  //             final HashMap<String, dynamic> deviceTokenNode = HashMap();
  //             deviceTokenNode["deviceToken"] =
  //                 deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "";
  //             firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
  //             firebaseDatabase
  //                 .ref()
  //                 .child("$firebaseNodeUrl/realTime")
  //                 .update(realTime);
  //             navigateToDashboard(data);
  //           } else {
  //             print("resultresultresultresult 4");
  //             final FirebaseUserData userData = FirebaseUserData(
  //                 data.data?.name ?? "",
  //                 deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "",
  //                 data.data?.image ?? "",
  //           RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0),
  //           );
  //           firebaseDatabase.ref().child(firebaseNodeUrl).set(userData.toJson());
  //           navigateToDashboard(data);
  //           }
  //     },
  //     onError: (Object o) {
  //       print("resultresultresultresult error $o");
  //     },
  //   );
  //   return Future<void>.value();
  // }

  navigateToDashboard(ResLogin data) async {
    print("beforeGoing ${preferenceService.getUserDetail()?.id}");
    //_counterSubscription.cancel();
    if (Constants.isUploadMode) {
      await initServices();
    }
    await Future.delayed(
      const Duration(seconds: 1),
      () => Get.offAllNamed(RouteName.dashboard),
    );
    enableSubmit.value = true;
  }

  removeAttempts() {
    if (attempts.value > 0) {
      attempts.value = attempts.value - 1;
    }
  }

  String? otpCode;

  Future<void> initServices() async {
    if (Constants.isUploadMode) {
      debugPrint("test_initServices: call");
      await Get.putAsync(() => ProgressService().init());
      await Get.putAsync(() => SharedPreferenceService().init());
      await Get.putAsync(() => NetworkService().init());
      await Get.putAsync(() => FirebaseNetworkService().init());

      debugPrint("test_initServices: called");
    }
  }

  void codeUpdated() {
    otpCode = code!;
    pinController.text = code ?? "";
    if (pinController.text.isNotEmpty) {
      verifyOtp();
    }
    update();
  }
}
