import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  static final ZegoService _singleton = ZegoService._internal();

  factory ZegoService() {
    return _singleton;
  }

  ZegoService._internal();

  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  Future<void> zegoLogin() async {
    String userID = (_pref.getUserDetail()?.id ?? "").toString();
    String userName = _pref.getUserDetail()?.name ?? "";
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      androidNotificationConfig: ZegoAndroidNotificationConfig(
        channelID: "ZegoUIKit",
        channelName: "Call Notifications",
        sound: "accept_ring",
        icon: "call",
      ),
    );
    print("ZegoService: zegoLogin(): $userID - $userName");
    Future<void>.value();
  }

  Widget buttonUI({
    required bool isVideoCall,
    required String targetUserID,
    required String targetUserName,
  }) {
    print("ZegoService: buttonUI(): $targetUserID - $targetUserName");
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideoCall,
      resourceID: "zegouikit_call",
      invitees: [
        ZegoUIKitUser(id: targetUserID, name: targetUserName),
      ],
    );
  }

  Future<void> zegoLogout() async {
    print("ZegoService: zegoLogout()");
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    Future<void>.value();
  }
}
