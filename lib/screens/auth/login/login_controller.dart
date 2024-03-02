import 'dart:collection';
import 'dart:developer';

import 'package:device_apps/device_apps.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';

import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/model/firebase_model.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/true_caller_divine/true_caller_divine_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import '../../../common/app_exception.dart';
import '../../../common/routes.dart';
import '../../../di/shared_preference_service.dart';
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

  var isLoading = false.obs;
  login() async {
    //deviceToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> params = {
      "mobile_no": mobileNumberController.text,
      "country_code": countryCodeController.text,
      //"device_token": await FirebaseMessaging.instance.getToken()
    };
    try {
      isLoading.value = true;
      final data = await userRepository.sentOtp(params);
      if (data != null) {
        isLoading.value = false;
        navigateToOtpPage(data);
      } else {
        isLoading.value = false;
      }
      update();
      //updateLoginDatainFirebase(data);
      //navigateToDashboard(data);
    } catch (error) {
      isLoading.value = false;
      enable.value = true;
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(
            data: error.toString(),
            color: appColors.redColor,
            duration: const Duration(milliseconds: 200));
      }
    }
  }

  void navigateToOtpPage(SendOtpModel data) {
    Get.toNamed(RouteName.otpVerificationPage, arguments: [
      data.data?.mobileNo,
      data.data?.sessionId,
      countryCodeController.text
    ]);
    mobileNumberController.clear();
    enable.value = true;
  }

  // navigateToDashboard(ResLogin data) async {
  //   preferenceService.erase();
  //   preferenceService.setUserDetail(data.data!);
  //   preferenceService.setToken(data.token!);
  //   mobileNumberController.clear();
  //   preferenceService.setDeviceToken(deviceToken ?? "");
  //   final socket = AppSocket();
  //   socket.socketConnect();
  //   Get.offAllNamed(RouteName.dashboard, arguments: [data.data!.phoneNo, data.data!.sessionId]);
  //   enable.value = true;
  // }

  RxBool showTrueCaller = false.obs;

  @override
  void onInit() {
    // isLogOut = false;
    super.onInit();
    getLoginImages();
    countryCodeController = TextEditingController(text: "+91");
    mobileNumberController = TextEditingController(text: "");
    TrueCallerService().isTrueCallerInstalled().then((value) {
      showTrueCaller.value = value;
    });

    TcSdk.streamCallbackData.listen(
      (TcSdkCallback event) async {
        switch (event.result) {
          case TcSdkCallbackResult.success:
            TcOAuthData oAuth = event.tcOAuthData ?? TcOAuthData.fromJson({});
            String authCode = oAuth.authorizationCode;
            String stateReceivedFromServer = oAuth.state;
            List<dynamic> scopesGranted = oAuth.scopesGranted;
            log("TrueCallerService: event: result: success");
            log("TrueCallerService: event: OAuth: $oAuth");
            log("TrueCallerService: event: authCode: $authCode");
            log("TrueCallerService: event: state: $stateReceivedFromServer");
            log("TrueCallerService: event: scopes: $scopesGranted");

            await onSuccess(authCode: authCode);
            break;

          case TcSdkCallbackResult.failure:
            int errorCode = event.error?.code ?? 0;
            String errorMessage = event.error?.message ?? "";
            log("TrueCallerService: event: result: failure");
            log("TrueCallerService: event: errorCode: $errorCode");
            log("TrueCallerService: event: errorMessage: $errorMessage");
            break;

          case TcSdkCallbackResult.verification:
            int errorCode = event.error?.code ?? 0;
            String errorMessage = event.error?.message ?? "";
            log("TrueCallerService: event: result: verification");
            log("TrueCallerService: event: errorCode: $errorCode");
            log("TrueCallerService: event: errorMessage: $errorMessage");
            break;

          case TcSdkCallbackResult.missedCallInitiated:
            String ttl = event.ttl ?? "";
            String requestNonce = event.requestNonce ?? "";
            log("TrueCallerService: event: result: missedCallInitiated");
            log("TrueCallerService: event: ttl: $ttl");
            log("TrueCallerService: event: requestNonce: $requestNonce");
            break;

          case TcSdkCallbackResult.missedCallReceived:
            log("TrueCallerService: event: result: missedCallReceived");
            break;

          case TcSdkCallbackResult.otpInitiated:
            String ttl = event.ttl ?? "";
            String requestNonce = event.requestNonce ?? "";
            log("TrueCallerService: event: result: otpInitiated");
            log("TrueCallerService: event: ttl: $ttl");
            log("TrueCallerService: event: requestNonce: $requestNonce");
            break;

          case TcSdkCallbackResult.otpReceived:
            String otp = event.otp ?? "";
            log("TrueCallerService: event: result: otpReceived");
            log("TrueCallerService: event: otp: $otp");
            break;

          case TcSdkCallbackResult.verifiedBefore:
            String firstName = event.profile?.firstName ?? "";
            String lastName = event.profile?.lastName ?? "";
            String phNo = event.profile?.phoneNumber ?? "";
            String token = event.profile?.accessToken ?? "";
            String requestNonce = event.requestNonce ?? "";
            log("TrueCallerService: event: result: verifiedBefore");
            log("TrueCallerService: event: firstName: $firstName");
            log("TrueCallerService: event: lastName: $lastName");
            log("TrueCallerService: event: phNo: $phNo");
            log("TrueCallerService: event: token: $token");
            log("TrueCallerService: event: requestNonce: $requestNonce");
            break;

          case TcSdkCallbackResult.verificationComplete:
            String accessToken = event.accessToken ?? "";
            String requestNonce = event.requestNonce ?? "";
            log("TrueCallerService: event: result: verificationComplete");
            log("TrueCallerService: event: accessToken: $accessToken");
            log("TrueCallerService: event: requestNonce: $requestNonce");
            break;

          case TcSdkCallbackResult.exception:
            int exceptionCode = event.exception?.code ?? 0;
            String exceptionMsg = event.exception?.message ?? "";
            log("TrueCallerService: event: result: exception");
            log("TrueCallerService: event: exceptionCode: $exceptionCode");
            log("TrueCallerService: event: exceptionMsg: $exceptionMsg");
            break;

          default:
            log("TrueCallerService: event: result: default");
            break;
        }
      },
    );
  }

  String advertisingId = "";
  String token = "";

  Future<void> onSuccess({required String authCode}) async {
    log("TrueCallerService: onSuccess(): authCode: $authCode");

    String accessToken = "";
    Map<String, dynamic> profile = {};

    accessToken = await TrueCallerService().getToken(authCode: authCode);
    log("TrueCallerService: onSuccess(): accessToken: $accessToken");

    profile = await TrueCallerService().getProfile(accessToken: accessToken);
    log("TrueCallerService: onSuccess(): profile: $profile");

    if (profile.isEmpty) {
      //
    } else {
      await customerLoginWithTrueCaller(profile);
    }
    return Future<void>.value();
  }

  // Future<String> getAdvertisingId() async {
  //   final String advertisingId = await AdvertisingId.id(true) ?? "";
  //   this.advertisingId = advertisingId;
  //   return Future<String>.value(advertisingId);
  // }

  Future<String> getToken() async {
    final String token = await FirebaseMessaging.instance.getToken() ?? "";
    this.token = token;
    return Future<String>.value(token);
  }

  String getPhoneNumberFromTrueCaller(Map<String, dynamic> profile) {
    String phoneNumber = "";
    if (profile["phone_number"] != null) {
      if (profile["phone_number"] != "") {
        phoneNumber = profile["phone_number"];
        if (phoneNumber.length > 10 && phoneNumber.startsWith("91")) {
          phoneNumber = phoneNumber.substring(2);
        } else {}
      } else {}
    } else {}
    return phoneNumber;
  }

  Future<void> customerLoginWithTrueCaller(Map<String, dynamic> profile) async {
    final Map<String, dynamic> params = {
      "mobile_no": getPhoneNumberFromTrueCaller(profile),
      "device_token": await getToken(),
      // "gaid": await getAdvertisingId(),
      "verify_by": "TrueCaller",
    };
    ResLogin data = ResLogin();
    data = await userRepository.astrologerLoginWithTrueCaller(params: params);
    await updateLoginDataInFirebase(data);
    return Future<void>.value();
  }

  Future<void> updateLoginDataInFirebase(ResLogin data) async {
    final String uniqueId = await getDeviceId() ?? '';
    final String firebaseNodeUrl = 'astrologer/${data.data?.id}';
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = firebaseDatabase.ref();
    // ref.child(firebaseNodeUrl).onValue.listen(
    //   (DatabaseEvent event) {
    //     if (event.snapshot.value == null) {
    //       FirebaseUserData userData = FirebaseUserData(
    //         data.data?.name ?? "",
    //         deviceToken ?? FirebaseMessaging.instance.getToken().toString(),
    //         data.data?.image ?? "",
    //         RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0),
    //       );
    //       firebaseDatabase.ref().child(firebaseNodeUrl).set(userData.toJson());
    //       navigateToDashboard(data);
    //     } else {
    //       HashMap<String, dynamic> realTime = HashMap();
    //       realTime["uniqueId"] = uniqueId;
    //       HashMap<String, dynamic> deviceTokenNode = HashMap();
    //       deviceTokenNode["deviceToken"] = deviceToken;
    //       firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
    //       firebaseDatabase
    //           .ref()
    //           .child("$firebaseNodeUrl/realTime")
    //           .update(realTime);
    //       navigateToDashboard(data);
    //     }
    //     final appFirebaseService = AppFirebaseService();
    //     appFirebaseService.readData('$firebaseNodeUrl/realTime');
    //   },
    // );

    final DataSnapshot dataSnapshot = await ref.child(firebaseNodeUrl).get();
    if (dataSnapshot.exists) {
      HashMap<String, dynamic> realTime = HashMap();
      realTime["uniqueId"] = uniqueId;
      HashMap<String, dynamic> deviceTokenNode = HashMap();
      deviceTokenNode["deviceToken"] =
          deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "";
      firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
      firebaseDatabase
          .ref()
          .child("$firebaseNodeUrl/realTime")
          .update(realTime);
      navigateToDashboard(data);
    } else {
      FirebaseUserData userData = FirebaseUserData(
        data.data?.name ?? "",
        deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "",
        data.data?.image ?? "",
        RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0),
      );
      firebaseDatabase.ref().child(firebaseNodeUrl).set(userData.toJson());
      navigateToDashboard(data);
    }
  }

  void navigateToDashboard(ResLogin data) {
    preferenceService.erase();
    preferenceService.setUserDetail(data.data ?? UserData());
    preferenceService.setToken(data.token ?? "");
    preferenceService.setDeviceToken(deviceToken ?? "");
    Get.offAllNamed(RouteName.dashboard);
  }

  @override
  void onReady() async {
    super.onReady();

    showTrueCaller.value = await TrueCallerService().isTrueCallerInstalled();
    DeviceApps.listenToAppsChanges().listen((ApplicationEvent event) async {
      showTrueCaller.value = await TrueCallerService().isTrueCallerInstalled();
    });
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
    "To proceed as an astrologer, enter your registered mobile number.",
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

    //added by: dev-dharam
    Get.find<SharedPreferenceService>().setAmazonUrl(response.data.baseurl);
    //

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
