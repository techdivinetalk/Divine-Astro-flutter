import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../di/shared_preference_service.dart';

class FirebaseEvent extends GetxService {
  late FirebaseAnalytics analytics;
  late String deviceName;

  void isPlatformCheck() {
    if (Platform.isAndroid) {
      deviceName = "Android";
    } else {
      deviceName = "iOS";
    }
  }

  var preferences = Get.find<SharedPreferenceService>();

  Future<FirebaseEvent> init() async {
    isPlatformCheck();
    analytics = FirebaseAnalytics.instance;
    return this;
  }

  void loginUser(Map<String, dynamic> json) {
    FirebaseAnalytics.instance.logLogin(
        loginMethod: "astrologer_loggedIn",
        callOptions: AnalyticsCallOptions(global: true));
  }

  void loginUserCustomEvent(Map<String, dynamic> json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrologer_loggedIn", parameters: {
      "Login": "",
    });
  }

  void otpVerifiedEvent(Map<String, dynamic> json) {
    FirebaseAnalytics.instance.logEvent(name: "OTP Verified", parameters: {
      "Status": "",
    });
  }

  //Done
  void pageViewEvent(json) {
    FirebaseAnalytics.instance.logEvent(name: "page_view", parameters: json);
  }

  //Done
  void headerClickEvent(json) {
    FirebaseAnalytics.instance.logEvent(name: "header_click", parameters: json);
  }

  // Done
  void languageSelectedEvent(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "language_selected", parameters: json);
  }

  // Done
  void acceptChatByAstrologer(Map<String, Object>? json) {
    analytics
        .logEvent(name: "astrologer_accept_chat", parameters: json)
        .then((onValue) {
      print("--- Done");
    }).onError((Object error, StackTrace stackTrace) {
      print("--- ${error.toString()}");
    });
  }

  void logoutMyAccountEvent(json) {
    print("Logouthere");
    FirebaseAnalytics.instance
        .logEvent(name: "Logout_My_Astrologer_Account", parameters: json);
  }
}
