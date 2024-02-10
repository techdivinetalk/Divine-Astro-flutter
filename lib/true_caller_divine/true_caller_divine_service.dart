import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:http/http.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:uuid/uuid.dart';

class TrueCallerService {
  static final TrueCallerService _singleton = TrueCallerService._internal();

  factory TrueCallerService() {
    return _singleton;
  }

  TrueCallerService._internal();

  String codeVerifier = "";
  String oAuthState = "";

  Future<void> startTrueCaller() async {
    const int sdkOption = TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS;
    log("TrueCallerService: start(): sdkOption: $sdkOption");

    final dynamic init = TcSdk.initializeSDK(
      sdkOption: sdkOption,
      consentHeadingOption: TcSdkOptions.SDK_CONSENT_HEADING_LOG_IN_TO,
      footerType: TcSdkOptions.FOOTER_TYPE_ANOTHER_MOBILE_NO,
      ctaText: TcSdkOptions.CTA_TEXT_PROCEED,
      buttonShapeOption: TcSdkOptions.BUTTON_SHAPE_ROUNDED,
      buttonColor: appColors.yellow.value,
      buttonTextColor: appColors.black.value,
    );
    log("TrueCallerService: start(): init: $init");

    final bool isOAuthFlowUsable = await TcSdk.isOAuthFlowUsable;
    log("TrueCallerService: start(): isOAuthFlowUsable: $isOAuthFlowUsable");

    if (isOAuthFlowUsable) {
      oAuthState = const Uuid().v4();
      log("TrueCallerService: start(): oAuthState: $oAuthState");

      TcSdk.setOAuthState(oAuthState);
      TcSdk.setOAuthScopes(['profile', 'phone', 'openid', 'offline_access']);

      final dynamic codeVerifier = await TcSdk.generateRandomCodeVerifier;
      log("TrueCallerService: start(): codeVerifier: $codeVerifier");

      final dynamic codeChallenge =
          await TcSdk.generateCodeChallenge(codeVerifier);
      log("TrueCallerService: start(): codeChallenge: $codeChallenge");

      if (codeChallenge != null) {
        this.codeVerifier = codeVerifier;
        TcSdk.setCodeChallenge(codeChallenge);
        TcSdk.getAuthorizationCode;
      } else {}
    } else {}
    return Future<void>.value();
  }

  Future<String> getToken({required String authCode}) async {
    String accessToken = "";
    final Response response = await post(
      Uri.parse('https://oauth-account-noneu.truecaller.com/v1/token'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "authorization_code",
        "client_id": "qz4fupwn14zc1qt0hcljoq5dkbxpbo6ki_tv3jgrphq",
        "code": authCode,
        "code_verifier": codeVerifier,
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      accessToken = jsonDecode(response.body)["access_token"] ?? "";
    } else {}
    return Future<String>.value(accessToken);
  }

  Future<Map<String, dynamic>> getProfile({required String accessToken}) async {
    Map<String, dynamic> profile = {};
    final Response response = await get(
      Uri.parse('https://oauth-account-noneu.truecaller.com/v1/userinfo'),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == HttpStatus.ok) {
      profile = jsonDecode(response.body) ?? {};
    } else {}
    return Future<Map<String, dynamic>>.value(profile);
  }

  Future<bool> isOAuthFlowUsable() async {
    const sdkOption = TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS;
    final init = TcSdk.initializeSDK(sdkOption: sdkOption);
    final bool isOAuthFlowUsable = await TcSdk.isOAuthFlowUsable;
    log("TrueCallerService: isOAuthFlowUsable(): isOAuthFlowUsable: $isOAuthFlowUsable");
    return Future<bool>.value(isOAuthFlowUsable);
  }

  Future<bool> isTrueCallerInstalled() async {
    bool isInstalled = await DeviceApps.isAppInstalled('com.truecaller');
    log("TrueCallerService: isTrueCallerInstalled(): isInstalled: $isInstalled");
    return Future<bool>.value(isInstalled);
  }
}
