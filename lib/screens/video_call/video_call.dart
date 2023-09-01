import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text('Demo Video/Voice Page')),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCall()));
              },
              child: Text(
                'Video Call',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceCall()));
              },
              child: Text(
                'Audio Call',
              ),
            ),
            Divider(),
            Text('With Invitation'),
            ZegoInviteButton(isVideoCall: true),
            ZegoInviteButton(isVideoCall: false),
          ],
        ),
      ),
    );
  }
}

class ZegoInviteButton extends StatelessWidget {
  final bool isVideoCall;

  const ZegoInviteButton({super.key, required this.isVideoCall});

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      onPressed: (String code, String message, List<String> list) {},
      isVideoCall: isVideoCall,
      resourceID: "zegouikit_call", // For offline call notification
      invitees: [
        ZegoUIKitUser(
          id: '2',
          name: 'Astrologer',
        ),
        ZegoUIKitUser(
          id: '1',
          name: 'Customer',
        ),
      ],
    );
  }
}

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: yourAppID,
      appSign: yourAppSign,
      userID: '1',
      userName: 'Astrologer',
      callID: '1_2',
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..avatarBuilder = (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
          return user != null
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://your_server/app/avatar/${user.id}.png',
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        }
        ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
          foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
            return user != null
                ? Positioned(
                    bottom: 5,
                    left: 5,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://your_server/app/avatar/${user.id}.png',
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          },
        )
        ..layout = ZegoLayout.pictureInPicture(
          switchLargeOrSmallViewByClick: true,
        )
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}

class VoiceCall extends StatefulWidget {
  const VoiceCall({super.key});

  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: yourAppID,
      appSign: yourAppSign,
      userID: '1',
      userName: 'Astrologer',
      callID: '1_2',
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..onOnlySelfInRoom = (context) {
          Navigator.of(context).pop();
        }
        ..topMenuBarConfig = ZegoTopMenuBarConfig(hideAutomatically: true)
        ..onHangUpConfirmation = (context) async {
          Navigator.of(context).pop();
        },
    );
  }
}
