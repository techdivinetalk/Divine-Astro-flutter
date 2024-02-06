// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:divine_astrologer/common/colors.dart';
// import 'package:divine_astrologer/common/custom_widgets.dart';
// import 'package:divine_astrologer/gen/assets.gen.dart';
// import 'package:divine_astrologer/screens/live_page/constant.dart';
// import 'package:divine_astrologer/screens/video_call/video_call_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class VideoCall extends GetView<VideoCallController> {
//   const VideoCall({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Stack(
//         children: [
//           ZegoUIKitPrebuiltCall(
//             appID: yourAppID,
//             appSign: yourAppSign,
//             userID: '1',
//             userName: 'Astrologer',
//             callID: '1_2',
//             controller: controller.callController,
//             config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//               ..layout = ZegoLayout.pictureInPicture(
//                   switchLargeOrSmallViewByClick: true)
//               ..durationConfig = ZegoCallDurationConfig(isVisible: false)
//               ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
//                   hideAutomatically: false, hideByClick: false, buttons: [])
//               ..topMenuBarConfig = ZegoTopMenuBarConfig(
//                 hideAutomatically: false,
//                 hideByClick: false,
//                 isVisible: false,
//               )
//               ..avatarBuilder = (BuildContext context, Size size,
//                   ZegoUIKitUser? user, Map extraInfo) {
//                 return user != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(100.r),
//                         child: CachedNetworkImage(
//                           imageUrl:
//                               'https://your_server/app/avatar/${user.id}.png',
//                           errorWidget: (context, url, error) => Image.asset(
//                               Assets.images.defaultProfile.path,
//                               fit: BoxFit.cover),
//                         ),
//                       )
//                     : const SizedBox();
//               }
//               /*..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
//                 foregroundBuilder: (BuildContext context, Size size,
//                     ZegoUIKitUser? user, Map extraInfo) {
//                   return user != null
//                       ? Positioned(
//                           bottom: 5,
//                           left: 5,
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               *//*image: DecorationImage(
//                                 image: NetworkImage(
//                                   'https://your_server/app/avatar/${user.id}.png',
//                                 ),
//                               ),*//*
//                             ),
//                           ),
//                         )
//                       : const SizedBox();
//                 },
//               )*/
//               ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
//           ),
//           customAppBar(),
//           customBottomBar(),
//         ],
//       ),
//     );
//   }

//   Widget customBottomBar() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 120.h,
//         decoration: BoxDecoration(
//           color: AppColors.darkBlue,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Obx(
//               () => CustomButton(
//                 onTap: () {
//                   controller.muteValue.value = !controller.muteValue.value;
//                   ZegoUIKit().turnMicrophoneOn(!controller.muteValue.value,
//                       muteMode: controller.muteValue.value);
//                 },
//                 radius: 50.r,
//                 padding: EdgeInsets.all(17.h),
//                 color: controller.muteValue.value
//                     ? AppColors.white.withOpacity(0.2)
//                     : AppColors.transparent,
//                 child: Assets.svg.mute.svg(
//                     width: 30,
//                     colorFilter: const ColorFilter.mode(
//                         AppColors.white, BlendMode.srcIn)),
//               ),
//             ),
//             Obx(
//               () => CustomButton(
//                 onTap: () {
//                   controller.videoValue.value = !controller.videoValue.value;
//                   ZegoUIKit().turnCameraOn(!controller.videoValue.value);
//                 },
//                 radius: 50.r,
//                 padding: EdgeInsets.all(17.h),
//                 color: controller.videoValue.value
//                     ? AppColors.white.withOpacity(0.2)
//                     : AppColors.transparent,
//                 child: Assets.svg.videoMute.svg(
//                     width: 30,
//                     colorFilter: const ColorFilter.mode(
//                         AppColors.white, BlendMode.srcIn)),
//               ),
//             ),
//             CustomButton(
//               onTap: () {},
//               radius: 50.r,
//               padding: EdgeInsets.all(17.h),
//               child: Assets.images.icKundliShare.image(color: AppColors.white),
//             ),
//             CustomButton(
//               onTap: () => controller.onHangUp(),
//               radius: 50.r,
//               padding: EdgeInsets.all(17.h),
//               color: AppColors.darkRed,
//               child: const Icon(
//                 Icons.call_end,
//                 size: 32,
//                 color: AppColors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget customAppBar() {
//     return Container(
//       width: double.maxFinite,
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.blackColor,
//             AppColors.blackColor.withOpacity(0),
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: SafeArea(
//         child: SizedBox(
//           height: AppBar().preferredSize.height,
//           child: Material(
//             color: AppColors.transparent,
//             child: Row(
//               children: [
//                 CustomButton(
//                   onTap: () => Get.back(),
//                   padding: EdgeInsets.all(10.w),
//                   radius: 50.r,
//                   child: const Icon(Icons.arrow_back_ios_new_rounded,
//                       color: AppColors.white),
//                 ),
//                 Obx(
//                   () => CustomText(
//                     '${formattedTime()} Remaining',
//                     fontSize: 16.sp,
//                     fontColor: AppColors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const Spacer(),
//                 CustomButton(
//                   onTap: () {
//                     controller.frontCamValue.value =
//                         !controller.frontCamValue.value;
//                     ZegoUIKit()
//                         .useFrontFacingCamera(controller.frontCamValue.value);
//                   },
//                   radius: 50.r,
//                   padding: EdgeInsets.all(10.h),
//                   color: controller.videoValue.value
//                       ? AppColors.white.withOpacity(0.2)
//                       : AppColors.transparent,
//                   child: Assets.svg.switchCamera.svg(
//                       height: 26,
//                       colorFilter: const ColorFilter.mode(
//                           AppColors.white, BlendMode.srcIn)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String formattedTime() {
//     String duration = '';
//     if (controller.callDuration.value.inHours > 0) {
//       duration =
//           '${controller.callDuration.value.inHours.toString().padLeft(2, '0')}:';
//     }
//     duration =
//         "$duration${(controller.callDuration.value.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.callDuration.value.inSeconds % 60).toString().padLeft(2, '0')}";
//     return duration;
//   }
// }

// class VoiceCall extends StatefulWidget {
//   const VoiceCall({super.key});

//   @override
//   State<VoiceCall> createState() => _VoiceCallState();
// }

// class _VoiceCallState extends State<VoiceCall> {
//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: yourAppID,
//       appSign: yourAppSign,
//       userID: '2',
//       userName: 'Customer',
//       callID: '1_2',
//       controller: ZegoUIKitPrebuiltCallController(),
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
//         ..onOnlySelfInRoom = (context) {
//           Navigator.of(context).pop();
//         }
//         ..topMenuBarConfig = ZegoTopMenuBarConfig(hideAutomatically: true)
//         ..onHangUpConfirmation = (context) async {
//           Navigator.of(context).pop();
//           return null;
//         },
//     );
//   }
// }
