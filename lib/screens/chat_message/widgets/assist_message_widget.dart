import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/routes.dart';
import '../../../gen/assets.gen.dart';
import '../../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../../utils/custom_extension.dart';

class AssistMessageView extends StatelessWidget {
  final int index;
  final AssistChatData chatMessage;
  final bool yourMessage;
  final AssistChatData nextMessage;
  final bool? unreadMessage;

  const AssistMessageView({
    super.key,
    required this.index,
    required this.chatMessage,
    required this.nextMessage,
    required this.yourMessage,
    this.unreadMessage,
  });

  Widget dayWidget(
      {required DateTime currentMsgDate,
        required DateTime nextMsgDate,
        required bool isToday,
        required bool isYesterday,
        required int differenceOfDays}) {
    if (differenceOfDays >= 1) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: appColors.yellow),
          child: Text(
            isToday
                ? 'Today'
                : isYesterday
                ? 'Yesterday'
                : '${DateFormat('EEEE ,dd MMMM').format(nextMsgDate)}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget buildMessageView(
      BuildContext context, AssistChatData currentMsg, bool yourMessage) {
    final currentMsgDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(currentMsg.createdAt ?? '0'));
    final nextMsgDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(nextMessage.createdAt ?? '0'));
    final differenceOfDays = nextMsgDate.day - currentMsgDate.day;
    final isToday = (DateTime.now().day - currentMsgDate.day) == 1;
    final isYesterday = (DateTime.now().day - currentMsgDate.day) == 2;

    Widget messageWidget;
    switch (chatMessage.msgType) {
      case MsgType.gift:
        messageWidget = giftMsgView(context, chatMessage, yourMessage);
        break;
      case MsgType.image:
        messageWidget = imageMsgView(chatDetail: chatMessage);
        break;
      case MsgType.text:
        messageWidget = textMsgView(context, chatMessage, yourMessage);
        break;
      default:
        messageWidget = const SizedBox.shrink();
    }

    // Conditionally add unreadMessageView() based on chat
    // if (unreadMessage ?? false) {
    //   return Column(
    //     children: [
    //       Row(
    //         children: [
    //           Expanded(
    //               child: Container(
    //             height: 2,
    //             padding: EdgeInsets.symmetric(horizontal: 5),
    //             color: appColors.appYellowColour,
    //           )),
    //           Text(
    //             'Unread Messages',
    //             style: TextStyle(color: appColors.appYellowColour),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 5),
    //             height: 2,
    //             color: appColors.appYellowColour,
    //           )
    //         ],
    //       ),
    //       messageWidget
    //     ],
    //   );
    // }

    return Column(
      children: [
        // unreadMessageView(),
        messageWidget,
        dayWidget(
            currentMsgDate: currentMsgDate,
            nextMsgDate: nextMsgDate,
            isToday: isToday,
            isYesterday: isYesterday,
            differenceOfDays: differenceOfDays)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMessageView(context, chatMessage, yourMessage);
  }

  Widget imageMsgView({required AssistChatData chatDetail}) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              constraints: BoxConstraints(
                  maxWidth: ScreenUtil().screenWidth * 0.7,
                  minWidth: ScreenUtil().screenWidth * 0.27),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0.sp),
                    child: CachedNetworkImage(
                      imageUrl:  chatDetail.message ?? '',
                      fit: BoxFit.cover,
                      height: 200.h,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6)
                              .copyWith(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.r)),
                            gradient: LinearGradient(
                              colors: [
                                appColors.darkBlue.withOpacity(0.0),
                                appColors.darkBlue.withOpacity(0.0),
                                appColors.darkBlue.withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(
                            // messageDateTime(chatDetail. ?? 0),
                            msgTimeFormat(chatDetail.createdAt),
                            style: AppTextStyle.textStyle10(
                                fontColor: appColors.white),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget giftMsgView(
      BuildContext context, AssistChatData chatMessage, bool yourMessage) {
    return SizedBox(
      width: double.infinity,

      child: Align(

        child: Container(
          padding: EdgeInsets.symmetric( vertical: 8.h),
          margin: EdgeInsets.symmetric(vertical: 10.w,),
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
              const Icon(Icons.card_giftcard, size: 15),
              SizedBox(width: 6.w),
              Flexible(
                  child: Text("You have Received ${chatMessage.message}" ?? ''))
            ],
          ),
        ),
      ),
    );
  }

  Widget textMsgView(
      BuildContext context, AssistChatData currentMsg, bool yourMessage) {
    // RxInt msgType = (chatMessage.msgType ?? 0).obs;
    final currentMsgDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(currentMsg.createdAt ?? '0'));
    final nextMsgDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(nextMessage.createdAt ?? '0'));
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: (currentMsg.sendBy) == SendBy.astrologer
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
                alignment: (currentMsg.sendBy) == SendBy.astrologer
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                children: [
                  Column(
                    children: [
                      Wrap(
                          alignment: (currentMsg.sendBy) == SendBy.astrologer
                              ? WrapAlignment.end
                              : WrapAlignment.start,
                          children: [
                            Text(currentMsg.message ?? "",
                                maxLines: 100,
                                style: AppTextStyle.textStyle14(
                                    fontColor: appColors.darkBlue))
                          ]),
                      SizedBox(height: 20.h)
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Text(msgTimeFormat(currentMsg.createdAt),
                            style: AppTextStyle.textStyle10(
                                fontColor: appColors.darkBlue)),
                        SizedBox(width: 3.w),
                        if ((currentMsg.sendBy) == SendBy.astrologer)
                          chatSeenStatusWidget(
                              seenStatus:
                                  currentMsg.seenStatus ?? SeenStatus.sent)
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget chatSeenStatusWidget({required SeenStatus seenStatus}) {
    print('msg status ${seenStatus}');
    switch (seenStatus) {
      case SeenStatus.notSent:
        return const SizedBox();
      case SeenStatus.sent:
        return Assets.images.icSingleTick
            .svg(theme: SvgTheme(currentColor: appColors.grey));
      case SeenStatus.delivered:
        return Assets.images.icDoubleTick
            .svg(theme: SvgTheme(currentColor: appColors.grey));
      case SeenStatus.received:
        return Assets.images.icDoubleTick.svg();
      default:
        return const SizedBox();
    }
  }

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
