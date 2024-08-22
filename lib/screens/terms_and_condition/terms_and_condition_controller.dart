import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:divine_astrologer/common/app_exception.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/constants.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_authentication.dart';
import 'package:divine_astrologer/main.dart';
import 'package:divine_astrologer/model/pivacy_policy_model.dart';
import 'package:divine_astrologer/model/res_login.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionController extends GetxController {
  RxBool isIAgree = false.obs;
  String mobile = "";
  String? deviceToken;
  RxBool isLoading = false.obs;
  RxBool isReadDone = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(scrollListener);
    if (Get.arguments != null) {
      mobile = Get.arguments["mobile"];
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
    super.onInit();
  }

  void scrollListener() {
    if (scrollController.position.atEdge) {
      bool isTop = scrollController.position.pixels == 0;
      if (!isTop) {
        isReadDone.value = true;
      } else {
        isReadDone.value = false;
      }
    } else {
      isReadDone.value = false;
    }
  }

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    return userRepository.getPrivacyPolicy();
  }

  Future<void> astroLogin() async {
    if (isIAgree.value) {
      isLoading.value = true;
      print(
          "UserStatus login api ${await FirebaseMessaging.instance.getToken()}");
      Map<String, dynamic> params = {
        "mobile_no": mobile,
        "device_token":
            deviceToken ?? await FirebaseMessaging.instance.getToken(),
        "device_os": Platform.isIOS ? 2 : 1,
      };
      try {
        ResLogin data = await userRepository.userLogin(params);

        await preferenceService.erase();
        await preferenceService.setUserDetail(data.data!);
        await preferenceService.setToken(data.token!);
        await preferenceService.setDeviceToken(deviceToken ?? "");
        log('😈😈😈😈😈😈😈😈');
        log(jsonEncode(data.data));
        if (data.data != null) {
          var commonConstants = await userRepository.constantDetailsData();
          if (commonConstants.data != null) {
            imageUploadBaseUrl.value =
                commonConstants.data?.imageUploadBaseUrl ?? "";
          }
          if (commonConstants.data!.token != null) {
            print(
                "commonConstants.data!.token----->>>>${commonConstants.data!.token}");
            customTokenWithFirebase(
              token: commonConstants.data!.token,
            );
          } else {
            if (commonConstants.data!.firebaseAuthEmail != null &&
                commonConstants.data!.firebaseAuthPassword != null) {
              Auth().handleSignInEmail(commonConstants.data!.firebaseAuthEmail!,
                  commonConstants.data!.firebaseAuthPassword!);
            }
          }
          updateLoginDataInFirebase(data);
        }
      } catch (error) {
        isLoading.value = false;
        update();
        debugPrint("error $error");
        if (error is AppException) {
          error.onException();
        } else {
          divineSnackBar(data: error.toString(), color: appColors.redColor);
        }
      }
    } else {
      update();
      divineSnackBar(
          data: "Please agree to our privacy policy.",
          color: appColors.redColor);
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
    print(realTime);
    print("updating in firebase");
    final HashMap<String, dynamic> deviceTokenNode = HashMap();

    deviceTokenNode["deviceToken"] =
        deviceToken ?? await FirebaseMessaging.instance.getToken() ?? "";
    firebaseDatabase.ref().child(firebaseNodeUrl).update(deviceTokenNode);
    firebaseDatabase.ref().child("$firebaseNodeUrl/realTime").update(realTime);
    navigateToDashboard(data);
    return Future<void>.value();
  }

  navigateToDashboard(ResLogin data) async {
    print("beforeGoing ${preferenceService.getUserDetail()?.id}");
    //_counterSubscription.cancel();
    if (Constants.isUploadMode) {
      await initServices();
    }
    Future.delayed(
      const Duration(seconds: 1),
      () => Get.offAllNamed(RouteName.dashboard),
    );
    isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}
