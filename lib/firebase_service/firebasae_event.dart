import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

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

  Future<FirebaseEvent> init() async {
    isPlatformCheck();
    analytics = FirebaseAnalytics.instance;
    return this;
  }

  void loginUser(json) {
    FirebaseAnalytics.instance.logLogin(
        loginMethod: "astrologer_loggedIn",
        parameters: json,
        callOptions: AnalyticsCallOptions(global: true));
  }

  void loginUserCustomEvent(json) {
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
  void home_screen(json) {
    FirebaseAnalytics.instance.logEvent(name: "home_screen", parameters: json);
  }

  // Done
  void performance_screen(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "performance_screen", parameters: json);
  }

  // Done
  void assistant_screen(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "assistant_screen", parameters: json);
  }

  // Done
  void waitlist_screen(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "waitlist_screen", parameters: json);
  }

  // Done
  void profile_screen(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "profile_screen", parameters: json);
  } // Done

  void chat_event(json) {
    FirebaseAnalytics.instance.logEvent(name: "chat_status", parameters: json);
  }

// Done
  void call_event(json) {
    FirebaseAnalytics.instance.logEvent(name: "call_status", parameters: json);
  }

// Done
  void go_live(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrologer_go_live", parameters: json);
  }

  void update_app(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrologer_app_updated", parameters: json);
  }

  void astrolgoer_in_chat(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrolgoer_in_chat", parameters: json);
  }

  void astrolgoer_enable_offer(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrolgoer_enable_offer", parameters: json);
  }

  void exotel_call_chat_assistants(json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrologer_exotel_call_assistant", parameters: json);
  }

  // Done
  void on_the_accept_screen(Map<String, Object>? json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrologer_on_accept_screen", parameters: json)
        .then((onValue) {
      print("--- Done");
    }).onError((Object error, StackTrace stackTrace) {
      print("--- ${error.toString()}");
    });
  } // Done

  void acceptChatByAstrologer(Map<String, Object>? json) {
    FirebaseAnalytics.instance
        .logEvent(name: "astrologer_accept_chat", parameters: json)
        .then((onValue) {
      print("--- Done");
    }).onError((Object error, StackTrace stackTrace) {
      print("--- ${error.toString()}");
    });
  }

  void logoutMyAccountEvent(json) {
    print("Logouthere");
    print(json.toString());
    FirebaseAnalytics.instance
        .logEvent(name: "Logout_My_Astrologer_Account", parameters: json);
  }

  void deleteAstrologerAccount(json) {
    print("delete_astrologer_account");
    print(json.toString());
    FirebaseAnalytics.instance
        .logEvent(name: "delete_astrologer_account", parameters: json);
  }

  void languageAstrologerChange(json) {
    print("delete_astrologer_account");
    print(json.toString());
    FirebaseAnalytics.instance
        .logEvent(name: "language_change_astrologer", parameters: json);
  }

  void isInAcceptChatScreen(Map<String, dynamic> json1) {
    Map<String, Object> json = json1.cast<String, Object>();
    analytics.logEvent(name: "astrologer_accept_chat_screen", parameters: json);
  }

  void isChatAccept(Map<String, dynamic> json1) {
    Map<String, Object> json = json1.cast<String, Object>();
    analytics.logEvent(name: "astrologer_chat_accept", parameters: json);
  }

  void astrologer_in_chat(Map<String, dynamic> json1) {
    Map<String, Object> json = json1.cast<String, Object>();
    analytics.logEvent(name: "astrologer_in_chat", parameters: json);
  }

  void astrologer_end_chat(Map<String, dynamic> json1) {
    Map<String, Object> json = json1.cast<String, Object>();
    analytics.logEvent(name: "astrologer_end_chat", parameters: json);
  }
}
