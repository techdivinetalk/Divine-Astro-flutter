import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class KundliViewWidget extends StatelessWidget {
  final NewChatController? controller;
  final   ChatMessage chatDetail;
  final bool yourMessage;
  KundliViewWidget({required this.chatDetail, required this.yourMessage, this.controller});



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.buttonDisableColor),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        chatDetail.kundliName?[0] ??
                            chatDetail.kundli?.kundliName[0] ??
                            '',
                        style: AppTextStyle.textStyle24(
                            fontColor: appColors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w), 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatDetail.kundliName ??
                              chatDetail.kundli?.kundliName ??
                              "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: appColors.textColor,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          chatDetail.kundliDateTime ??
                              chatDetail.kundli?.kundliDateTime ??
                              "",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: appColors.disabledGrey,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          chatDetail.kundliPlace ??
                              chatDetail.kundli?.kundliPlace ??
                              "",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: appColors.disabledGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (chatDetail.msgType != "warningMsg")
                  Text(
                    messageDateTime(int.parse(chatDetail.time.toString())),
                    style: AppTextStyle.textStyle10(
                      fontColor: appColors.textColor,
                    ),
                  ),
                SizedBox(width: 5),
                Obx(() => (msgType.value == 0 || msgType.value == 0) &&
                        chatDetail.seenStatus == 0
                    ? Assets.images.icSingleTick.svg()
                    : (msgType.value == 1 || msgType.value == 0) &&
                            chatDetail.seenStatus == 1
                        ? Assets.images.icDoubleTick.svg(
                            colorFilter: ColorFilter.mode(
                                appColors.greyColor, BlendMode.srcIn))
                        : (msgType.value == 3 || msgType.value == 0) &&
                                chatDetail.seenStatus == 3
                            ? Assets.images.icDoubleTick.svg()
                            : Assets.images.icSingleTick.svg())
              ],
            ).pOnly(right: 10, bottom: 10),*/
          ],
        ),
      ),
    );
  }
}
