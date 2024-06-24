
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';

import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/screens/order_chat_call_feedback/widget/chat_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../gen/assets.gen.dart';

class AudioViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
   AudioViewWidget({required this.chatDetail, required this.yourMessage, this.controller});

  @override
  Widget build(BuildContext context) {
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
                    offset: const Offset(0.0, 3.0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AbsorbPointer(
                  absorbing: controller!.isAudioPlaying.value,
                  child: VoiceMessageView(
                      controller: VoiceController(
                          audioSrc: chatDetail.awsUrl ??
                              "" /*?? chatDetail.message ?? ""*/,
                          maxDuration: const Duration(minutes: 30),
                          isFile: false,
                          onComplete: () {
                            controller!.isAudioPlaying(false);
                          },
                          onPause: () {
                            controller!.isAudioPlaying(false);
                          },
                          onPlaying: () {
                            print(
                                "value of audio playing ${controller!.isAudioPlaying.value}");
                            if (controller!.isAudioPlaying.value) {
                              Fluttertoast.showToast(
                                  msg: "Audio is Already playing");
                            } else {
                              controller!.isAudioPlaying(true);
                            }
                          }),
                      innerPadding: 0,
                      cornerRadius: 20),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        messageDateTime(int.parse(chatDetail.time.toString())),
                        style: AppTextStyle.textStyle10(
                            fontColor: appColors.black),
                      ),
                      // if (yourMessage) SizedBox(width: 8.w),
                      // if (yourMessage)
                      //   chatDetail.type == 0
                      //       ? Assets.images.icSingleTick.svg()
                      //       : chatDetail.type == 1
                      //       ? Assets.images.icDoubleTick.svg(
                      //       colorFilter: ColorFilter.mode(
                      //           appColors.disabledGrey,
                      //           BlendMode.srcIn))
                      //       : chatDetail.type == 3
                      //       ? Assets.images.icDoubleTick.svg()
                      //       : Assets.images.icSingleTick.svg()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
