import 'package:divine_astrologer/zego_call/home_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZegoLoginScreen extends StatefulWidget {
  const ZegoLoginScreen({super.key});

  @override
  State<ZegoLoginScreen> createState() => _ZegoLoginScreenState();
}

class _ZegoLoginScreenState extends State<ZegoLoginScreen> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: _editingController),
            ElevatedButton(
              onPressed: () async {
                await onUserLogin();
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ZegoHomeScreen();
                      },
                    ),
                  );
                }
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onUserLogin() async {
    String userID = _editingController.value.text;
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 696414715,
      appSign:
          "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa",
      userID: "654321",
      userName: "user_654321",
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  void onUserLogout() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}
