import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/chat_assistant/get_astrologer_chat_by_id_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import '../../../common/app_textstyle.dart';
import '../../../common/common_functions.dart';
import '../../../common/custom_widgets.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/chat_assistant/chat_assistant_chats_response.dart';

class AssistMessageView extends StatelessWidget {
  final int index;
  final AssistChatData chatMessage;
  final bool yourMessage;
  final AssistChatData nextMessage;
  final int? unreadMessage;

  const AssistMessageView({
    super.key,
    required this.index,
    required this.chatMessage,
    required this.nextMessage,
    required this.yourMessage,
    this.unreadMessage,
  });

  Widget buildMessageView(
      BuildContext context, AssistChatData chatMessage, bool yourMessage) {
    Widget messageWidget;
    print("Message Type:: ${chatMessage.chatType} ${chatMessage.message}");
    switch (chatMessage.msgType) {
      case 8:
        messageWidget = giftMsgView(context, chatMessage, yourMessage);
        break;
      // case "Remedies" || 0:
      //   messageWidget = remediesMsgView(context, chatMessage, yourMessage);
      //   break;
      case 0:
        messageWidget = textMsgView(context, chatMessage, yourMessage);
        break;
      // case "audio":
      //   messageWidget = audioView(context, chatDetail: chatMessage, yourMessage: yourMessage);
      //   break;
      // case "image":
      //   messageWidget = imageMsgView(chatMessage.base64Image!, yourMessage, chatDetail: chatMessage, index: index);
      //   break;
      // case "kundli":
      //   messageWidget = kundliView(chatDetail: chatMessage, index: 0);
      //   break;
      default:
        messageWidget = const SizedBox.shrink();
    }

    // Conditionally add unreadMessageView() based on chat
    if (chatMessage.id == unreadMessage) {
      return Column(
        children: [
          unreadMessageView(),
          messageWidget,
        ],
      );
    } else {
      return messageWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildMessageView(context, chatMessage, yourMessage);
  }

  Widget giftMsgView(
      BuildContext context, AssistChatData chatMessage, bool yourMessage) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              border: Border.all(width: 2, color: appColors.appColorDark),
              gradient: LinearGradient(
                colors: [appColors.white, appColors.appColorDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            constraints: BoxConstraints(
                maxWidth: ScreenUtil().screenWidth * 0.8,
                minWidth: ScreenUtil().screenWidth * 0.27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 32,
                //   width: 32,
                //   child: CustomImageWidget(
                //     imageUrl: chatMessage.awsUrl ?? '',
                //     rounded: true,
                //     // added by divine-dharam
                //     typeEnum: TypeEnum.gift,
                //     //
                //   ),
                // ),
                SizedBox(width: 6.w),
                Flexible(child: Text(chatMessage.message ?? ''))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget remediesMsgView(
  //     BuildContext context, AssistChatMsg chatMessage, bool yourMessage) {
  //   var jsonString = (chatMessage.message ?? '')
  //       .substring(1, (chatMessage.message ?? '').length - 1);
  //   List temp = jsonString.split(', ');
  //
  //   print("get templist $temp");
  //
  //   if (temp.length < 2) {
  //     return const SizedBox.shrink();
  //   }
  //   return SizedBox(
  //     width: double.maxFinite,
  //     child: Column(
  //       crossAxisAlignment:
  //       yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //       children: [
  //         Card(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               border: Border.all(
  //                 color: AppColors.yellow,
  //               ),
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             child: ListTile(
  //               leading: CircleAvatar(
  //                 backgroundColor: AppColors.red,
  //                 child: CustomText(
  //                   temp[0][0],
  //                   fontColor: AppColors.white,
  //                 ), // Display the first letter of the name
  //               ),
  //               title: CustomText(
  //                 temp[0],
  //                 fontSize: 14.sp,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               subtitle: CustomText(
  //                 temp[1] ?? '',
  //                 fontSize: 12.sp,
  //                 maxLines: 20,
  //               ),
  //               onTap: () => Get.toNamed(RouteName.remediesDetail,
  //                   arguments: {'title': temp[0], 'subtitle': temp[1]}),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget textMsgView(
      BuildContext context, AssistChatData currentMsg, bool yourMessage) {
    // RxInt msgType = (chatMessage.msgType ?? 0).obs;
    final currentMsgDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(currentMsg.createdAt ?? ''));
    final nextMsgDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(nextMessage.createdAt ?? ''));
    print(
        "is yesterday message ${DateTime.now().compareTo(DateTime.parse(nextMessage.createdAt ?? '')).days}");
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: (currentMsg.msgType ?? 0) == 1
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0)),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              constraints: BoxConstraints(
                  maxWidth: ScreenUtil().screenWidth * 0.7,
                  minWidth: ScreenUtil().screenWidth * 0.27),
              child: Stack(
                alignment: (currentMsg.msgType ?? 1) == 1
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                children: [
                  Column(
                    children: [
                      Wrap(
                          alignment: currentMsg.msgType == 1
                              ? WrapAlignment.end
                              : WrapAlignment.start,
                          children: [
                            Text(currentMsg.message ?? "",
                                maxLines: 30,
                                style: AppTextStyle.textStyle14(
                                    fontColor: (currentMsg.msgType ?? 1) == 1
                                        ? appColors.darkBlue
                                        : appColors.darkBlue))
                          ]),
                      SizedBox(height: 20.h)
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Text(
                            DateFormat.jm().format(
                                DateTime.parse(currentMsg.createdAt ?? '')),
                            style: AppTextStyle.textStyle10(
                                fontColor: appColors.darkBlue)),
                        SizedBox(width: 3.w),
                        if (currentMsg.msgType == 1)
                          chatSeenStatusWidget(
                              msgStatus: currentMsg.msgStatus ?? MsgStatus.sent)

                        // (data.seenStatus ?? 0) == 0
                        //     ? SizedBox(width: 8.w)
                        //     : (data.seenStatus ?? 0) == 1
                        //         ? Assets
                        //             .images.icSingleTick
                        //             .svg()
                        //         : (data.seenStatus ??
                        //                     0) ==
                        //                 2
                        //             ? Assets.images
                        //                 .icDoubleTick
                        //                 .svg()
                        //             : const SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatSeenStatusWidget({required MsgStatus msgStatus}) {
    print('msg status ${msgStatus}');
    switch (msgStatus) {
      case MsgStatus.sent:
        return Assets.images.icSingleTick
            .svg(theme: SvgTheme(currentColor: appColors.grey));
      case MsgStatus.delivered:
        return Assets.images.icDoubleTick
            .svg(theme: SvgTheme(currentColor: appColors.grey));
      case MsgStatus.received:
        return Assets.images.icDoubleTick.svg();
      default:
        return const SizedBox();
    }
  }

  // Widget audioView(BuildContext context,
  //     {required AssistChatMsg chatDetail, required bool yourMessage}) {
  //   RxInt msgType = (chatDetail.msgType ?? 0).obs;
  //   return SizedBox(
  //     width: double.maxFinite,
  //     child: Column(
  //       crossAxisAlignment:
  //       yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8.0),
  //           clipBehavior: Clip.antiAlias,
  //           decoration: BoxDecoration(
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.black.withOpacity(0.2),
  //                   blurRadius: 3.0,
  //                   offset: const Offset(0.0, 3.0))
  //             ],
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(8.r)),
  //           ),
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               VoiceMessageView(
  //                   controller: VoiceController(
  //                       audioSrc: chatDetail.awsUrl!,
  //                       maxDuration: const Duration(seconds: 120),
  //                       isFile: false,
  //                       onComplete: () => debugPrint("onComplete"),
  //                       onPause: () => debugPrint("onPause"),
  //                       onPlaying: () => debugPrint("onPlaying")),
  //                   innerPadding: 0,
  //                   cornerRadius: 20),
  //               Positioned(
  //                 bottom: 0,
  //                 right: 0,
  //                 child: Row(
  //                   children: [
  //                     Text(
  //                       messageDateTime(chatDetail.createdAt ?? 0),
  //                       style: AppTextStyle.textStyle10(
  //                           fontColor: AppColors.black),
  //                     ),
  //                     if (yourMessage) SizedBox(width: 8.w),
  //                     if (yourMessage)
  //                       msgType.value == 0
  //                           ? Assets.images.icSingleTick.svg()
  //                           : msgType.value == 1
  //                           ? Assets.images.icDoubleTick.svg(
  //                           colorFilter: ColorFilter.mode(
  //                               AppColors.lightGrey, BlendMode.srcIn))
  //                           : msgType.value == 3
  //                           ? Assets.images.icDoubleTick.svg()
  //                           : Assets.images.icSingleTick.svg()
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget imageMsgView(String image, bool yourMessage,
  //     {required AssistChatMsg chatDetail, required int index}) {
  //   // Uint8List bytesImage = const Base64Decoder().convert(image);
  //   Uint8List bytesImage = base64.decode(image);
  //   RxInt msgType = (chatDetail.msgType ?? 0).obs;
  //   var chatController = Get.find<ChatWithAstrologerController>();
  //   return SizedBox(
  //     width: double.maxFinite,
  //     child: Column(
  //       crossAxisAlignment:
  //       yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //             padding: const EdgeInsets.all(8.0),
  //             clipBehavior: Clip.antiAlias,
  //             decoration: BoxDecoration(
  //               boxShadow: [
  //                 BoxShadow(
  //                     color: Colors.black.withOpacity(0.2),
  //                     blurRadius: 3.0,
  //                     offset: const Offset(0.0, 3.0)),
  //               ],
  //               color: Colors.white,
  //               borderRadius: BorderRadius.all(Radius.circular(8.r)),
  //             ),
  //             constraints: BoxConstraints(
  //                 maxWidth: ScreenUtil().screenWidth * 0.7,
  //                 minWidth: ScreenUtil().screenWidth * 0.27),
  //             child: yourMessage
  //                 ? Stack(
  //               children: [
  //                 Image.memory(
  //                   bytesImage,
  //                   fit: BoxFit.cover,
  //                   height: 200.h,
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   right: 0,
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 6)
  //                         .copyWith(left: 10),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.only(
  //                           bottomRight: Radius.circular(10.r)),
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           AppColors.darkBlue.withOpacity(0.0),
  //                           AppColors.darkBlue.withOpacity(0.0),
  //                           AppColors.darkBlue.withOpacity(0.5),
  //                         ],
  //                         begin: Alignment.topLeft,
  //                         end: Alignment.bottomCenter,
  //                       ),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Text(
  //                           messageDateTime(chatDetail.createdAt ?? 0),
  //                           style: AppTextStyle.textStyle10(
  //                               fontColor: AppColors.white),
  //                         ),
  //                         if (yourMessage) SizedBox(width: 8.w),
  //                         if (yourMessage)
  //                           msgType.value == 0
  //                               ? Assets.images.icSingleTick.svg()
  //                               : msgType.value == 1
  //                               ? Assets.images.icDoubleTick.svg(
  //                               colorFilter: ColorFilter.mode(
  //                                   AppColors.greyColor,
  //                                   BlendMode.srcIn))
  //                               : msgType.value == 3
  //                               ? Assets.images.icDoubleTick.svg()
  //                               : Assets.images.icSingleTick.svg()
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             )
  //                 : chatDetail.downloadedPath == ""
  //                 ? Stack(
  //               alignment: Alignment.center,
  //               children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(10.0.sp),
  //                   child: ImageFiltered(
  //                     imageFilter:
  //                     ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //                     child: Image.network(
  //                       chatDetail.awsUrl ?? '',
  //                       fit: BoxFit.cover,
  //                       height: 200.h,
  //                     ),
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     chatController.downloadImage(
  //                         fileName: image,
  //                         chatDetail: chatDetail,
  //                         index: index);
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: AppColors.darkBlue.withOpacity(0.3),
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Icon(Icons.download_rounded,
  //                         color: AppColors.white),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   right: 0,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 6)
  //                             .copyWith(left: 10),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.only(
  //                               bottomRight: Radius.circular(10.r)),
  //                           gradient: LinearGradient(
  //                             colors: [
  //                               AppColors.darkBlue.withOpacity(0.0),
  //                               AppColors.darkBlue.withOpacity(0.0),
  //                               AppColors.darkBlue.withOpacity(0.5),
  //                             ],
  //                             begin: Alignment.topLeft,
  //                             end: Alignment.bottomCenter,
  //                           ),
  //                         ),
  //                         child: Text(
  //                           messageDateTime(chatDetail.time ?? 0),
  //                           style: AppTextStyle.textStyle10(
  //                               fontColor: AppColors.white),
  //                         ),
  //                       ),
  //                       SizedBox(width: 8.w),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             )
  //                 : InkWell(
  //               onTap: () {
  //                 Get.toNamed(RouteName.imagePreviewUi,
  //                     arguments: chatDetail.downloadedPath);
  //               },
  //               child: Stack(
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(8.0.r),
  //                     child: Image.file(
  //                       File(chatDetail.downloadedPath ?? ""),
  //                       fit: BoxFit.cover,
  //                       height: 200.h,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  // Widget kundliView({required AssistChatMsg chatDetail, required int index}) {
  //   return InkWell(
  //     onTap: () {
  //       /*  Get.toNamed(RouteName.kundliDetail, arguments: {
  //         "kundli_id": chatDetail.kundliId,
  //         "from_kundli": true,
  //         "birth_place": chatDetail.kundliPlace,
  //         "gender": chatDetail.gender,
  //         "name": chatDetail.kundliName,
  //       });*/
  //       debugPrint("KundliId : ${chatDetail.kundliId}");
  //     },
  //     child: Card(
  //       color: AppColors.white,
  //       surfaceTintColor: AppColors.white,
  //       child: Container(
  //         padding: EdgeInsets.all(12.h),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                   shape: BoxShape.circle, color: appColors.dimGrey),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(15.0),
  //                 child: Text(
  //                   chatDetail.kundliName?[0] ?? "",
  //                   style: AppTextStyle.textStyle24(
  //                       fontColor: appColors.white,
  //                       fontWeight: FontWeight.w600),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 15.w),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     chatDetail.kundliName ?? "",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 16.sp,
  //                       color: appColors.darkBlue,
  //                     ),
  //                   ),
  //                   SizedBox(height: 5.h),
  //                   Text(
  //                     chatDetail.kundliDateTime ?? "",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 10.sp,
  //                       color: appColors.lightGrey,
  //                     ),
  //                   ),
  //                   SizedBox(height: 5.h),
  //                   Text(
  //                     chatDetail.kundliPlace ?? "",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 10.sp,
  //                       color: AppColors.lightGrey,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.only(top: 15),
  //               child: Icon(
  //                 Icons.keyboard_arrow_right,
  //                 size: 35,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget unreadMessageView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: appColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text("unreadMessages".tr),
      ),
    );
  }
}
