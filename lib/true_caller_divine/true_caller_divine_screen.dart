import 'dart:async';
import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/true_caller_divine/true_caller_divine_service.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:device_apps/device_apps.dart';

class TrueCallerDivine extends StatefulWidget {
  const TrueCallerDivine({super.key});

  @override
  State<TrueCallerDivine> createState() => _TrueCallerDivineState();
}

class _TrueCallerDivineState extends State<TrueCallerDivine> {
  late StreamSubscription streamSubscription;
  Map<String, dynamic> responseJson = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    streamSubscription = TcSdk.streamCallbackData.listen(
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

  Future<void> onSuccess({required String authCode}) async {
    String accessToken = "";
    Map<String, dynamic> profile = {};

    accessToken = await TrueCallerService().getToken(authCode: authCode);
    log("TrueCallerService: onSuccess(): accessToken: $accessToken");

    profile = await TrueCallerService().getProfile(accessToken: accessToken);
    log("TrueCallerService: onSuccess(): profile: $profile");

    responseJson = profile;
    log("TrueCallerService: onSuccess(): responseJson: $responseJson");

    setState(() {});
    return Future<void>.value();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: JsonViewer(responseJson)),
            ElevatedButton(
              onPressed: TrueCallerService().startTrueCaller,
              child: const Text("Log-in with TrueCaller"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool oAuthFlowUsable = false;
                oAuthFlowUsable = await TrueCallerService().isOAuthFlowUsable();

                false
                    ? await TrueCallerService().startTrueCaller()
                    : divineSnackBar(
                        data:trueCallerFaultPopup();
                            "Please check TrueCaller app whether you're logged-in or not.",
                        color: appColors.guideColor,
                      );
              },
              child: const Text("Log-in with TrueCaller"),
            ),
          ],
        ),
      ),
    );
  }
}
