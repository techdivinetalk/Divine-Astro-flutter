import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZegoHomeScreen extends StatefulWidget {
  const ZegoHomeScreen({super.key});

  @override
  State<ZegoHomeScreen> createState() => _ZegoHomeScreenState();
}

class _ZegoHomeScreenState extends State<ZegoHomeScreen> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: _editingController),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button() {
    String targetUserID = _editingController.value.text;
    return ZegoSendCallInvitationButton(
      isVideoCall: true,
      resourceID: "zegouikit_call",
      invitees: [
        ZegoUIKitUser(
          // id: targetUserID,
          // name: "user_$targetUserID",
          id: "123456",
          name: "user_123456",
        ),
      ],
    );
  }
}
