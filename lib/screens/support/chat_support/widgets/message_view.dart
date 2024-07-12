import 'package:cached_network_image/cached_network_image.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_socket/app_socket.dart';
import '../../../../common/app_textstyle.dart';
import '../../../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../../../model/chat_offline_model.dart';

final socket = AppSocket();

class SupportMessagView extends StatelessWidget {
  final int index;
  final chatMessage;
  final controller;
  final bool yourMessage;
  final nextMessage;
  final int length;
  final int? unreadMessage;
  final dynamic pref, argumentId, engageType;

  const SupportMessagView({
    super.key,
    required this.index,
    required this.chatMessage,
    required this.nextMessage,
    required this.yourMessage,
    required this.length,
    this.unreadMessage,
    this.pref,
    this.argumentId,
    this.controller,
    this.engageType,
  });

  Widget buildMessageView(BuildContext context, currentMsg, bool yourMessage,
      socket, pref, argumentId, engageType) {
    // final currentMsgDate = DateTime.fromMillisecondsSinceEpoch(
    //     int.parse(currentMsg['createdAt'] ?? '0'));
    // final nextMsgDate = DateTime.fromMillisecondsSinceEpoch(
    //     int.parse(nextMessage['createdAt'] ?? '0'));

    Widget messageWidget;
    switch (chatMessage['msgType']) {
      case MsgType.text:
        messageWidget = textMsgView(context, chatMessage, yourMessage);
        break;
      case MsgType.image:
        messageWidget = imageMsgView(chatDetail: chatMessage);
      default:
        messageWidget = const SizedBox.shrink();
    }

    // Conditionally add unreadMessageView() based on chat
    return Column(
      children: [
        if (index == length - 1) messageWidget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMessageView(context, chatMessage, yourMessage, socket, pref,
        argumentId, engageType);
  }

  Widget imageMsgView({required chatDetail}) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 5.w,
                ),
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
                        imageUrl: chatDetail['message'] ?? '',
                        fit: BoxFit.cover,
                        height: 200.h,
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Container(
                    //         padding: const EdgeInsets.symmetric(horizontal: 6)
                    //             .copyWith(left: 10),
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.only(
                    //               bottomRight: Radius.circular(10.r)),
                    //           gradient: LinearGradient(
                    //             colors: [
                    //               appColors.textColor.withOpacity(0.0),
                    //               appColors.textColor.withOpacity(0.0),
                    //               appColors.textColor.withOpacity(0.5),
                    //             ],
                    //             begin: Alignment.topLeft,
                    //             end: Alignment.bottomCenter,
                    //           ),
                    //         ),
                    //         child: Text(
                    //           msgTimeFormat(chatDetail['createdAt'].toString()),
                    //           style: AppTextStyle.textStyle10(
                    //               fontColor: appColors.white),
                    //         ),
                    //       ),
                    //       SizedBox(width: 8.w),
                    //     ],
                    //   ),
                    // ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget textMsgView(BuildContext context, currentMsg, bool yourMessage) {
    // RxInt msgType = (chatMessage.msgType ?? 0).obs;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: (currentMsg['sendBy']) == SendBy.astrologer
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 5.w,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0)),
                ],
                color: (currentMsg['sendBy']) == SendBy.customer
                    ? AppColors().white
                    : Color.fromRGBO(255, 238, 240, 1),
                border: Border.all(
                    color: (currentMsg['sendBy']) == SendBy.customer
                        ? AppColors().lightGrey
                        : Color.fromRGBO(239, 186, 190, 1.0)),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(14),
                  topLeft: (currentMsg['sendBy']) == SendBy.customer
                      ? Radius.circular(0)
                      : Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  topRight: (currentMsg['sendBy']) == SendBy.customer
                      ? Radius.circular(14)
                      : Radius.circular(0),
                )),
            constraints: BoxConstraints(
                maxWidth: ScreenUtil().screenWidth * 0.7,
                minWidth: ScreenUtil().screenWidth * 0.27),
            child: Stack(
              alignment: (currentMsg['sendBy']) == SendBy.customer
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              children: [
                Column(
                  children: [
                    Wrap(
                        alignment: (currentMsg['sendBy']) == SendBy.astrologer
                            ? WrapAlignment.end
                            : WrapAlignment.start,
                        children: [
                          Text(currentMsg['message'] ?? "",
                              maxLines: 100,
                              style: AppTextStyle.textStyle14(
                                  fontColor: appColors.textColor))
                        ]),
                    SizedBox(height: 20.h)
                  ],
                ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: Row(
                //     children: [
                //       Text(msgTimeFormat(currentMsg['createdAt'].toString()),
                //           style: AppTextStyle.textStyle10(
                //               fontColor: appColors.textColor)),
                //       SizedBox(width: 3.w),
                //       // if ((currentMsg.sendBy) == SendBy.customer)
                //       // chatSeenStatusWidget(
                //       //     seenStatus:
                //       //         currentMsg.seenStatus ?? SeenStatus.sent)
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
