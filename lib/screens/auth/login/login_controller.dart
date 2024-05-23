
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';

import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:truecaller_sdk/truecaller_sdk.dart';

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
  final appFirebaseService = AppFirebaseService();

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

  Future<void> requestPermissions() async {
    debugPrint("test_: requestPermissions");
    // Request phone and location permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.locationWhenInUse,
    ].request();

    // Check the status of each permission
    if (statuses[Permission.phone]!.isGranted) {
      debugPrint("Phone permission granted");
      getSimNumbers();
    } else {
      debugPrint("Phone permission denied");
    }

    // if (statuses[Permission.locationWhenInUse]!.isGranted) {
    //   debugPrint("Location permission granted");
    // } else {
    //   debugPrint("Location permission denied");
    // }

    // Optionally handle other permission statuses (denied, restricted, permanentlyDenied)
    if (statuses[Permission.phone]!.isPermanentlyDenied) {
      // Open app settings if the permission is permanently denied
      openAppSettings();
    }
  }

  static const platform = MethodChannel('app.divine.astrologer/sim_info');
  List<String> simNumbers = [];



  Future<void> getSimNumbers() async {
    debugPrint("test_simNumbers: _getSimNumbers");

    try {
      final List<dynamic> result = await platform.invokeMethod('getSimNumbers');

      List<String> simNoLst = [];
      simNoLst = result.cast<String>();

      if (simNoLst.isNotEmpty) {
        for (int i = 0; i < simNoLst.length; i++) {
          String no = simNoLst[i];

          // empty no removed
          if (no.isNotEmpty) {
            // Added + sign before country code
            if (!no.startsWith("+")) {
              no = "+$no";
              simNumbers.add(no);
            } else {
              simNumbers.add(no);
            }
          }
        }

        showSimNumbersPopup();
      }

      debugPrint("test_simNumbers: ${simNumbers.length}");
    } on PlatformException catch (e) {
      debugPrint("test_simNumbers: ${e.message.toString()}");
    }
  }

  Map<String, String> splitNumber(String number) {
    if (number.startsWith('+')) {
      number = number.substring(1);
    }
    if (number.length > 10) {
      number = number.substring(number.length - 10);
    }
    return {'countryCode': '+91', 'phoneNumber': number};
  }

  void showSimNumbersPopup() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Continue with',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.poppins,
              fontSize: 18.sp,
              color: appColors.grey,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: simNumbers.map((number) {
              return ListTile(
                leading: const Icon(Icons.phone),
                title: Text(
                  number,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.poppins,
                    fontSize: 16.sp,
                    color: appColors.black,
                  ),
                ),
                onTap: () {
                  final splitResult = splitNumber(number);
                  String countryCode = splitResult['countryCode'] ?? '+91';
                  debugPrint("test_countryCode: $countryCode");

                  String phoneNumber = splitResult['phoneNumber'] ?? '';
                  debugPrint("test_phoneNumber: $phoneNumber");

                  countryCodeController.text = countryCode;
                  mobileNumberController.text = phoneNumber;
                  update();
                  Get.back();
                },
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'NONE OF THE ABOVE',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.poppins,
                  fontSize: 18.sp,
                  color: appColors.trueCallerButton,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onInit() {
    // isLogOut = false;
    super.onInit();
    // getLoginImages();
    countryCodeController = TextEditingController(text: "+91");
    mobileNumberController = TextEditingController(text: "");

    // if (isTruecaller.value == 1) {
    //   TrueCallerService().isTrueCallerInstalled().then((value) {
    //     showTrueCaller.value = value;
    //
    //     debugPrint("test_showTrueCaller.value_3: ${showTrueCaller.value}");
    //     // if (!showTrueCaller.value) {
    //     //   requestPermissions();
    //     // }
    //   });
    //   TcSdk.streamCallbackData.listen(
    //     (TcSdkCallback event) async {
    //       switch (event.result) {
    //         case TcSdkCallbackResult.success:
    //           TcOAuthData oAuth = event.tcOAuthData ?? TcOAuthData.fromJson({});
    //           String authCode = oAuth.authorizationCode;
    //           String stateReceivedFromServer = oAuth.state;
    //           List<dynamic> scopesGranted = oAuth.scopesGranted;
    //           log("TrueCallerService: event: result: success");
    //           log("TrueCallerService: event: OAuth: $oAuth");
    //           log("TrueCallerService: event: authCode: $authCode");
    //           log("TrueCallerService: event: state: $stateReceivedFromServer");
    //           log("TrueCallerService: event: scopes: $scopesGranted");
    //
    //           await onSuccess(authCode: authCode);
    //           break;
    //
    //         case TcSdkCallbackResult.failure:
    //           int errorCode = event.error?.code ?? 0;
    //           String errorMessage = event.error?.message ?? "";
    //           log("TrueCallerService: event: result: failure");
    //           log("TrueCallerService: event: errorCode: $errorCode");
    //           log("TrueCallerService: event: errorMessage: $errorMessage");
    //           break;
    //
    //         case TcSdkCallbackResult.verification:
    //           int errorCode = event.error?.code ?? 0;
    //           String errorMessage = event.error?.message ?? "";
    //           log("TrueCallerService: event: result: verification");
    //           log("TrueCallerService: event: errorCode: $errorCode");
    //           log("TrueCallerService: event: errorMessage: $errorMessage");
    //           break;
    //
    //         case TcSdkCallbackResult.missedCallInitiated:
    //           String ttl = event.ttl ?? "";
    //           String requestNonce = event.requestNonce ?? "";
    //           log("TrueCallerService: event: result: missedCallInitiated");
    //           log("TrueCallerService: event: ttl: $ttl");
    //           log("TrueCallerService: event: requestNonce: $requestNonce");
    //           break;
    //
    //         case TcSdkCallbackResult.missedCallReceived:
    //           log("TrueCallerService: event: result: missedCallReceived");
    //           break;
    //
    //         case TcSdkCallbackResult.otpInitiated:
    //           String ttl = event.ttl ?? "";
    //           String requestNonce = event.requestNonce ?? "";
    //           log("TrueCallerService: event: result: otpInitiated");
    //           log("TrueCallerService: event: ttl: $ttl");
    //           log("TrueCallerService: event: requestNonce: $requestNonce");
    //           break;
    //
    //         case TcSdkCallbackResult.otpReceived:
    //           String otp = event.otp ?? "";
    //           log("TrueCallerService: event: result: otpReceived");
    //           log("TrueCallerService: event: otp: $otp");
    //           break;
    //
    //         case TcSdkCallbackResult.verifiedBefore:
    //           String firstName = event.profile?.firstName ?? "";
    //           String lastName = event.profile?.lastName ?? "";
    //           String phNo = event.profile?.phoneNumber ?? "";
    //           String token = event.profile?.accessToken ?? "";
    //           String requestNonce = event.requestNonce ?? "";
    //           log("TrueCallerService: event: result: verifiedBefore");
    //           log("TrueCallerService: event: firstName: $firstName");
    //           log("TrueCallerService: event: lastName: $lastName");
    //           log("TrueCallerService: event: phNo: $phNo");
    //           log("TrueCallerService: event: token: $token");
    //           log("TrueCallerService: event: requestNonce: $requestNonce");
    //           break;
    //
    //         case TcSdkCallbackResult.verificationComplete:
    //           String accessToken = event.accessToken ?? "";
    //           String requestNonce = event.requestNonce ?? "";
    //           log("TrueCallerService: event: result: verificationComplete");
    //           log("TrueCallerService: event: accessToken: $accessToken");
    //           log("TrueCallerService: event: requestNonce: $requestNonce");
    //           break;
    //
    //         case TcSdkCallbackResult.exception:
    //           int exceptionCode = event.exception?.code ?? 0;
    //           String exceptionMsg = event.exception?.message ?? "";
    //           log("TrueCallerService: event: result: exception");
    //           log("TrueCallerService: event: exceptionCode: $exceptionCode");
    //           log("TrueCallerService: event: exceptionMsg: $exceptionMsg");
    //           break;
    //
    //         default:
    //           log("TrueCallerService: event: result: default");
    //           break;
    //       }
    //     },
    //   );
    // }
  }

  // String advertisingId = "";
  // String token = "";

  // Future<void> onSuccess({required String authCode}) async {
  //   log("TrueCallerService: onSuccess(): authCode: $authCode");
  //
  //   String accessToken = "";
  //   Map<String, dynamic> profile = {};
  //
  //   accessToken = await TrueCallerService().getToken(authCode: authCode);
  //   log("TrueCallerService: onSuccess(): accessToken: $accessToken");
  //
  //   profile = await TrueCallerService().getProfile(accessToken: accessToken);
  //   log("TrueCallerService: onSuccess(): profile: $profile");
  //
  //   if (profile.isEmpty) {
  //     //
  //   } else {
  //     await customerLoginWithTrueCaller(profile);
  //   }
  //   return Future<void>.value();
  // }

  // Future<String> getAdvertisingId() async {
  //   final String advertisingId = await AdvertisingId.id(true) ?? "";
  //   this.advertisingId = advertisingId;
  //   return Future<String>.value(advertisingId);
  // }

  // Future<String> getToken() async {
  //   final String token = await FirebaseMessaging.instance.getToken() ?? "";
  //   this.token = token;
  //   return Future<String>.value(token);
  // }

  // String getPhoneNumberFromTrueCaller(Map<String, dynamic> profile) {
  //   String phoneNumber = "";
  //   if (profile["phone_number"] != null) {
  //     if (profile["phone_number"] != "") {
  //       phoneNumber = profile["phone_number"];
  //       if (phoneNumber.length > 10 && phoneNumber.startsWith("91")) {
  //         phoneNumber = phoneNumber.substring(2);
  //       } else {}
  //     } else {}
  //   } else {}
  //   return phoneNumber;
  // }

  // Future<void> customerLoginWithTrueCaller(Map<String, dynamic> profile) async {
  //   final Map<String, dynamic> params = {
  //     "mobile_no": getPhoneNumberFromTrueCaller(profile),
  //     "device_token": await getToken(),
  //     // "gaid": await getAdvertisingId(),
  //     "verify_by": "TrueCaller",
  //   };
  //   ResLogin data = ResLogin();
  //   data = await userRepository.astrologerLoginWithTrueCaller(params: params);
  //   await updateLoginDataInFirebase(data);
  //   return Future<void>.value();
  // }

  // Future<void> updateLoginDataInFirebase(ResLogin data) async {
  //   await FirebaseDatabase.instance.goOnline();
  //   final String uniqueId = await getDeviceId() ?? '';
  //   final String firebaseNodeUrl = 'astrologer/${data.data?.id}';
  //   final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  //   final DatabaseReference ref = firebaseDatabase.ref();
  //   final DataSnapshot dataSnapshot = await ref.child(firebaseNodeUrl).get();
  //   final HashMap<String, dynamic> realTime = HashMap();
  //   realTime["uniqueId"] = uniqueId;
  //   realTime["voiceCallStatus"] = (data.data?.callPreviousStatus ?? 0);
  //   realTime["chatStatus"] = (data.data?.chatPreviousStatus ?? 0);
  //   realTime["videoCallStatus"] = (data.data?.videoCallPreviousStatus ?? 0);
  //   realTime["is_call_enable"] = (data.data?.isCall ?? 0) == 1;
  //   realTime["is_chat_enable"] = (data.data?.isChat ?? 0) == 1;
  //   realTime["is_video_call_enable"] = (data.data?.isVideo ?? 0) == 1;
  //   realTime["is_live_enable"] = (data.data?.isLive ?? 0) == 1;
  //   final HashMap<String, dynamic> deviceTokenNode = HashMap();
  //   deviceTokenNode["deviceToken"] =
  //       deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "";
  //   firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
  //   firebaseDatabase.ref().child("$firebaseNodeUrl/realTime").update(realTime);
  //   // if (dataSnapshot.exists) {
  //   //
  //   // } else {
  //   //   final FirebaseUserData userData = FirebaseUserData(
  //   //     data.data?.name ?? "",
  //   //     deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "",
  //   //     data.data?.image ?? "",
  //   //     RealTime(isEngagedStatus: 0, uniqueId: uniqueId, walletBalance: 0),
  //   //   );
  //   //   firebaseDatabase.ref().child(firebaseNodeUrl).set(userData.toJson());
  //   // }
  //   navigateToDashboard(data);
  //   return Future<void>.value();
  // }

  // void navigateToDashboard(ResLogin data) {
  //   preferenceService.erase();
  //   preferenceService.setUserDetail(data.data ?? UserData());
  //   preferenceService.setToken(data.token ?? "");
  //   preferenceService.setDeviceToken(deviceToken ?? "");
  //   Get.offAllNamed(RouteName.dashboard);
  // }

  @override
  void onReady() async {
    super.onReady();

    // showTrueCaller.value = await TrueCallerService().isTrueCallerInstalled();
    // debugPrint("test_showTrueCaller.value_2: ${showTrueCaller.value}");
    //
    // if (!showTrueCaller.value) {
    //   requestPermissions();
    //   return;
    // }
    // DeviceApps.listenToAppsChanges().listen((ApplicationEvent event) async {
    //   showTrueCaller.value = await TrueCallerService().isTrueCallerInstalled();
    //
    //   debugPrint("test_showTrueCaller.value_1: ${showTrueCaller.value}");
    //
    //   //  if (!showTrueCaller.value) {
    //   if (!showTrueCaller.value) {
    //     requestPermissions();
    //     return;
    //   }
    // });

    requestPermissions();
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

  // void getLoginImages() async {
  //   if (preferenceService.getLoginImages() != null) {
  //     loginImages = preferenceService.getLoginImages()!;
  //     update();
  //   } else {
  //     // loginImages = await getInitialLoginImages();
  //     update();
  //   }
  // }

// Future<LoginImages> getInitialLoginImages() async {
//   final response = await userRepository.getInitialLoginImages();
//
//   //added by: dev-dharam
//   Get.find<SharedPreferenceService>().setAmazonUrl(response.data.baseurl);
//   //
//
//   return response;
// }

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
