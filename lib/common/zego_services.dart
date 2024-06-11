// import 'package:divine_astrologer/screens/live_page/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// class ZegoServices {
//   initZegoInvitationServices(String userId, String name) async {
//     await ZegoUIKitPrebuiltCallInvitationService().init(
//       appID: yourAppID,
//       appSign: yourAppSign,
//       userID: '2',
//       userName: 'Astrologer',
//       ringtoneConfig:  ZegoRingtoneConfig(
//           /*incomingCallPath: "assets/ringtone/incomingCallRingtone.mp3",
//         outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",*/
//           ),
//       plugins: [ZegoUIKitSignalingPlugin()],
//       requireConfig: (ZegoCallInvitationData data) {
//         var config = (data.invitees.length > 1)
//             ? ZegoCallType.videoCall == data.type
//                 ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//                 : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//             : ZegoCallType.videoCall == data.type
//                 ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//                 : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

//         config.avatarBuilder =
//             (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
//           return user != null
//               ? Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         'https://your_server/app/avatar/${user.id}.png',
//                       ),
//                     ),
//                   ),
//                 )
//               : const SizedBox();
//         };
//         config.layout = ZegoLayout.pictureInPicture(
//           switchLargeOrSmallViewByClick: true,
//         );
//         return config;
//       },
//     );
//   }

//   unInitZegoInvitationServices() async {
//     await ZegoUIKitPrebuiltCallInvitationService().uninit();
//   }
// }
